with
    salesreason as (
        select *
        from {{ ref('stg_sales_reason') }}
    )

    , salesorderheadersalesreason as (
        select *
        from {{ ref('stg_sales_order_header_sales_reason') }}
    )

    , joined_sales_reason as (
        select
            salesorderheadersalesreason.salesorderid
            , salesreason.reasontype
            , salesreason.name_sales_reason
        from salesorderheadersalesreason
        left join salesreason
            on salesorderheadersalesreason.salesreasonid = salesreason.salesreasonid
    )

    , aggregated_reasons as (
        select
            salesorderid
            , array_agg(distinct reasontype) as reason_types_array
            , array_agg(distinct name_sales_reason) as reason_names_array
        from joined_sales_reason
        group by salesorderid
    )

    , stringified_aggregations as (
        select
            salesorderid
            , array_to_string(reason_types_array, ', ') as reason_type
            , array_to_string(reason_names_array, ', ') as name_sales_reason
        from aggregated_reasons
    )
    
select
    {{ create_surrogate_key(['salesorderid']) }} as dim_sales_reason_sk
    , salesorderid
    , reason_type
    , name_sales_reason
from stringified_aggregations
