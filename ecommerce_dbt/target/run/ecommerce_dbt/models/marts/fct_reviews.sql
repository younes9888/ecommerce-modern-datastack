-- back compat for old kwarg name
  
  begin;
    
        
            
            
            
            
        
    

    

    merge into ecommerce.analytics.fct_reviews as DBT_INTERNAL_DEST
        using ecommerce.analytics.fct_reviews__dbt_tmp as DBT_INTERNAL_SOURCE
        on ((DBT_INTERNAL_SOURCE.reviews_id = DBT_INTERNAL_DEST.reviews_id))

    
    when matched then update set
        "REVIEWS_ID" = DBT_INTERNAL_SOURCE."REVIEWS_ID","CUSTOMER_ID" = DBT_INTERNAL_SOURCE."CUSTOMER_ID","PRODUCT_ID" = DBT_INTERNAL_SOURCE."PRODUCT_ID","COMMENT" = DBT_INTERNAL_SOURCE."COMMENT","RATING" = DBT_INTERNAL_SOURCE."RATING","REVIEW_DATE" = DBT_INTERNAL_SOURCE."REVIEW_DATE"
    

    when not matched then insert
        ("REVIEWS_ID", "CUSTOMER_ID", "PRODUCT_ID", "COMMENT", "RATING", "REVIEW_DATE")
    values
        ("REVIEWS_ID", "CUSTOMER_ID", "PRODUCT_ID", "COMMENT", "RATING", "REVIEW_DATE")

;
    commit;