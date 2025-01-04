with 
    int_sales as (
        select *
        from {{ ref('int_sales') }}
    )
    
    , dates as (
        select metric_date
        from {{ ref('dim_dates') }}
    )

    , sales_transformed_final  as (
        select
            {{ dbt_utils.generate_surrogate_key(['salesorderdetailid']) }}  as fct_sales_sk
            , {{ dbt_utils.generate_surrogate_key(['salesorderid']) }} as sales_order_fk
            , {{ dbt_utils.generate_surrogate_key(['productid']) }} as dim_product_fk
            , {{ dbt_utils.generate_surrogate_key(['customerid']) }} as dim_client_fk
            , {{ dbt_utils.generate_surrogate_key(['shiptoaddressid']) }} as dim_location_fk
            , {{ dbt_utils.generate_surrogate_key(['creditcardid']) }} as dim_creditcard_fk
            , {{ dbt_utils.generate_surrogate_key(['reason_type']) }} as dim_sales_reason_fk
            , {{ dbt_utils.generate_surrogate_key(['metric_date']) }} as dim_date_fk
            , order_date
            , online_order
            , carrier_tracking_number
            , paid_with_credit_card
            , order_status
            , order_qty
            , unit_price
            , unit_price_discount
            , sub_total_fixed
            , freight_fixed
            , tax_fixed
            , total_gross
            , total_due_fixed
        from int_sales
        left join dates 
            on int_sales.order_date = dates.metric_date 
    )

select *
from sales_transformed_final