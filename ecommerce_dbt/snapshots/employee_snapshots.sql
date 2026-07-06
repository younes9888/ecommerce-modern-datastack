{% snapshot employee_snapshots %}

{{
    config(
        target_schema='analytics',
        unique_key='employee_id',
        strategy='check',
        check_cols=['first_name', 'last_name', 'role']
    )
}}

select * from {{ ref('stg_employee') }}

{% endsnapshot %}