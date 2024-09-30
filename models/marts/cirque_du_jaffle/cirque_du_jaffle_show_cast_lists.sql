{{ config(access = 'public') }}

with cast_lists as (

    select * from {{ ref('cirque_du_jaffle', 'show_cast_lists') }}

)

select * from cast_lists
