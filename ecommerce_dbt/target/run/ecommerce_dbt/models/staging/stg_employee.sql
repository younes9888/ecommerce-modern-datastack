
  create or replace   view ecommerce.analytics.stg_employee
  
  
  
  
  as (
    

with cte_employee as (
    select v:id::int as employee_id,
    v:store_id::int as store_id,
    v:first_name::string as first_name,
    v:last_name::string as last_name,
    v:role::string as role,
    to_timestamp(v:hire_date::number , 6) as hire_date,
    current_timestamp() as load_timestamp
from ECOMMERCE.RAW.employee)

select employee_id,
       store_id,
       first_name,
       last_name,
       role,
       hire_date,
       load_timestamp
from cte_employee
  );

