with
    sales_person as (
        select
            /* Primary key */
            businessentityid
            /* Foreign key */
            , territoryid
            /* Informations about sales by sales person */
            , salesquota
            , bonus
            , commissionpct
            , salesytd
            , saleslastyear
            , rowguid
            , modifieddate
        from {{source('raw_sales', 'salesperson')}}
    )
select *
from sales_person
