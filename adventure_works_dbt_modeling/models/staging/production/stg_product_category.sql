with
    product_category as (
        select
            /* Primary Key */
            productcategoryid
            /* Informations about product caracteristics */
            , name as name_product_category
            /* Informations abou business */
            , modifieddate	
            , rowguid				

        from {{source('raw_production', 'productcategory')}}
    )

select *
from product_category
