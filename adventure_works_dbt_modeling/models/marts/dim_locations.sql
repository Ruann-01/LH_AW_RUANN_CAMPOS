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

    , sales_order_header as (
        select 
            distinct(shiptoaddressid)
        from {{ref('stg_sales_order_header')}}
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

    , country_region as (
        select
            countryregioncode
            , name_country
        from {{ref('stg_person_countryregion')}}
    )
    
    , join_dim_locations as (
        select
            {{ dbt_utils.generate_surrogate_key(['shiptoaddressid']) }} as dim_location_sk
            , sales_order_header.shiptoaddressid
            , address_information.stateprovinceid
            , address_information.city
            , state_province.countryregioncode
            , state_province.stateprovincecode
            , state_province.name_state_province
            , country_region.name_country
        from sales_order_header
        left join address_information 
            on address_information.addressid = sales_order_header.shiptoaddressid
        left join state_province 
            on address_information.stateprovinceid = state_province.stateprovinceid
        left join country_region
            on state_province.countryregioncode = country_region.countryregioncode
    )

    , locations_transformed as (
        select
            dim_location_sk
            , shiptoaddressid
            , stateprovinceid
            , countryregioncode
            , stateprovincecode
            , name_state_province
            , city
            , name_country
        from join_dim_locations
    )

select *
from locations_transformed
