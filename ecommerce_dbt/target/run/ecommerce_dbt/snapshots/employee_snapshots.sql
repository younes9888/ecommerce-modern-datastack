
      begin;
    merge into "ECOMMERCE"."ANALYTICS"."EMPLOYEE_SNAPSHOTS" as DBT_INTERNAL_DEST
    using "ECOMMERCE"."ANALYTICS"."EMPLOYEE_SNAPSHOTS__dbt_tmp" as DBT_INTERNAL_SOURCE
    on DBT_INTERNAL_SOURCE.dbt_scd_id = DBT_INTERNAL_DEST.dbt_scd_id

    when matched
     
       and DBT_INTERNAL_DEST.dbt_valid_to is null
     
     and DBT_INTERNAL_SOURCE.dbt_change_type in ('update', 'delete')
        then update
        set dbt_valid_to = DBT_INTERNAL_SOURCE.dbt_valid_to

    when not matched
     and DBT_INTERNAL_SOURCE.dbt_change_type = 'insert'
        then insert ("EMPLOYEE_ID", "STORE_ID", "FIRST_NAME", "LAST_NAME", "ROLE", "HIRE_DATE", "LOAD_TIMESTAMP", "DBT_UPDATED_AT", "DBT_VALID_FROM", "DBT_VALID_TO", "DBT_SCD_ID")
        values ("EMPLOYEE_ID", "STORE_ID", "FIRST_NAME", "LAST_NAME", "ROLE", "HIRE_DATE", "LOAD_TIMESTAMP", "DBT_UPDATED_AT", "DBT_VALID_FROM", "DBT_VALID_TO", "DBT_SCD_ID")

;
    commit;
  