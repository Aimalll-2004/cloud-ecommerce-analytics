with orders as (
    select 
        order_id,
        customer_id,
        order_status,
        order_purchase_timestamp,
        order_delivered_customer_date,
        order_estimated_delivery_date

    from {{ ref('stg_orders') }}
)

select 
    order_id,
    customer_id,
    order_status,
    order_purchase_timestamp,
    order_delivered_customer_date,
    order_estimated_delivery_date,

    datediff(
        'days',
        order_purchase_timestamp,
        order_delivered_customer_date
    ) as delivery_days, 

    case 
        when order_delivered_customer_date is null
            then null 
        when order_estimated_delivery_date is null
            then null 
        when order_delivered_customer_date > order_estimated_delivery_date
            then 1
        else 0
    end as is_late_delivery

from orders