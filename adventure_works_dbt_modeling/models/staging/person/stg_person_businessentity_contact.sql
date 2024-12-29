with
    businessentity_contact as (
        select
            /* Primarys keys & Foreigns keys */
            businessentityid
            , contacttypeid
            , personid

            , modifieddate
            , rowguid

        from {{source('raw_person', 'businessentitycontact')}}
    )

select *
from businessentity_contact
