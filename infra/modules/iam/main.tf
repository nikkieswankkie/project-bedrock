resource "aws_iam_user" "dev_readonly" {
  name = "dev-readonly"
  tags = { team = "dev" }
}

resource "aws_iam_access_key" "dev_readonly_key" {
  user = aws_iam_user.dev_readonly.name
}
# Attach a policy that allows limited EKS & CloudWatch Logs read ops (example inline)
resource "aws_iam_user_policy" "dev_readonly_policy" {
  user = aws_iam_user.dev_readonly.name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "eks:DescribeCluster",
          "eks:ListClusters",
          "eks:ListFargateProfiles",
          "eks:ListNodegroups",
          "eks:DescribeNodegroup"
        ]
        Effect = "Allow"
        Resource = "*"
      },
      {
        Action = [
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams",
          "logs:GetLogEvents",
          "logs:FilterLogEvents"
        ]
        Effect = "Allow"
        Resource = "*"
      },
      {
        Action = ["s3:ListBucket", "s3:GetObject"], # optional if logs/use S3
        Effect = "Deny",
        Resource = "*"
      }
    ]
  })
}
