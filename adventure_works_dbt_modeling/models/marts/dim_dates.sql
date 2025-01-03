
with 
    /* Using dbt_utils to create a sequence of days. */
    date_series as (
           {{ dbt_utils.date_spine(
                datepart="day",
                start_date= "cast('2011-05-01' as date)", 
                end_date="cast('2014-07-31' as date)"
           )
           }}
    )

    /* Creating necessary columns to use in PowerBI. */
    , date_columns as (
        select distinct
            date(date_day) as metric_date
            , extract(day from date_day) as select_day
            , extract(month from date_day) as select_month
            , extract(year from date_day) as select_year
            , extract(quarter from date_day) as select_quarter
            , case
                when extract(month from date_day) = 1 then 'January'
                when extract(month from date_day) = 2 then 'February'
                when extract(month from date_day) = 3 then 'March'
                when extract(month from date_day) = 4 then 'April'
                when extract(month from date_day) = 5 then 'May'
                when extract(month from date_day) = 6 then 'June'
                when extract(month from date_day) = 7 then 'July'
                when extract(month from date_day) = 8 then 'August'
                when extract(month from date_day) = 9 then 'September'
                when extract(month from date_day) = 10 then 'October'
                when extract(month from date_day) = 11 then 'November'
                when extract(month from date_day) = 12 then 'December'
            end as full_month
        from date_series
    )

    , date_columns_final as (
        select
            metric_date
            , select_day
            , select_month
            , select_year
            , select_quarter
            , full_month
        from date_columns
    )

select *
from date_columns_final
