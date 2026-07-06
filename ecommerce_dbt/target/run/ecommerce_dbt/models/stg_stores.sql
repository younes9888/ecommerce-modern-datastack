
  create or replace   view ecommerce.analytics.stg_stores
  
   as (
    

with ranked as (
    select v:id::int as stores_id,
           v:store_name::string as store_name,
           v:city::string as city,
           to_timestamp(v:created_at::number , 6) as created_at,
           row_number() over (partition by v:id::int order by to_timestamp(v:created_at::number / 1000) desc) as rn
    from ECOMMERCE.RAW.stores
)
select stores_id,
       store_name,
       city,
       created_at
from ranked
where rn = 1
  );

