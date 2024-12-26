with
    sales_order_detail as (
        select
            salesorderid /* Primary key*/
            , salesorderdetailid /* Primary key*/				
            , productid	/*Foreign key */
            , specialofferid /*Foreign key */					
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
