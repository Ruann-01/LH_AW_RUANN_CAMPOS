with
    sales_order_detail as (
        select
            /* Primarys keys */
            salesorderid 
            , salesorderdetailid			
            /*Foreigns keys */
            , productid	
            , specialofferid 					
            /* Informations about sales order detail */
            , carriertrackingnumber
            , orderqty
            , unitprice
            , unitpricediscount
            , rowguid
            , modifieddate

        from {{source('raw_sales', 'salesorderdetail')}}
    )

select *
from sales_order_detail
