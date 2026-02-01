with

orders as (

    select * from {{ref('orders')}}

), dates as (

    select * from {{ref('dates')}}

), 
order_daily as (

    select date_day,
            coalesce(orders.order_cost) as order_cost,
            coalesce(order_items_subtotal) as order_items_subtotal,
            coalesce(orders.count_food_items)as count_food_items,
            coalesce(orders.count_drink_items) as count_drink_items,
            coalesce(orders.count_order_items) as count_order_items,
            coalesce(orders.food_order_items_subtotal) as food_order_items_subtotal,
            coalesce(orders.drink_order_items_subtotal) as drink_order_items_subtotal

    from dates
    
    left join orders on dates.date_day = orders.order_date

)

select * from order_daily