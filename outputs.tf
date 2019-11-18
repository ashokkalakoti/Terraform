 /* 
output "this_iam_user_name" {
  description = "The user's name"
  value       = element(concat(aws_iam_user.user.*.name, [""]), 0)
}

output "this_iam_user_arn" {
  description = "The ARN assigned by AWS for this user"
  value       = element(concat(aws_iam_user.user.*.arn, [""]), 0)
}

output "this_iam_user_unique_id" {
  description = "The unique ID assigned by AWS"
  value       = element(concat(aws_iam_user.user.*.unique_id, [""]), 0)
}


output "password" {
  value = "${aws_iam_user_login_profile.profile.*.encrypted_password}"
}


output "this_iam_user_login_profile_key_fingerprint" {
  description = "The fingerprint of the PGP key used to encrypt the password"
  value = element(
    concat(aws_iam_user_login_profile.profile.*.key_fingerprint, [""]),
    0,
  )
}

output "keybase_password_decrypt_command" {
  value = <<EOF
echo "${element(
  concat(aws_iam_user_login_profile.profile.*.encrypted_password, [""]),
  0,
)}" | base64 --decode -i | keybase pgp decrypt
EOF

}
*/
#########################################################################################
output "this_iam_user_name" {
  description = "The user's name"
  value       = element(concat(aws_iam_user.user.*.name, [""]), 0)
}

output "this_iam_user_arn" {
  description = "The ARN assigned by AWS for this user"
  value       = element(concat(aws_iam_user.user.*.arn, [""]), 0)
}

output "this_iam_user_unique_id" {
  description = "The unique ID assigned by AWS"
  value       = element(concat(aws_iam_user.user.*.unique_id, [""]), 0)
}

output "this_iam_user_login_profile_key_fingerprint" {
  description = "The fingerprint of the PGP key used to encrypt the password"
  value = element(
    concat(aws_iam_user_login_profile.profile.*.key_fingerprint, [""]),
    0,
  )
}

output "this_iam_user_login_profile_encrypted_password" {
  description = "The encrypted password, base64 encoded"
  value = element(
    concat(aws_iam_user_login_profile.profile.*.encrypted_password, [""]),
    0,
  )
}


output "keybase_password_decrypt_command" {
  value = <<EOF
echo "${element(
  concat(aws_iam_user_login_profile.profile.*.encrypted_password, [""]),
  0,
)}" | base64 --decode -i | keybase pgp decrypt
EOF

}


output "iam_user_information" {
  value = {
    for iam in aws_iam_user_login_profile.profile:
    iam.user => [ iam.pgp_key, iam.encrypted_password ]
  }
}

/*

output "password" {
  value = "${aws_iam_user_login_profile.profile.*.encrypted_password}"
}

*/