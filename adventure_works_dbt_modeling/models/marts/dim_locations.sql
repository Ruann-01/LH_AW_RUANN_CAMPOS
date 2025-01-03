with
    address_information as (
        select
            /* Primary key */
            addressid
            /* Foreign key */
            , stateprovinceid
            /* Others informations */
            , city
        from {{ref('stg_person_address')}}
    )

    , state_province as (
        select
            /* Primary key */
            stateprovinceid
            /* Foreign key */
            , territoryid
            /* Others informations */
            , stateprovincecode
            , countryregioncode
            , name_state_province
        from {{ref('stg_person_stateprovince')}}
    )

    , sales_territory as (
        select
            /* Primary key */
            territoryid
            /* Foreign key */
            , countryregioncode
            /* Informations about sales by territories */
            , name_sales_territory
            , group_territory
            , salesytd
            , saleslastyear
            , costytd
            , costlastyear
        from {{ref('stg_sales_territory')}}
    )
    
    , join_dim_locations as (
        select
            {{ dbt_utils.generate_surrogate_key(['addressid']) }} as dim_locations_sk
            , address_information.addressid
            , address_information.stateprovinceid
            , address_information.city
            , state_province.countryregioncode
            , state_province.stateprovincecode
            , state_province.name_state_province
            , sales_territory.name_sales_territory
            from address_information
            left join state_province 
                on (address_information.stateprovinceid = state_province.stateprovinceid)
            left join sales_territory 
                on (state_province.territoryid = sales_territory.territoryid)
    )

    , locations_filter_remove_duplicates as (
        select
            dim_locations_sk
            , addressid
            , stateprovinceid
            , countryregioncode
            , stateprovincecode
            , name_state_province
            , city
            , name_sales_territory
            , row_number() over (
                partition by addressid 
                order by addressid
            ) as remove_duplicates_index,
        from join_dim_locations
    )

select *
from locations_filter_remove_duplicates
where remove_duplicates_index = 1 