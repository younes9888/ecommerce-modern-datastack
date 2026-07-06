
  create or replace   view ecommerce.analytics.stg_customers
  
   as (
    

with ranked as (
    select v:id::int as customer_id,
           v:first_name::string as first_name,
           v:last_name::string as last_name,
           v:email::string as email,
           to_timestamp(v:created_at::number, 6)  as created_at,
           current_timestamp() as load_timestamp,
           row_number() over (partition by v:id::int order by v:created_at::timestamp desc) as rn
    from ECOMMERCE.RAW.customers
)
select customer_id,
       first_name,
       last_name,
       email,
       created_at,
       load_timestamp
from ranked
where rn = 1
  );

