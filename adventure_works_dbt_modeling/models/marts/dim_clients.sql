with
    customer as (
        select
            /* Primary key */
            customerid
            /* Foreign key */
            , personid
            , storeid
            , territoryid
        from {{ref('stg_sales_customer')}}
    )

    , person as (
        select
            /* Primary key and Foreign key */
            businessentityid
            /* Others informations */
            , persontype
            , complete_name
        from {{ref('stg_person')}}
    )

    , store as (
        select
            /* Primary key */
            businessentityid
            /* Foreign key */
            , salespersonid
            /* Stores (resellers) of ADW products */
            , name_store
        from {{ref('stg_sales_store')}}
    )

    , join_dim_client as (
        select
            {{ create_surrogate_key(['customer.customerid']) }} as dim_client_sk
            , customer.customerid
            , customer.personid
            , coalesce(customer.storeid, 0) as storeid
            , coalesce(store.name_store, 'Not informed') as name_store
            , customer.territoryid
            , case
                when person.persontype = 'SC' then 'Store Contact'
                when person.persontype = 'IN' then 'Individual Customer'
                when person.persontype = 'SP' then 'Sales Person'
                when person.persontype = 'EM' then 'Employee'
                when person.persontype = 'VC' then 'Vendor'
                when person.persontype = 'GC' then 'General Contact'
                else 'Unknown Type'
            end as person_type
            , coalesce(person.complete_name, 'Unknown Name') as complete_name
        from customer
        left join person on customer.personid = person.businessentityid
        left join store on customer.storeid = store.businessentityid
        where customer.personid is not null
        order by customer.customerid asc
    )

    , client_transformed as (
        select
            dim_client_sk
            , customerid
            , personid
            , storeid
            , territoryid
            , name_store
            , person_type
            , complete_name
        from join_dim_client
    )

select *
from client_transformed
