with 
    number_series as (
        select 
            row_number() over(order by seq4()) - 1 as day_offset
        from table(generator(rowcount => 365 * 4)) 
    )

    , date_series as (
        select 
            dateadd(day, day_offset, cast('2011-05-01' as date)) as date_day
        from number_series
        where dateadd(day, day_offset, cast('2011-05-01' as date)) <= cast('2014-07-31' as date)
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
                when extract(month from date_day) = 1 then 'Jan'
                when extract(month from date_day) = 2 then 'Feb'
                when extract(month from date_day) = 3 then 'Mar'
                when extract(month from date_day) = 4 then 'Apr'
                when extract(month from date_day) = 5 then 'May'
                when extract(month from date_day) = 6 then 'Jun'
                when extract(month from date_day) = 7 then 'Jul'
                when extract(month from date_day) = 8 then 'Aug'
                when extract(month from date_day) = 9 then 'Sep'
                when extract(month from date_day) = 10 then 'Oct'
                when extract(month from date_day) = 11 then 'Nov'
                when extract(month from date_day) = 12 then 'Dec'
            end as full_month
            , to_char(date_day, 'Day') as day_name
        from date_series
    )

    , date_columns_final as (
        select
            {{ create_surrogate_key(['metric_date']) }} as dim_date_sk
            , metric_date
            , select_day
            , select_month
            , select_year
            , select_quarter
            , full_month
            , day_name
        from date_columns
    )

select *
from date_columns_final
