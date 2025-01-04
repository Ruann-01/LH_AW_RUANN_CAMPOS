with
    dim_sales_reason as (
        select 
            salesorderid
            , reason_type
            , name_sales_reason
        from {{ ref('agg_reason') }}
    )

    , sales_reason_transformed as (
        select
            {{ dbt_utils.generate_surrogate_key(['salesorderid']) }} as dim_sales_reason_sk
            , salesorderid
            , reason_type
        from dim_sales_reason
    )

select *
from sales_reason_transformed