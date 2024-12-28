with
    product_subcategory as (
        select
            /* Primary key */
            productsubcategoryid
            /* Foreign key */
            , productcategoryid	
            /* Informations about product caracteristics*/
            , name as name_product_subcategory
            /* Informations about business */
            , modifieddate	
            , rowguid				

        from {{source('raw_production', 'productsubcategory')}}
    )

select *
from product_subcategory
