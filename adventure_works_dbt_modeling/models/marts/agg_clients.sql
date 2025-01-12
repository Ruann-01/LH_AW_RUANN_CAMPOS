with
    client as (
        select *
        from {{ ref('stg_sales_customer') }}
    )

    , person as (
        select *
        from {{ ref('stg_person') }}
    )

    , store as ( 
        select *
        from {{ ref('stg_sales_store') }}
    )

    , address as (
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

    , order_itens as (
        select *
        from {{ ref('stg_sales_order_detail') }}
    )

    , products as (
        select *
        from {{ ref('stg_product') }}
    )

    , clients as (
        select
            {{ create_surrogate_key(['client.customerid', 'client.personid']) }} as sk_client
            , client.customerid
            , client.personid
            , person.complete_name
            , client.storeid
            , store.name_store
        from client 
        left join person on client.customerid = person.businessentityid
        left join store on client.customerid = store.businessentityid
    )  

    , new_clients as (
        select
            clients.customerid 
            , clients.complete_name
            , order_header.salesorderid
            , order_itens.salesorderdetailid
            , order_header.shiptoaddressid
            , order_itens.orderqty as order_qty
            , order_itens.unitprice as unit_price
            , order_header.orderdate as order_date
            , order_itens.unitpricediscount as unit_price_discount
            , products.name_product 
            , state_province.stateprovincecode as state_province_code
            , state_province.name_state_province
            , country_region.name_country
            , country_region.countryregioncode as country_code
            , address.full_address
        from clients 
        left join order_header on clients.customerid = order_header.customerid
        left join order_itens on order_itens.salesorderid = order_header.salesorderid
        left join products on order_itens.productid = products.productid
        left join address on order_header.shiptoaddressid = address.addressid
        left join state_province on address.stateprovinceid = state_province.stateprovinceid
        left join country_region on state_province.countryregioncode = country_region.countryregioncode
    )

    , agg_clients as (
        select 
            customerid
            , complete_name
            , name_country 
            , full_address
            , name_state_province
            , sum ((order_qty*unit_price) * (1-unit_price_discount)) as cltv
            , min (order_date) as first_purchase
            , max (order_date) as last_purchase 
        from new_clients
        group by 
            customerid
            , complete_name
            , name_country
            , full_address
            , name_state_province  
    )   

    , agg_clients_final as (
        select 
            customerid
            , complete_name
            , name_country
            , full_address
            , name_state_province
            , round(cltv,2) as cltv
            , first_purchase
            , last_purchase
            , round(datediff('day', first_purchase, last_purchase) / 30.44, 1) as customer_lifetime_months
        from agg_clients
        where cltv is not null 
    )

select * from agg_clients_final 
