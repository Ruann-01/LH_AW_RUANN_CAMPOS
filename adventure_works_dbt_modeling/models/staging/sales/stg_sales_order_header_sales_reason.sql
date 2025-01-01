with
    sales_order_header_sales_reason as (
        select
            /* Primary key and Foreign key */
            salesreasonid
            , salesorderid
            /*Other information*/
            , modifieddate

        from {{source('raw_sales', 'salesorderheadersalesreason')}}
    )

select *
from sales_order_header_sales_reason
