with
    special_offer as (
        select
            /* Primary key */
            specialofferid
            /* Informations about special offers */
            , description as description_discount
            , discountpct
            , type as type_discount
            , category
            , startdate
            , enddate
            , minqty
            , maxqty
            , rowguid
            , modifieddate

        from {{source('raw_sales', 'specialoffer')}}
    )

select *
from special_offer
