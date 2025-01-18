with 
    int_sales as (
        select *
        from {{ ref('int_sales') }}
    )
    
    , clients as (
        select
            dim_client_sk as dim_client_fk
            , customerid
        from {{ref('dim_clients')}} 
    )

    , creditcards as (
        select
            dim_creditcard_sk as dim_creditcard_fk
            , creditcardid
        from {{ref('dim_credit_card')}}
    )

    , locations as (
        select
            dim_location_sk as dim_location_fk
            , shiptoaddressid
        from {{ref('dim_locations')}}
    )

    , products as (
        select
            dim_product_sk as dim_product_fk
            , productid
        from {{ref('dim_products')}}
    )

    , dates as (
        select
            dim_date_sk as dim_date_fk
            , metric_date
        from {{ref('dim_dates')}}
    )

    , aggregated_reasons as (
        select
            dim_sales_reason_sk as dim_sales_reason_fk
            , salesorderid
        from {{ ref('dim_sales_reason') }}
    )

    , sales_transformed_final  as (
        select
            {{ create_surrogate_key(['int_sales.salesorderid','int_sales.salesorderdetailid']) }}  as fct_sales_sk
            , {{ create_surrogate_key(['int_sales.salesorderid']) }} as sales_order_fk
            , products.dim_product_fk
            , clients.dim_client_fk
            , locations.dim_location_fk
            , creditcards.dim_creditcard_fk
            , dates.dim_date_fk
            , aggregated_reasons.dim_sales_reason_fk
            , int_sales.customerid
            , int_sales.salespersonid
            , order_date
            , online_order
            , carrier_tracking_number
            , paid_with_credit_card
            , order_status
            , order_qty
            , unit_price
            , unit_price_discount
            , sub_total_fixed
            , round(freight_fixed,4) as freight_fixed
            , round(tax_fixed,4) as tax_fixed
            , total_gross
            , round(total_due_fixed,2) as total_due_fixed
        from int_sales
        left join dates on int_sales.order_date = dates.metric_date
        left join aggregated_reasons on int_sales.salesorderid = aggregated_reasons.salesorderid
        left join products on int_sales.productid = products.productid
        left join clients on int_sales.customerid = clients.customerid
        left join creditcards on int_sales.creditcardid = creditcards.creditcardid
        left join locations on int_sales.shiptoaddressid = locations.shiptoaddressid
    )

select *
from sales_transformed_final
