with
    sales_order_header as (
        select
            /* Primary key */
            salesorderid 
            /* Foreigns keys */	
            , customerid 	
            , salespersonid		
            , territoryid 	
            , billtoaddressid 
            , shiptoaddressid 	
            , creditcardid 			
            , currencyrateid 				
            , shipmethodid 				
            /* Orders informations for customer*/
            , status as order_status
            , purchaseordernumber
            , creditcardapprovalcode					
            , accountnumber					
            , onlineorderflag
	        , cast(salesorderheader.orderdate as timestamp) as orderdate
            , shipdate	
            , duedate		
            /*Order pricing*/
            , subtotal
            , taxamt					
            , freight		
            , totaldue					
            /*Other informations*/      
            , rowguid					
            , modifieddate					
            , revisionnumber					
            , comment				

        from {{source('raw_sales', 'salesorderheader')}}
    )

select *
from sales_order_header
