{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowS3AccessToFrontendAndStateBuckets",
      "Effect": "Allow",
      "Action": [
        "s3:*"
      ],
      "Resource": [
        "arn:aws:s3:::${bucket_name}",
        "arn:aws:s3:::${bucket_name}/*",
        "arn:aws:s3:::aexils-tf-state-prod",
        "arn:aws:s3:::aexils-tf-state-prod/*"
      ]
    },
    {
      "Sid": "AllowCloudFrontInvalidation",
      "Effect": "Allow",
      "Action": [
        "cloudfront:CreateInvalidation",
        "cloudfront:GetInvalidation",
        "cloudfront:GetDistribution",
        "cloudfront:ListDistributions",
        "cloudfront:GetOriginAccessControl",
        "cloudfront:ListTagsForResource",
        "cloudfront:UpdateDistribution",
        "cloudfront:CreateFunction",
        "cloudfront:DescribeFunction",
        "cloudfront:PublishFunction",
        "cloudfront:GetFunction"
      ],
      "Resource": "*"
    },
    {
      "Sid": "AllowECRPushPull",
      "Effect": "Allow",
      "Action": [
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:GetRepositoryPolicy",
        "ecr:DescribeRepositories",
        "ecr:ListImages",
        "ecr:DescribeImages",
        "ecr:BatchGetImage",
        "ecr:PutImage",
        "ecr:InitiateLayerUpload",
        "ecr:UploadLayerPart",
        "ecr:CompleteLayerUpload",
        "ecr:ListTagsForResource"
      ],
      "Resource": "*"
    },
    {
      "Sid": "AllowLambdaUpdate",
      "Effect": "Allow",
      "Action": [
        "lambda:UpdateFunctionCode",
        "lambda:GetFunction",
        "lambda:GetFunctionConfiguration",
        "lambda:GetPolicy",
        "lambda:ListVersionsByFunction"
      ],
      "Resource": "*"
    },
    {
      "Sid": "AllowDynamoDBAccess",
      "Effect": "Allow",
      "Action": [
        "dynamodb:*"
      ],
      "Resource": "*"
    },
    {
      "Sid": "AllowIAMActions",
      "Effect": "Allow",
      "Action": [
        "iam:GetUser",
        "iam:ListAccessKeys",
        "iam:GetRole",
        "iam:ListAttachedRolePolicies",
        "iam:GetRolePolicy",
        "iam:ListRolePolicies",
        "iam:GetPolicy",
        "iam:GetPolicyVersion",
        "iam:ListAttachedUserPolicies",
        "iam:ListPolicyVersions"
      ],
      "Resource": "*"
    },
    {
      "Sid": "AllowRoute53Access",
      "Effect": "Allow",
      "Action": [
        "route53:ListHostedZones",
        "route53:GetHostedZone",
        "route53:GetChange",
        "route53:ListTagsForResource",
        "route53:ListResourceRecordSets",
        "route53:ChangeResourceRecordSets"
      ],
      "Resource": "*"
    },
    {
      "Sid": "AllowACMActions",
      "Effect": "Allow",
      "Action": [
        "acm:DescribeCertificate",
        "acm:ListCertificates",
        "acm:ListTagsForCertificate"
      ],
      "Resource": "*"
    },
    {
      "Sid": "AllowAPIGatewayActions",
      "Effect": "Allow",
      "Action": [
        "apigateway:GET",
        "apigateway:POST",
        "apigateway:PUT",
        "apigateway:DELETE"
      ],
      "Resource": "*"
    },
    {
      "Sid": "AllowSESActions",
      "Effect": "Allow",
      "Action": [
        "ses:GetIdentityVerificationAttributes"
      ],
      "Resource": "*"
    }
  ]
}
