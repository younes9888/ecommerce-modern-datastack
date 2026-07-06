{{ config(
    materialized='view'
) }}

with ranked as (
    select v:id::int as product_id,
           v:product_name::string as product_name,
           v:price::float as price,
           v:category::string as category,
           to_timestamp(v:created_at::number, 6) as created_at,
           row_number() over (partition by v:id::int order by v:created_at::timestamp desc) as rn
    from {{ source('raw', 'products') }}
)
select product_id,
       product_name,
       price,
       category,
       created_at
from ranked
where rn = 1