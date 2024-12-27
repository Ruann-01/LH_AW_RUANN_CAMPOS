with
    customer as (
        select
            customerid /* Primary key */
            , personid /*Foreign key */
            , storeid /*Foreign key */
            , territoryid /*Foreign key */
            /* Informations about customer */
            , modifieddate
            , rowguid

        from {{source('raw_sales', 'customer')}}
    )

select *
from customer
