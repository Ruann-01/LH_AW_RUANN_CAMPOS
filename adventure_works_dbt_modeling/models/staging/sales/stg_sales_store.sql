with
    store as (
        select
            /* Primary key */
            businessentityid
            /* Foreign key */
            , salespersonid
            /* Stores of ADW products */
            , name as name_store
            , demographics
            , rowguid
            , modifieddate

        from {{source('raw_sales', 'store')}}
    )
select *
from store