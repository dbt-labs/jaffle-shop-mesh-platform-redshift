{{
    config(
        materialized='table'
    )
}}

with ticket_sales as (

select * from {{ ref('cirque_du_jaffle', 'stg_ticket_sales') }}
)
select * from ticket_sales


