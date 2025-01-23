with 
    customer as (
        select *
        from {{ ref('stg_sales_customer') }}
    )

    , store as (
        select *
        from {{ ref('stg_sales_store') }}
    )

    , order_header as (
        select *
        from {{ ref('stg_sales_order_header') }}
    )

    , order_itens as (
        select *
        from {{ ref('stg_sales_order_detail') }}
    )

    , product as (
        select *
        from {{ ref('stg_product') }}
    )

    , product_subcategory as (
        select *
        from {{ ref('stg_product_subcategory') }}
    )

    , product_category as (
        select *
        from {{ ref('stg_product_category') }}
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

    , production as (
        select
            customer.customerid
            , store.businessentityid 
            , order_header.salesorderid
            , order_itens.salesorderdetailid
            , product.productid
            , name_store
            , order_itens.orderqty as order_qty
            , order_itens.unitprice as unit_price
            , case 
                when country_region.countryregioncode = 'US' then 'US Provinces'
                else 'International'
            end as region_type
            , date_trunc('month', order_header.orderdate) as order_month
            , order_header.orderdate as order_date
            , order_itens.unitpricediscount as unit_price_discount
            , product.name_product
            , product_subcategory.name_product_subcategory
            , product_category.name_product_category
            , state_province.stateprovincecode as state_province_code
            , state_province.name_state_province 
            , country_region.name_country
            , country_region.countryregioncode as country_region_code 
        from customer
        left join store on customer.storeid = store.businessentityid
        left join order_header on customer.customerid = order_header.customerid
        left join order_itens on order_itens.salesorderid = order_header.salesorderid
        left join product on order_itens.productid = product.productid
        left join product_subcategory on product.productsubcategoryid = product_subcategory.productsubcategoryid
        left join product_category on product_subcategory.productcategoryid = product_category.productcategoryid
        left join address_information on order_header.billtoaddressid = address_information.addressid
        left join state_province on address_information.stateprovinceid = state_province.stateprovinceid
        left join country_region on state_province.countryregioncode = country_region.countryregioncode
    )

    , agg_production_store as (
        select
            customerid
            , businessentityid
            , salesorderid
            , salesorderdetailid
            , productid
            , name_store
            , order_qty
            , unit_price
            , region_type
            , order_month
            , order_date
            , unit_price_discount
            , name_product
            , name_product_category
            , name_product_subcategory
            , state_province_code
            , name_state_province
            , name_country
            , country_region_code
        from production
        where name_store is not null
    ) 

select * 
from agg_production_store
