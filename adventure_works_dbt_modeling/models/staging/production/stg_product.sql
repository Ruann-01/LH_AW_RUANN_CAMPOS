with
    product as (
        select
            /* Primary Key */
            productid
            /* Foreigns keys */
            , productsubcategoryid	
            , productmodelid
            /* Informations about product caracteristics */
            , productnumber			
            , name as name_product
            , productline					
            , color	
            , style				
            , size as size_product
            , sizeunitmeasurecode
            , weightunitmeasurecode	
            , weight as weight_product	
            /* Informations about price and manufacturing */            
            , listprice					
            , class					
            , standardcost					
            , daystomanufacture	
            /* Informations about business */
            , reorderpoint					
            , safetystocklevel					
            , makeflag
            , finishedgoodsflag	
            , sellstartdate
            , sellenddate
            , discontinueddate					
            , modifieddate	
            , rowguid				

        from {{source('raw_production', 'product')}}
    )

select *
from product
