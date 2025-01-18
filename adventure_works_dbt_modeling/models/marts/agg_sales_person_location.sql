with 
    sales_person as ( 
        select * 
        from {{ ref('stg_sales_person') }}
    )

    , person as (
        select *
        from {{ ref('stg_person') }}
    )  

    , address_information as (
        select *
        from {{ ref('stg_person_address') }}
    )

    , state_province as (
        select *
        from {{ ref('stg_person_stateprovince') }}
    )

    , country_region as (
        select *
        from {{ ref('stg_person_countryregion') }}
    )

    , order_header as (
        select *
        from {{ ref('stg_sales_order_header') }}
    )

    , aggregated_sales_person as (
        select
            sales_person.businessentityid
            , order_header.salespersonid
            , person.complete_name
            , country_region.name_country
            , count(order_header.salesorderid) as total_sales 
            , row_number() over (
                partition by sales_person.businessentityid 
                order by sales_person.businessentityid
            ) as remove_duplicates_index
        from sales_person 
        left join person on sales_person.businessentityid = person.businessentityid
        left join order_header on sales_person.businessentityid = order_header.salespersonid
        left join address_information on order_header.billtoaddressid = address_information.addressid
        left join state_province on address_information.stateprovinceid = state_province.stateprovinceid
        left join country_region on state_province.countryregioncode = country_region.countryregioncode
        group by 
            sales_person.businessentityid
            , order_header.salespersonid
            , person.complete_name
            , country_region.name_country
    )

select 
    businessentityid
    , salespersonid
    , complete_name
    , name_country
    , total_sales
from aggregated_sales_person
where remove_duplicates_index = 1
