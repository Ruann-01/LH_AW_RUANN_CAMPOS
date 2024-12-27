with
    sales_person_quota_history as (
        select
            /* Primary Key*/
            businessentityid
            /*Informations about sales by sales person */
            , salesquota
            , quotadate
            , rowguid
            , modifieddate

        from {{source('raw_sales', 'salespersonquotahistory')}}
    )
select *
from sales_person_quota_history
