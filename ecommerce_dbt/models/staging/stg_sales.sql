{{ config(
    materialized='view'
) }}

with ranked as (
    select v:id::int as sale_id,
           v:product_id::int as product_id,
           v:customer_id::string as customer_id,
           v:store_id::int as store_id,
           v:quantity::int as quantity,
           v:total_amount::float as total_amount,
           to_timestamp(v:sale_date::number , 6) as sale_date,
           row_number() over (partition by v:id::int order by to_timestamp(v:sale_date::number / 1000) desc) as rn
    from {{ source('raw', 'sales') }}
)
select sale_id,
       product_id,
       customer_id,
       store_id,
       quantity,
       total_amount,
       sale_date
from ranked
where rn = 1