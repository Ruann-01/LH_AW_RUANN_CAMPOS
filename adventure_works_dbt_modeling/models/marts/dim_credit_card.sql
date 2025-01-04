with
    sales_order_header as (
        select
            /* Primary key */
            salesorderid
            /* Foreign key */
            , creditcardid				
            /* Other informations */      
            , rowguid					
        from {{ref('stg_sales_order_header')}}
        where creditcardid is not null
    )

    , credit_card as (
        select
            /* Primary key */
            creditcardid
            /* Informations about credit card */
            , cardtype
        from {{ref('stg_sales_credit_card')}}
    )

    , join_dim_credit_card as (
        select
            {{ dbt_utils.generate_surrogate_key(['sales_order_header.creditcardid']) }} as dim_creditcard_sk
            , sales_order_header.creditcardid
            , sales_order_header.salesorderid
            , coalesce(credit_card.cardtype, 'Not informed') as card_type
        from sales_order_header
        left join credit_card 
            on sales_order_header.creditcardid = credit_card.creditcardid
        order by sales_order_header.salesorderid asc
    )

    , credit_card_transformed as (
        select
            dim_creditcard_sk
            , creditcardid
            , salesorderid
            , card_type
            , row_number() over (
                partition by creditcardid 
                order by creditcardid
            ) as remove_duplicates_index,
        from join_dim_credit_card
    )

select *
from credit_card_transformed
 where remove_duplicates_index = 1