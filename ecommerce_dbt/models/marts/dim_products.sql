{{ config(materialized='table') }}

with latest as (
    select
        product_id,
        product_name,
        price,
        category,
        created_at,
        dbt_valid_from as valid_from,
        dbt_valid_to as valid_to,
        case when dbt_valid_to is null then true else false end as is_current
    from {{ ref('products_snapshots') }}
)
select
    product_id,
    product_name,
    price,
    category,
    created_at,
    valid_from,
    valid_to,
    is_current
from latest

