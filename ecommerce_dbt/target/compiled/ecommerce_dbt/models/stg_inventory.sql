

with ranked as (
    select v:id::int as inventory_id,
           v:store_id::int as store_id,
           v:product_id::int as product_id,
           v:quantity::int as quantity,
           to_timestamp(v:updated_at::number, 6) as updated_at,
           row_number() over (partition by v:id::int order by v:updated_at::timestamp desc) as rn
    from ECOMMERCE.RAW.inventory
)
select inventory_id,
       store_id,
       product_id,
       quantity,
       updated_at      
from ranked
where rn = 1