{{ config(materialized='table') }}

with latest as (
    select
        employee_id,
        store_id,
        first_name,
        last_name,
        role,
        hire_date,
        load_timestamp,
        dbt_valid_from as valid_from,
        dbt_valid_to as valid_to,
        case when dbt_valid_to is null then true else false end as is_current
    from {{ ref('employee_snapshots') }}
)
select
    employee_id,
    store_id,
    first_name,
    last_name,
    role,
    hire_date,
    valid_from,
    valid_to,
    is_current
from latest