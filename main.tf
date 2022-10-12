terraform {
  required_providers {
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = "~> 0.35"
    }
  }
}


provider "snowflake" {
username = "KRIVAS"
account = "YCB53488"
region = "us-east-1"
role  = "Engineer"
}

resource "tls_private_key" "svc_key" {
        algorithm = "RSA"
        rsa_bits  = 2048
    }





resource snowflake_task task {
  for_each = var.table_names_list[1]
  comment = "No data loaded for 24 hours"
  database  = "DATAWAREHOUSE"
  schema    = "NETSUITE_HIST"
  warehouse = "TASK_WH"
  name          = "${var.table_names_list} NO_FILES_UPLOADED_FOR_24_HOURS"
  schedule      = "USING CRON 0 9 * * * EST"
  error_integration = "AWS_SNS_ERRORS"
  sql_statement = "select case when cnt > 0 then cnt else 1/0 end  from (select count (*) as cnt  from datawarehouse_prod.netsuite_hist.var.table_names_list where dw_load_timestamp > dateadd(day, -1 , current_date));"

 

  user_task_timeout_ms = 10000

  enabled              = true
}



