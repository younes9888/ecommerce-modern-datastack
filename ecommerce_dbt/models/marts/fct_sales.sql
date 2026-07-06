{{ config(
    materialized='incremental',
    unique_key='sale_id'
) }}

with sales as (
    select *
    from {{ ref('stg_sales') }}

    {% if is_incremental() %}
        where sale_date >
        (
            select coalesce(max(sale_date), '1900-01-01'::timestamp)
            from {{ this }}
        )
    {% endif %}
),

customers as (
    select customer_id
    from {{ ref('dim_customers') }}
    where is_current = true
),

products as (
    select product_id,price
    from {{ ref('dim_products') }}
    where is_current = true
),

stores as (
    select store_id
    from {{ ref('dim_stores') }}
)
select
    s.sale_id,
    c.customer_id,
    p.product_id,
    st.store_id,
    s.sale_date,
    s.quantity,
    p.price as unit_price,
    s.total_amount
from sales s

left join customers c
    on s.customer_id = c.customer_id

left join products p
    on s.product_id = p.product_id

left join stores st
    on s.store_id = st.store_id