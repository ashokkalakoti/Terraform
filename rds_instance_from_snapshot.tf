variable "instance_name" {
  description = "RDS Instance Identifier - Name"
  default = "mysql-rds-instance2"
}

variable "dbuser_name" {
  description = "description"
  default = "mysqldbadmin"
}

variable "dbpassword" {
  description = "RDS Master password"
  default = "Password098761234"
}

variable "snapshot_identifier" {
  description = "description"
  default = "mysql-database-manual-backup"
}

variable "db_subnet_group_name" {
  description = "description"
  default = "default-vpc-0561266052bd6af20"
}

variable "rds_security_group_id" {
  description = "description"
  default = "sg-07de9dec2a5f19ce5"
}


data "aws_db_snapshot" "db_snapshot" {
    most_recent = true
    db_instance_identifier = "mysql-database"
}


resource "aws_db_instance" "rdsinstance" {
  allocated_storage           = 20
  engine                      = "MySQL"
  engine_version              = "5.7.22"
  instance_class              = "db.t2.micro"
  name                        = "appdb"
  password                    = "${var.dbpassword}"
  username                    = "${var.dbuser_name}"
  allow_major_version_upgrade = true
  apply_immediately           = true
  identifier                  = "${var.instance_name}-db"
  db_subnet_group_name        = "${var.db_subnet_group_name}"
  backup_retention_period     = 7
  parameter_group_name        = "default.mysql5.7"
  multi_az                    = false
  port                        = 3306
  backup_window               = "10:30-11:00"
  maintenance_window          = "Sat:11:01-Sat:11:31"
  publicly_accessible         = false
  storage_encrypted           = true
  storage_type                = "gp2"
  vpc_security_group_ids      = ["${var.rds_security_group_id}"]
  final_snapshot_identifier   = "${var.instance_name}-db-final-snapshot"
  skip_final_snapshot         = true
  snapshot_identifier         = "${data.aws_db_snapshot.db_snapshot.id}"
  lifecycle {
    create_before_destroy     = true
    ignore_changes            = ["snapshot_identifier"]
  }
}


## So every time if you want to get latest data from production, just run the Terraform script.