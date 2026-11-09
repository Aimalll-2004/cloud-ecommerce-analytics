with source as (
    select * from {{ source('raw', 'customers') }}
)

select

    customer_id,
    customer_unique_id,
    try_cast(customer_zip_code_prefix as integer) as customer_zip_code_prefix,
    trim(customer_city) as customer_city,
    upper(trim(customer_state)) as customer_state

from source