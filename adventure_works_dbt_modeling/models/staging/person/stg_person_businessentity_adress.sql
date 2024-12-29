with
    businessentity_address as (
        select
            /* Primarys keys and Foreigns keys*/
            businessentityid
            , addresstypeid
            , addressid

            , modifieddate
            , rowguid

        from {{source('raw_person', 'businessentityaddress')}}
    )

select *
from businessentity_address