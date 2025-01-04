with 
    sales_order_header as (
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

    , sales_order_detail as (
        select
            /* Primary key */
            salesorderid
            , salesorderdetailid					
            /* Foreign key */
            , productid	
            , specialofferid					
            /* Sales order detail */
            , carriertrackingnumber
            , orderqty
            , unitprice
            , unitpricediscount
        from {{ref('stg_sales_order_detail')}}
    )

    , sales_order_header_sales_reason as (
        select
            /* Primary key and Foreign key */
            salesreasonid
            , salesorderid
        from {{ref('stg_sales_order_header_sales_reason')}}
    )

    , credit_card as (
        select * 
        from {{ ref('stg_sales_credit_card') }}	
    )

    , int_reason as (
        select *
        from {{ref('agg_reason')}}
    )

    , union_credit_card as (
        select 
            sales_order_header.*
            , credit_card.cardtype
        from sales_order_header 
        left join credit_card 
            on credit_card.creditcardid = sales_order_header.creditcardid
    )

    , union_header_detail as (
        select 
            union_credit_card.*
            , sales_order_detail.salesorderdetailid
            , sales_order_detail.carriertrackingnumber
            , sales_order_detail.productid
            , sales_order_detail.orderqty
            , sales_order_detail.unitprice
            , case 
                when sales_order_detail.unitpricediscount != 0
                    then sales_order_detail.unitpricediscount
                else null
            end as unitpricediscount
            , ((1 - coalesce(sales_order_detail.unitpricediscount, 0)) 
                * sales_order_detail.unitprice * sales_order_detail.orderqty) as sub_total_fixed
        from sales_order_detail 
        left join union_credit_card
            on union_credit_card.salesorderid = sales_order_detail.salesorderid
    )

    , count_orders as (
        select 
            salesorderid
            , count(*) as count_orders_rows
        from union_header_detail
        group by salesorderid
    )

    , join_fixing_columns as (
        select
            union_header_detail.*
            , count_orders.count_orders_rows
            , union_header_detail.freight / count_orders.count_orders_rows as freight_fixed
            , union_header_detail.taxamt / count_orders.count_orders_rows as tax_fixed
        from union_header_detail
        left join count_orders
            on count_orders.salesorderid = union_header_detail.salesorderid
    )

    , fixed_table as (
        select 
            salesorderid
            , salesorderdetailid
            , customerid
            , salespersonid
            , territoryid
            , billtoaddressid
            , shiptoaddressid
            , shipmethodid
            , creditcardid
            , productid
            , orderdate
            , case 
                when purchaseordernumber is not null
                    then 'Physical store'
                else 'Purchase online'
            end as online_order
            , case 
                when creditcardapprovalcode is not null
                    then 'Credit card payment'
                else 'Other payment method'
            end as paid_with_credit_card
            , cardtype
            , order_status
            , carriertrackingnumber
            , orderqty
            , unitprice
            , unitpricediscount
            , sub_total_fixed
            , freight_fixed
            , tax_fixed
            , sub_total_fixed + freight_fixed + tax_fixed as total_due_fixed
            , unitprice * orderqty as total_gross
        from join_fixing_columns
    )

    , union_reason as (
        select
            fixed_table.salesorderid
            , fixed_table.salesorderdetailid
            , fixed_table.customerid
            , fixed_table.salespersonid
            , fixed_table.territoryid
            , fixed_table.billtoaddressid
            , fixed_table.shiptoaddressid
            , fixed_table.shipmethodid
            , fixed_table.creditcardid
            , fixed_table.productid
            , fixed_table.orderdate as order_date
            , fixed_table.online_order
            , fixed_table.paid_with_credit_card
            , fixed_table.cardtype as card_type
            , fixed_table.order_status
            , fixed_table.carriertrackingnumber as carrier_tracking_number
            , fixed_table.orderqty as order_qty
            , fixed_table.unitprice as unit_price
            , fixed_table.unitpricediscount as unit_price_discount
            , fixed_table.sub_total_fixed
            , fixed_table.freight_fixed
            , fixed_table.tax_fixed
            , fixed_table.total_due_fixed
            , fixed_table.total_gross
            , int_reason.reason_type
        from fixed_table
        left join int_reason 
            on int_reason.salesorderid = fixed_table.salesorderid     
    )

select * 
from union_reason
