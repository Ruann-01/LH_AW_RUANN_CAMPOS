{{
    config(
        severety = 'error'
    )
}}

with 
    total_revenue_2011 as (
        select *
    from {{ ref('fct_sales') }}
    
    )

    , query_test as (
        select 
            sum(total_gross) as total_sales
        from total_revenue_2011
        where order_date between '2011-01-01' and '2011-12-31'
    )

select total_sales
from query_test
where total_sales not between 12646000.00 and 12647000.00