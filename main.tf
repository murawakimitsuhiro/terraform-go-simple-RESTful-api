provider "aws" {
  region = "ap-northeast-1"
}

module "ecs-pipeline" {
  # source  = "murawakimitsuhiro/ecs-pipeline/aws"  # version = "0.1.1"

  source = "../../murawakimitsuhiro/terraform-aws-ecs-pipeline"

  cluster_name        = "go-simple-restful-api"
  alb_port            = "8005"
  container_port      = "8005"
  app_repository_name = "go-simple-restful-api"
  container_name      = "go-simple-resttful-api"

  git_repository = {
    owner  = "murawakimitsuhiro"
    name   = "go-simple-RESTful-api"
    branch = "master"
  }

  helth_check_path = "/ping"

  environment_variables = {
    GO_SIMPLE_RESTFUL_DBPORT     = "${module.rds-db.this_db_port}"
    GO_SIMPLE_RESTFUL_DBHOST     = "${module.rds-db.this_db_endpoint}"
    GO_SIMPLE_RESTFUL_DBUSER     = "${module.rds-db.this_db_username}"
    GO_SIMPLE_RESTFUL_DBNAME     = "${module.rds-db.this_db_name}"
    GO_SIMPLE_RESTFUL_DBPASSWORD = "${module.rds-db.this_db_password}"
  }
}

module "rds-db" {
  #source  = "ispec-inc/mysql-utf8/rds"  #version = "1.1.1"

  source = "../../ispec-inc/terraform-rds-mysql-utf8"

  db_name  = "simplerestful"
  username = "db_user"
  password = "roottest"

  vpc_id     = "${module.ecs-pipeline.vpc_id}"
  subnet_ids = "${module.ecs-pipeline.vpc_public_subnet_ids}"
}
