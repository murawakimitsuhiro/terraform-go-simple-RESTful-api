provider "aws" {
  region = "ap-northeast-1"
}

module "ecs-pipeline" {
  source  = "murawakimitsuhiro/ecs-pipeline/aws"
  version = "0.1.1"

  cluster_name        = "go-simple-RESTful-api"
  alb_port            = "80"
  container_port      = "8005"
  app_repository_name = "go-simple-RESTful-api"
  container_name      = "go-simple-RESTful-api"

  git_repository = {
    owner  = "murawakimitsuhiro"
    name   = "terraform-go-simple-RESTful-api"
    branch = "master"
  }

  helth_check_path = "/notes"

  environment_variables = {
    GO_SIMPLE_RESTFUL_DBPORT     = "${module.rds-db.this_db_port}"
    GO_SIMPLE_RESTFUL_DBHOST     = "${module.rds-db.this_db_endpoint}"
    GO_SIMPLE_RESTFUL_DBUSER     = "${module.rds-db.this_db_username}"
    GO_SIMPLE_RESTFUL_DBNAME     = "${module.rds-db.this_db_name}"
    GO_SIMPLE_RESTFUL_DBPASSWORD = "${module.rds-db.this_db_password}"
  }
}

module "rds-db" {
  source  = "ispec-inc/mysql-utf8/rds"
  version = "1.1.1"

  db_name  = "go_simple_RESTful"
  username = "db_user"
  password = "roottest"

  vpc_id     = "${module.ecs-pipeline.vpc_id}"
  subnet_ids = "${module.ecs-pipeline.vpc_public_subnet_ids}"
}
