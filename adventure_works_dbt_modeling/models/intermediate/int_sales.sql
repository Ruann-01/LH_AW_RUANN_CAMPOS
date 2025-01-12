with 
    salesorderheader as (
        select
            /* Primary key */
            salesorderid
            /* Foreign keys */
            , customerid		
            , salespersonid	
            , territoryid	
            , billtoaddressid	
            , shiptoaddressid	
            , creditcardid				
            , currencyrateid				
            , shipmethodid					
            /* Order information for customers */
            , case 
                when order_status = 1 then 'In Process'
                when order_status = 2 then 'Approved'
                when order_status = 3 then 'Backordered'
                when order_status = 4 then 'Rejected'
                when order_status = 5 then 'Shipped'
                when order_status = 6 then 'Cancelled'
            end as order_status
            , purchaseordernumber
            , creditcardapprovalcode					
            , accountnumber					
            , onlineorderflag
	        , orderdate
            , shipdate	
            , duedate		
            /* Order pricing */
            , subtotal
            , taxamt					
            , freight		
            , totaldue					
        from {{ref('stg_sales_order_header')}}
    )

    , salesorderdetail as (
        select
            /* Primary Key*/
            salesorderid
            , salesorderdetailid					
            /*Foreign Key */
            , productid	
            , specialofferid					
            /* Informations about sales order detail */
            , carriertrackingnumber
            , orderqty
            , unitprice
            , unitpricediscount
        from {{ref('stg_sales_order_detail')}}
    )
    
    , salesorderheadersalesreason as (
        select
            /* Primary key and foreign key */
            salesreasonid
            , salesorderid
        from {{ref('stg_sales_order_header_sales_reason')}}
    )
    
    , creditcard as (
	    select * 
	    from {{ ref('stg_sales_credit_card') }}	
    )

    , union_credit_card as (
	    select 
	    	salesorderheader.*
	    	, cardtype
	    from salesorderheader 
	    left join creditcard on creditcard.creditcardid = salesorderheader.creditcardid
    )

    , union_header_detail as (
	    select 
            union_credit_card.*
            , salesorderdetailid
            , carriertrackingnumber
            , productid
            , orderqty
            , unitprice
            , case 
                when unitpricediscount != 0
                    then unitpricediscount
                else null
            end as unitpricediscount
            , ((1 - coalesce(unitpricediscount,0)) * unitprice * orderqty) as sub_total_fixed
        from salesorderdetail 
        left join union_credit_card on union_credit_card.salesorderid =  salesorderdetail.salesorderid
    )

    , count_orders as (
        select 
            salesorderid
            , count(salesorderid) as count_orders_rows
        from union_header_detail
        group by salesorderid
    )

    , join_fixing_columns as (
        select
            union_header_detail.*
            , count_orders_rows
            , freight / count_orders_rows as freight_fixed
            , taxamt / count_orders_rows as tax_fixed
        from union_header_detail
        left join count_orders on count_orders.salesorderid  = union_header_detail.salesorderid
    )

    , fixed_table as (
        select 
            salesorderid
            , productid
            , salesorderdetailid
            , customerid
            , salespersonid
            , territoryid
            , billtoaddressid
            , shiptoaddressid
            , shipmethodid
            , creditcardid
            , orderdate as order_date
            , case 
                when creditcardapprovalcode is not null
                    then 'Credit Card Payment'
                else 'Other payment method'
            end as paid_with_credit_card
            , case 
                when purchaseordernumber is not null
                    then 'Physical store'
                else 'Online purchase'
            end as online_order
            , cardtype as card_type
            , order_status
            , carriertrackingnumber as carrier_tracking_number
            , orderqty as order_qty
            , unitprice as unit_price
            , unitpricediscount as unit_price_discount
            , sub_total_fixed
            , freight_fixed
            , tax_fixed
            , sub_total_fixed + freight_fixed + tax_fixed as total_due_fixed
            , unitprice * orderqty as total_gross
        from join_fixing_columns
    )

select * 
from fixed_table
