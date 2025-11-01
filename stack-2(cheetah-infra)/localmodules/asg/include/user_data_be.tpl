#!/bin/bash
exec > /var/log/user-data.log 2>&1
set -x

echo "Executing User_Data In ${envname}"

# Update and install Java
yum update -y
yum install java-11-amazon-corretto -y

# Create log directory
mkdir -p /var/log/app/
chown ec2-user:ec2-user /var/log/app/

cd /home/ec2-user

# Download Spring Boot application JAR from S3
aws s3 cp s3://${be_app_bucket}/${jar_file} .

# Set proper permissions on the JAR
chmod 755 ${jar_file}

# Define environment variables and start the app
MYSQL_HOST=jdbc:mysql://${rds_db_endpoint}/datastore?createDatabaseIfNotExist=true \
MYSQL_USERNAME=${rds_db_uname} \
MYSQL_PASSWORD=${rds_db_passwd} \
LOG_FILE_PATH=/var/log/app/datastore.log \
nohup java -jar /home/ec2-user/${jar_file} > /var/log/app/nohup.out 2>&1 &

# Install CloudWatch Agent
yum install -y amazon-cloudwatch-agent

# Create CloudWatch Agent configuration file
cat << EOF > /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json
{
  "logs": {
    "logs_collected": {
      "files": {
        "collect_list": [
          {
            "file_path": "/var/log/app/datastore.log",
            "log_group_name": "/datastore/app",
            "log_stream_name": "{instance_id}",
            "timestamp_format": "%Y-%m-%d %H:%M:%S"
          }
        ]
      }
    }
  }
}
EOF

# Start CloudWatch Agent
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c file:/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json -s

# Completing lifecycle action
TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
INSTANCE_ID=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/instance-id)
REGION=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/dynamic/instance-identity/document | jq -r .region)
aws autoscaling complete-lifecycle-action --lifecycle-hook-name ${hook_name} --auto-scaling-group-name my-asg --instance-id "$INSTANCE_ID" --lifecycle-action-result CONTINUE --region "$REGION"