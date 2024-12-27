with
    creditcard as (
        select
            /* Primary key */
            creditcardid 
            /* Informations about the credits card */
            , cardtype
            , cardnumber
            , expmonth
            , expyear
            , modifieddate

        from {{source('raw_sales', 'creditcard')}}
    )

select *
from creditcard
