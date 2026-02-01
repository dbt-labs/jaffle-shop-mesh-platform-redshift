with

orders as (

    select * from {{ ref('stg_orders') }}

),

order_items as (

    select * from {{ ref('order_items') }}

),

order_items_summary as (

    select
        order_id,
        ordered_at::date AS order_date,

        sum(supply_cost) as order_cost,
        sum(product_price) as order_items_subtotal,
        sum(case when is_food_item then product_price else 0 end) as food_order_items_subtotal,
        sum(case when is_drink_item then product_price else 0 end) as drink_order_items_subtotal,
        count(order_item_id) as count_order_items,
        sum(
            case
                when is_food_item then 1
                else 0
            end
        ) as count_food_items,
        sum(
            case
                when is_drink_item then 1
                else 0
            end
        ) as count_drink_items

    from order_items

    group by 1,2

),

compute_booleans as (

    select
        orders.*,
        order_items_summary.order_date,

        order_items_summary.order_cost,
        order_items_summary.order_items_subtotal,
        order_items_summary.count_food_items,
        order_items_summary.count_drink_items,
        order_items_summary.count_order_items,
        order_items_summary.food_order_items_subtotal,
        order_items_summary.drink_order_items_subtotal,
        order_items_summary.count_food_items > 0 as is_food_order,
        order_items_summary.count_drink_items > 0 as is_drink_order

    from orders

    left join
        order_items_summary
        on orders.order_id = order_items_summary.order_id

)

select * from compute_booleans
