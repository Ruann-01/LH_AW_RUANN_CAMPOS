with
    creditcard as (
        select
            creditcardid /* primary key*/
            /* informations about the credits card */
            , cardtype
            , cardnumber
            , expmonth
            , expyear
            , modifieddate

        from {{source('raw_sales', 'creditcard')}}
    )
select *
from creditcard
