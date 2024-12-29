with
    person_adress as (
        select
            /* Primary key*/
            addressid

            /* Foreign key */
            , stateprovinceid

            /* Informations about street adress */    
            , city
            , postalcode
            , spatiallocation
            , addressline1
            , addressline2
            , modifieddate
            , rowguid

        from {{source('raw_person', 'address')}}
    )

select *
from person_adress
