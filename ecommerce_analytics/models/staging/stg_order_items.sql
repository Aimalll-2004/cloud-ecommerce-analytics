with source as (
    select * from {{ source('raw', 'order_items') }}
)

select 

    order_id,
    try_cast(order_item_id as integer) as order_item_id,
    product_id,
    seller_id,
    try_to_timestamp_ntz(shipping_limit_date) as shipping_limit_date,
    try_cast(price as number(10,2)) as price,
    try_cast(freight_value as number(10,2)) as freight_value

from source