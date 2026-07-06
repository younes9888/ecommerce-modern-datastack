

select
    reviews_id,
    customer_id,
    product_id,
    comment,
    rating,
    review_date
    
from ecommerce.analytics.stg_reviews



where review_date >
(select coalesce(max(review_date), '1900-01-01') from ecommerce.analytics.fct_reviews)
