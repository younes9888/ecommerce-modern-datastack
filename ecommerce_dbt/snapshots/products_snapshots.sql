{% snapshot products_snapshots %}
{{
    config(
        target_schema='analytics',
        unique_key='product_id',
        strategy='check',
        check_cols=['product_name', 'price', 'category']
    )
}}

select * from {{ ref('stg_products') }}

{% endsnapshot %}