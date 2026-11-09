with order_items as (
    select 
        order_id,
        sum(price) as product_revenue,
        sum(freight_value) as freight_revenue,
        count(*) as items_sold
    from {{ ref('stg_order_items') }}
    group by order_id
),

orders as (
    select 
        order_id,
        customer_id,
        order_status,
        order_purchase_timestamp
    from {{ ref('stg_orders') }}
)

select 
    o.order_id,
    o.customer_id,
    o.order_status,
    o.order_purchase_timestamp,
    coalesce(i.product_revenue, 0) as product_revenue,
    coalesce(i.freight_revenue, 0) as freight_revenue,
    coalesce(i.items_sold, 0) as items_sold,
    case 
        when o.order_status = 'delivered'
        then coalesce(i.product_revenue, 0)
        else 0
    end as realized_product_revenue

from orders o
left join order_items i on o.order_id = i.order_id