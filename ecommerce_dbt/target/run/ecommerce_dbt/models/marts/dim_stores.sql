
  
    

create or replace transient table ecommerce.analytics.dim_stores
    
    
    
    as (

select
    store_id,
    store_name,
    city,
    created_at
from ecommerce.analytics.stg_stores
    )
;


  