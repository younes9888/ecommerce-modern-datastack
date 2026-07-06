{{ config(
    materialized='table'
) }}

select
    store_id,
    store_name,
    city,
    created_at
from {{ ref('stg_stores') }}