with
    businessentity as (
        select
            /* Primary key */
            businessentityid

            , modifieddate
            , rowguid

        from {{source('raw_person', 'businessentity')}}
    )

select *
from businessentity
