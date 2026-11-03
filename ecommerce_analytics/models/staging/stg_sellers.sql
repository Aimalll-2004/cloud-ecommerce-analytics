with source as (
    select * from {{ source('raw', 'sellers') }}
)

select

    seller_id,
    try_cast(seller_zip_code_prefix as integer) as seller_zip_code_prefix,
    trim(seller_city) as seller_city,
    upper(trim(seller_state)) as seller_state

from source