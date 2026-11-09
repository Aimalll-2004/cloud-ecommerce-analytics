with product_sales as (
    select 
        oi.product_id,
        count(*) as units_sold,
        count(distinct oi.order_id) as total_orders,
        sum(oi.price) as product_revenue,
        sum(oi.freight_value) as freight_revenue
    
    from {{ ref('stg_order_items') }} oi 
    inner join {{ ref('stg_orders') }} o
        on oi.order_id = o.order_id

    where o.order_status = 'delivered'

    group by oi.product_id
),

products as (
    select 
        p.product_id,
        p.product_category_name,
        coalesce(t.product_category_name_english, p.product_category_name, 'unknown') as category_name

    from {{ ref('stg_products') }} p
    left join {{ ref('stg_category_translation') }} t 
        on p.product_category_name = t.product_category_name
)

select 
    p.product_id,
    p.category_name,
    coalesce(s.units_sold, 0) as units_sold,
    coalesce(s.total_orders, 0) as total_orders,
    coalesce(s.product_revenue, 0) as product_revenue,
    coalesce(s.freight_revenue, 0) as freight_revenue

from products p 
left join product_sales s 
    on p.product_id = s.product_id