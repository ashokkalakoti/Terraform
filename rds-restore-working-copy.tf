resource "aws_db_instance" "primary" {
  allocated_storage           = 200
  availability_zone           = "us-east-1c"
  allow_major_version_upgrade = true
  apply_immediately           = true
  backup_retention_period     = 30
  instance_class              = "db.m3.medium"
  identifier                  = "${var.instance_name}-db"
  db_subnet_group_name        = "${aws_db_subnet_group.primary.name}"
  engine                      = "postgres"
  engine_version              = "11.1"
  multi_az                    = false
  port                        = 5432
  backup_window               = "10:30-11:00"
  maintenance_window          = "Sat:11:01-Sat:11:31"
  publicly_accessible         = false
  storage_encrypted           = true
  storage_type                = "gp2"
  vpc_security_group_ids      = ["${aws_security_group.primary.id}"]
  final_snapshot_identifier   = "${var.instance_name}-db-final-snapshot"

  skip_final_snapshot         = true
  snapshot_identifier         = "${var.snapshot_identifier}"

  lifecycle {
    create_before_destroy             = true
    ignore_changes                    = ["snapshot_identifier"]
  }
}