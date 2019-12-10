resource "aws_iam_role" "codepipeline_role" {
  name = "${var.name_prefix}-${var.name_suffix}-${var.environment}-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "codebuild.amazonaws.com",
          "codedeploy.amazonaws.com",
          "codepipeline.amazonaws.com"
        ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

data "aws_iam_policy_document" "codepipeline_policy_doc" {
  statement {
    sid = "1"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    resources = [
      "*"
    ]
  }

  statement {
    actions = [
      "iam:CreateRole",
      "iam:GetRole",
      "iam:PassRole",
      "iam:DeleteRole",
      "iam:ListInstanceProfilesForRole"
    ]

    resources = [
      "*"
    ]
  }

  statement {
    actions = [
      "iam:CreatePolicy",
      "iam:DetachRolePolicy",
      "iam:DeletePolicy",
      "iam:GetPolicy",
      "iam:GetPolicyVersion",
      "iam:ListPolicyVersions",
      "iam:AttachRolePolicy",
      "iam:ListAttachedRolePolicies",
      "iam:PutRolePolicy"
    ]

    resources = [
      "*"
    ]
  }

  statement {
    actions = [
      "ec2:CreateNetworkInterface",
      "ec2:DescribeDhcpOptions",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DeleteNetworkInterface",
      "ec2:DescribeSubnets",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeVpcs"
    ]

    resources = [
      "*"
    ]
  }

  statement {
    actions = [
      "s3:*"
    ]

    resources = [
      "*"
    ]
  }

  statement {
    actions = [
      "sns:Publish",
      "sns:CreateTopic",
      "sns:GetTopicAttributes",
      "sns:ListTagsForResource",
      "sns:Subscribe",
      "sns:Unsubscribe",
      "sns:DeleteTopic",
      "sns:GetSubscriptionAttributes"
    ]

    resources = [
      "*"
    ]
  }

  statement {
    actions = [
      "lambda:CreateFunction",
      "lambda:GetFunction",
      "lambda:ListVersionsByFunction"
    ]

    resources = [
      "*"
    ]
  }

  statement {
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetRepositoryPolicy",
      "ecr:DescribeRepositories",
      "ecr:ListImages",
      "ecr:DescribeImages",
      "ecr:BatchGetImage"
    ]

    resources = [
      "*"
    ]
  }

  statement {
    actions = [
      "codebuild:BatchGetBuilds",
      "codebuild:BatchGetProjects",
      "codebuild:StartBuild",
      "codebuild:CreateProject",
      "codebuild:DeleteProject"

    ]

    resources = [
      "*"
    ]
  }

  statement {
    actions = [
      "codepipeline:CreatePipeline",
      "codepipeline:DeletePipeline",
      "codepipeline:GetPipeline"
    ]

    resources = [
      "*"
    ]
  }
}

resource "aws_iam_policy" "codepipeline_policy" {
  name = "codepipeline_policy"
  policy = "${data.aws_iam_policy_document.codepipeline_policy_doc.json}"
}

resource "aws_iam_role_policy_attachment" "codepipeline_attach" {
  role = "${aws_iam_role.codepipeline_role.name}"
  policy_arn = "${aws_iam_policy.codepipeline_policy.arn}"
}

output "role_arn" {
  value = "${aws_iam_role.codepipeline_role.arn}"
}
