with source as (
    select * from {{ source('raw', 'customers') }}
),

cleaned as (
    select
        customer_id,
        customer_unique_id,
        try_cast(customer_zip_code_prefix as integer) as customer_zip_code_prefix,
        trim(customer_city) as customerr_city,
        upper(trim(customer_state)) as customer_state

    from source
)

select * from cleaned