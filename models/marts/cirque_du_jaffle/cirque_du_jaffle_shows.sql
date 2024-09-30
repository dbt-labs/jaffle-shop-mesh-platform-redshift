{{ config(access = 'public') }}

with shows as (
    
    select * from {{ ref('cirque_du_jaffle', 'shows') }}

)

select * from shows
