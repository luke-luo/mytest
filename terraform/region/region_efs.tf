resource "aws_efs_file_system" "pdata_efs" {
  creation_token = "pdata_efs"

  tags = {
    Name = "pdata_efs"
  }
}

resource "aws_efs_mount_target" "pdata_efs_mount_target0" {
  file_system_id = "${aws_efs_file_system.pdata_efs.id}"
  subnet_id      = "${module.b_subnet_public.subnet_id.0}"
  security_groups = [
    "${aws_security_group.pdata_efs.id}",
    "${aws_security_group.sg_pdata.id}",
  ]
}

resource "aws_efs_mount_target" "pdata_efs_mount_target1" {
  file_system_id = "${aws_efs_file_system.pdata_efs.id}"
  subnet_id      = "${module.b_subnet_public.subnet_id.1}"
  security_groups = [
    "${aws_security_group.pdata_efs.id}",
    "${aws_security_group.sg_pdata.id}",
  ]
}