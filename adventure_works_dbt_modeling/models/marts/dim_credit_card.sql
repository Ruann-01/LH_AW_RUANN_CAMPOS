with
    salesorderheader as (
        select
            /* Primary key */
            salesorderid
            /* Foreign keys */
            , customerid		
            , salespersonid	
            , creditcardid				
            /* Other informations */      
            , rowguid					
        from {{ref('stg_sales_order_header')}}
    )

    , creditcard as (
        select
            /* Primary key */
            creditcardid
            /* Informations about credit cards */
            , cardtype
        from {{ref('stg_sales_credit_card')}}
    )

    , join_dim_creditcard as (
        select
            {{ create_surrogate_key(['salesorderheader.creditcardid']) }} as dim_creditcard_sk
            , salesorderheader.salesorderid
            , salesorderheader.customerid
            , salesorderheader.salespersonid
            , coalesce(salesorderheader.creditcardid, 0) as creditcardid
            , coalesce(nullif(trim(cardtype), ''), 'Não informado') AS card_type
            from salesorderheader
            left join creditcard on (salesorderheader.creditcardid = creditcard.creditcardid)
            order by salesorderheader.salesorderid asc
    )
    
    , creditcard_transformed_deduplicates as (
        select
            *
            , row_number() over (
                partition by creditcardid 
                order by creditcardid
            ) as remove_duplicates_index
        from join_dim_creditcard
    )

select *
from creditcard_transformed_deduplicates
where remove_duplicates_index = 1
