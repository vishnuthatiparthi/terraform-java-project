data "aws_iam_policy_document" "ec2_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "lifecycle_policy_action" {
  statement {
    actions = [
      "autoscaling:CompleteLifecycleAction",
      "autoscaling:DescribeAutoScalingInstances",
      "autoscaling:DescribeLifecycleHooks",
      "autoscaling:DescribeAutoScalingGroups"
    ]

    resources = ["*"]
  }
}

resource "aws_iam_role" "ec2_role" {
  name               = "cheetah-${var.envname}-s3-cw-access-policy-new"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role_policy.json
}

resource "aws_iam_policy" "asg_lifecycle_hook_policy" {
  name        = "cheetah-${var.envname}-asg-lifecycle-policy"
  description = "Allows EC2 to interact with ASG lifecycle hooks"
  policy      = data.aws_iam_policy_document.lifecycle_policy_action.json
}

resource "aws_iam_policy_attachment" "s3_full_access" {
  name       = "cheetah-${var.envname}-s3-access-policy"
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
  roles      = [aws_iam_role.ec2_role.name]
}

resource "aws_iam_policy_attachment" "cloudwatch_agent" {
  name       = "cheetah-${var.envname}-cw-agent-policy"
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  roles      = [aws_iam_role.ec2_role.name]
}

resource "aws_iam_policy_attachment" "asg_lifecycle_hook" {
  name       = "cheetah-${var.envname}-lifecycle-hook-policy"
  policy_arn = aws_iam_policy.asg_lifecycle_hook_policy.arn
  roles      = [aws_iam_role.ec2_role.name]
}