{{ config(
    materialized='incremental',
    unique_key='reviews_id'
) }}

select
    reviews_id,
    customer_id,
    product_id,
    comment,
    rating,
    review_date
    
from {{ ref('stg_reviews') }}

{% if is_incremental() %}

where review_date >
(select coalesce(max(review_date), '1900-01-01') from {{ this }})
{% endif %}