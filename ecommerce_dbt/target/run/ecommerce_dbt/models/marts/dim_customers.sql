
  
    

create or replace transient table ecommerce.analytics.dim_customers
    
    
    
    as (

with latest as (
    select
        customer_id,
        first_name,
        last_name,
        email,
        created_at,
        load_timestamp,
        dbt_valid_from as valid_from,
        dbt_valid_to as valid_to,
        case when dbt_valid_to is null then true else false end as is_current
    from ecommerce.analytics.customers_snapshots
)
select
    customer_id,
    first_name,
    last_name,
    email,
    created_at,
    load_timestamp,
    valid_from,
    valid_to,
    is_current
from latest
    )
;


  