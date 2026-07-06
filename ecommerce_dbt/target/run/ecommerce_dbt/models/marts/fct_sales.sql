-- back compat for old kwarg name
  
  begin;
    
        
            
            
            
            
        
    

    

    merge into ecommerce.analytics.fct_sales as DBT_INTERNAL_DEST
        using ecommerce.analytics.fct_sales__dbt_tmp as DBT_INTERNAL_SOURCE
        on ((DBT_INTERNAL_SOURCE.sale_id = DBT_INTERNAL_DEST.sale_id))

    
    when matched then update set
        "SALE_ID" = DBT_INTERNAL_SOURCE."SALE_ID","CUSTOMER_ID" = DBT_INTERNAL_SOURCE."CUSTOMER_ID","PRODUCT_ID" = DBT_INTERNAL_SOURCE."PRODUCT_ID","STORE_ID" = DBT_INTERNAL_SOURCE."STORE_ID","SALE_DATE" = DBT_INTERNAL_SOURCE."SALE_DATE","QUANTITY" = DBT_INTERNAL_SOURCE."QUANTITY","UNIT_PRICE" = DBT_INTERNAL_SOURCE."UNIT_PRICE","TOTAL_AMOUNT" = DBT_INTERNAL_SOURCE."TOTAL_AMOUNT"
    

    when not matched then insert
        ("SALE_ID", "CUSTOMER_ID", "PRODUCT_ID", "STORE_ID", "SALE_DATE", "QUANTITY", "UNIT_PRICE", "TOTAL_AMOUNT")
    values
        ("SALE_ID", "CUSTOMER_ID", "PRODUCT_ID", "STORE_ID", "SALE_DATE", "QUANTITY", "UNIT_PRICE", "TOTAL_AMOUNT")

;
    commit;