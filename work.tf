provider "aws" {
    region = "ap-southeast-1"
}
#IAM USER CREATION
locals {
  iam_usr_count = "${csvdecode(file("./iam.csv"))}"
}


resource "aws_iam_user" "user"{
count = length (local.iam_usr_count)
name = local.iam_usr_count[count.index].iamusrname
path = "/"
force_destroy = "true"

}

# IAM User login profile settings - Enforcing user password reset on the first login, and ignore the password change for later  terraform state change

resource "aws_iam_user_login_profile" "profile" {
count = length (local.iam_usr_count)
user = local.iam_usr_count[count.index].iamusrname
 pgp_key = "keybase:ashokkalakoti1"
 password_reset_required = true
lifecycle {
    ignore_changes = ["password_length", "password_reset_required", "pgp_key"]
  }
}

# IAM POLICY CREATION TO ASSUME ROLE
resource "aws_iam_policy" "iam_policy" {
    count     = length (local.iam_usr_count)
    name      = local.iam_usr_count[count.index].policyname
    description = "Grant Assume Role to new TF Created User"

  policy = <<CONTENT
{
  "Version": "2012-10-17",
  "Statement": {
    "Effect": "Allow",
    "Action": "sts:AssumeRole",
    "Resource": [
      "arn:aws:iam::${aws_organizations_account.ou_account_creation[count.index].id}:role/*"
    ]
  }
}
CONTENT
}

#  "arn:aws:iam::${aws_organizations_account.sparx_anudeep_demo[count.index].id}:role/*"

resource "aws_iam_user_policy_attachment" "iam_policy_attach" {
    count = length (local.iam_usr_count)
    user = local.iam_usr_count[count.index].iamusrname
    policy_arn = "${aws_iam_policy.iam_policy[count.index].arn}"
}


# Terraform 0.12 syntax
data "aws_organizations_organization" "default" {}

output "account_ids" {
  value = data.aws_organizations_organization.default.accounts[*].id
}


variable "aws_org_name" {
  default = "mycompanyUsers"
}


resource "aws_organizations_organizational_unit" "organization_unit" {
  name      = "${var.aws_org_name}"
  parent_id = "${data.aws_organizations_organization.default.roots.0.id}"
}


resource "aws_organizations_account" "ou_account_creation" {
  count     = length (local.iam_usr_count)
  name      = local.iam_usr_count[count.index].accountname
  email     = local.iam_usr_count[count.index].email
  role_name = local.iam_usr_count[count.index].rolename
  parent_id = "${aws_organizations_organizational_unit.organization_unit.id}"

  # There is no AWS Organizations API for reading role_name
  lifecycle {
    ignore_changes = ["role_name"]
  }

}

