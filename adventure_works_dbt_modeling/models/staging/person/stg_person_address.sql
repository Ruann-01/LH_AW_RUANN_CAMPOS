with
    person_address as (
        select
            /* Primary key*/
            addressid
            /* Foreign key */
            , stateprovinceid
            /* Informations about street adress */    
            , city
            , postalcode
            , spatiallocation
            , coalesce(addressline1, '') || ' ' || coalesce(addressline2, '') as full_address
            , modifieddate
            , rowguid

        from {{source('raw_person', 'address')}}
    )

select *
from person_address
