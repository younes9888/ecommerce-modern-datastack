

with sales as (
    select *
    from ecommerce.analytics.stg_sales

    
        where sale_date >
        (
            select coalesce(max(sale_date), '1900-01-01'::timestamp)
            from ecommerce.analytics.fct_sales
        )
    
),

customers as (
    select customer_id
    from ecommerce.analytics.dim_customers
    where is_current = true
),

products as (
    select product_id,price
    from ecommerce.analytics.dim_products
    where is_current = true
),

stores as (
    select store_id
    from ecommerce.analytics.dim_stores
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