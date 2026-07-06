
  create or replace   view ecommerce.analytics.stg_reviews
  
   as (
    

with ranked as (
    select v:id::int as reviews_id,
           v:product_id::int as product_id,
           v:customer_id::string as customer_id,
           v:comment::string as comment,
           v:rating::int as rating,
           to_timestamp(v:review_date::number, 6) as review_date,
           row_number() over (partition by v:id::int order by to_timestamp(v:review_date::number / 1000) desc) as rn
    from ECOMMERCE.RAW.reviews
)
select reviews_id,
       product_id,
       customer_id,
       comment,
       rating,
       review_date
from ranked
where rn = 1
  );

