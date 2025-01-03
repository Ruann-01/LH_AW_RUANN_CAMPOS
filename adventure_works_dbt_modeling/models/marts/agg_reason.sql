with
    sales_order_reason_link as (
        select
            /* Primary key and Foreign key */
            salesreasonid
            , salesorderid
        from {{ref('stg_sales_order_header_sales_reason')}}
    )

    , sales_reason_details as (
        select
            /* Primary key */
            salesreasonid
            , name_sales_reason
            , reasontype
        from {{ref('stg_sales_reason')}}
    )

    , joined_sales_reason as (
        select
            sales_order_reason_link.salesorderid
            , sales_reason_details.salesreasonid
            , sales_reason_details.name_sales_reason
            , sales_reason_details.reasontype
        from sales_order_reason_link
        left join sales_reason_details
            on sales_order_reason_link.salesreasonid = sales_reason_details.salesreasonid
        order by sales_reason_details.reasontype asc
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
            , array_to_string(reason_types_array, ', ') as aggregated_reasontype
            , array_to_string(reason_names_array, ', ') as aggregated_name_sales_reason
        from aggregated_reasons
    )

    , cleaned_aggregations as (
        select
            salesorderid
            , replace(
                replace(
                    replace(
                        replace(
                            replace(trim(aggregated_reasontype), 'Other, Other', 'Other') 
                            , 'Other, Promotion', 'Promotion'
                        )
                        , 'Marketing, Other', 'Marketing'
                    )
                    , 'Other, Marketing', 'Marketing'
                )
                , 'Promotion, Other', 'Promotion'
            ) as cleaned_reason_type
            , replace(trim(aggregated_name_sales_reason), 'Other, Other', 'Other') as cleaned_name_sales_reason
        from stringified_aggregations
    )

    , final_output as (
        select
            salesorderid
            , coalesce(cleaned_reason_type, 'Not defined') as reason_type
            , coalesce(cleaned_name_sales_reason, 'Not defined') as name_sales_reason
        from cleaned_aggregations
    )

select *
from final_output
