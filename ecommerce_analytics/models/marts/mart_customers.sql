
with customers as (
    select
        customer_id,
        customer_unique_id,
        customer_city,
        customer_state
    from {{ ref('stg_customers') }}
),

customer_orders as (
    select
        o.customer_id,
        count(*) as total_orders,
        count_if(o.order_status = 'delivered') as delivered_orders,
        sum(
            case
                when o.order_status = 'delivered'
                then coalesce(s.product_revenue, 0)
                else 0
            end
        ) as total_spent

    from {{ ref('stg_orders') }} o
    left join {{ ref('fct_sales') }} s
        on o.order_id = s.order_id

    group by o.customer_id
),

order_reviews as (
    select
        order_id,
        avg(review_score) as avg_review_score
    from {{ ref('stg_reviews') }}
    group by order_id
),

customer_reviews as (
    select
        o.customer_id,
        avg(r.avg_review_score) as avg_review_score

    from {{ ref('stg_orders') }} o
    inner join order_reviews r
        on o.order_id = r.order_id

    group by o.customer_id
)

select
    c.customer_id,
    c.customer_unique_id,
    c.customer_city,
    c.customer_state,
    coalesce(co.total_orders, 0) as total_orders,
    coalesce(co.delivered_orders, 0) as delivered_orders,
    coalesce(co.total_spent, 0) as total_spent,
    cr.avg_review_score

from customers c
left join customer_orders co
    on c.customer_id = co.customer_id
left join customer_reviews cr
    on c.customer_id = cr.customer_id
