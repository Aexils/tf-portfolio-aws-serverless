data "template_file" "github_actions_policy" {
  template = file("${path.module}/policy.json.tpl")
  vars = {
    bucket_name = var.bucket_name
  }
}

resource "aws_iam_user" "github_actions_deploy" {
  name = var.iam_user_name

  tags = {
    environment = var.environment
  }
}

resource "aws_iam_access_key" "github_actions_deploy" {
  user = aws_iam_user.github_actions_deploy.name
}

resource "aws_iam_policy" "github_actions_full_policy" {
  name        = "${var.iam_user_name}-policy"
  description = "Policy for GitHub Actions to interact with AWS resources"
  policy      = data.template_file.github_actions_policy.rendered
}

resource "aws_iam_user_policy_attachment" "attach_policy" {
  user       = aws_iam_user.github_actions_deploy.name
  policy_arn = aws_iam_policy.github_actions_full_policy.arn
}
