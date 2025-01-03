with
    dim_sales_reason_remove_duplicates as (
        select 
            salesorderid
            , reason_type
            , name_sales_reason
            , row_number() over (
                partition by reason_type 
                order by salesorderid
            ) as remove_duplicates_index
        
        from {{ ref('agg_reason') }}
    ),

    sales_reason_final as (
        select
            {{ dbt_utils.generate_surrogate_key(['reason_type']) }} as dim_sales_reason_sk
            , reason_type
        from dim_sales_reason_remove_duplicates
        where remove_duplicates_index = 1
    )

select *
from sales_reason_final