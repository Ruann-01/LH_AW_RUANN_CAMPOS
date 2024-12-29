with
    state_province as (
        select
            /* Primary key */
            stateprovinceid
            /* Foreign key */
            , territoryid

            /* Informations about regions and states provinces */
            , stateprovincecode
            , countryregioncode
            , isonlystateprovinceflag
            , name as name_state_province
            , rowguid
            , modifieddate

        from {{source('raw_person', 'stateprovince')}}
    )

select *
from state_province
