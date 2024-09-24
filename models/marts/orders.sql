with

jaffle_shop_orders as (
    
    select * from {{ ref('jaffle_shop_orders') }}
    
),

circus_concessions as (
    
    select * from {{ ref('cirque_du_jaffle', 'concession_sales') }}

),

cirque_location as (

    select * from {{ ref('cirque_location') }}

),

unioned as (

    select 
        'jaffle_shop' as sale_location,
        location_id,
        cast(order_id as text) as order_id,
        coalesce(count_food_items, 0) as total_jaffles_purchased,
        coalesce(food_order_items_subtotal, 0) as total_jaffle_revenue
    
    from jaffle_shop_orders

    union all 

    select 
        'cirque_du_jaffle' as sale_location,
        cirque_location.location_id,
        cast(concession_sale_id as text) as order_id,
        coalesce(total_jaffles_purchased, 0) as total_jaffles_purchased,
        coalesce(order_jaffle_subtotal, 0) as total_jaffle_revenue
    
    from circus_concessions
    cross join cirque_location

),

final as (

    select 
        {{
            dbt_utils.generate_surrogate_key([
                'order_id',
                'sale_location'
            ])
        }} as unique_key,
        unioned.*
    from unioned

)

select * from final