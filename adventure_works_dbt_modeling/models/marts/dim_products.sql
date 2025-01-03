with
    product as (
        select
            /* Primary key */
            productid
            /* Foreign key */
            , productsubcategoryid	
            /* Informations and caracteristics about the products */
            , productnumber			
            , name_product
            , rowguid				
        from {{ref('stg_product')}}
    )

    , product_category as (
        select
            /* Primary key */
            productcategoryid
            /* Informations and caracteristics about the products */
            , name_product_category
        from {{ref('stg_product_category')}}
    )
    
    , product_subcategory as (
        select
            /* Primary key */
            productsubcategoryid
            /* Foreign key */
            , productcategoryid	
            /* Informations and caracteristics about the products  */
            , name_product_subcategory
        from {{ref('stg_product_subcategory')}}
    )
    
    , remove_duplicates as (
        select
            *,
            row_number() over (
                partition by productid 
                order by productid
            ) as remove_duplicates_index,
        from product
    )

    , join_dim_product as (
        select
            {{ dbt_utils.generate_surrogate_key(['productid']) }} as dim_product_sk
            , coalesce(remove_duplicates.productsubcategoryid, 0) as productsubcategoryid
            , remove_duplicates.name_product
            , product_category.name_product_category
            , coalesce(product_subcategory.name_product_subcategory, 'Not informed') as name_product_subcategory
            from remove_duplicates
            left join product_subcategory 
                on (remove_duplicates.productsubcategoryid = product_subcategory.productsubcategoryid)
            left join product_category 
                on (product_subcategory.productcategoryid = product_category.productcategoryid)
            where remove_duplicates_index = 1 
    )

    , products_columns_final as (
        select 
            dim_product_sk
            , productsubcategoryid
            , name_product
            , name_product_category
            , name_product_subcategory
        from join_dim_product
    )

select *
from products_columns_final
