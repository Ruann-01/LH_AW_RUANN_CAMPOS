with
    sales_territory as (
        select
            /* Primary key */
            territoryid
            /* Foreign key */
            , countryregioncode
            /* Informations about sales by territory */
            , name as name_sales_territory
            , 'group'
            , salesytd
            , saleslastyear
            , costytd
            , costlastyear
            , modifieddate
        
        from {{source('raw_sales', 'salesterritory')}}
    )

select *
from sales_territory
