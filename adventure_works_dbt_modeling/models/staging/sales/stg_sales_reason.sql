with
    sales_reason as (
        select
            /* Primary Key */
            salesreasonid
            /* Others informations */
            , name as name_sales_reason
            , reasontype
            , modifieddate
            
        from {{source('raw_sales', 'salesreason')}}
    )
select *
from sales_reason
