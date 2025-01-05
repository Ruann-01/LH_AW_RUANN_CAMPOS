{{ 
    config(
        severity='error'
    ) 
}}

select
    count(*) as invalid_unit_prices
from
    {{ ref('fct_sales') }}
where
    unit_price < 0
having
    count(*) > 0