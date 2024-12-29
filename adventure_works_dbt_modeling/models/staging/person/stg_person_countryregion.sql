with
    country_region as (
        select
            /* Primary key and Foreign key */
            countryregioncode
            , name as name_country

            , modifieddate

        from {{source('raw_person', 'countryregion')}}
    )

select *
from country_region
