module "import_key" {
  source            = "../key"
  aws_ssh_key_name = "${var.aws_ssh_key_name}"
}
