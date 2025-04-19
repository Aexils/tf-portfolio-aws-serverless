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

resource "aws_iam_user_policy" "github_actions_deploy_policy" {
  name   = var.github_actions_deploy_policy_name
  user   = aws_iam_user.github_actions_deploy.name
  policy = data.template_file.github_actions_policy.rendered
}
