with
    person as (
        select
            /* Primary key and Foreign key */
            businessentityid

            /* Informations about humans involved with AW */
            , namestyle
            , persontype
            , title
            , suffix
            , firstname
            , middlename
            , lastname
            , additionalcontactinfo
            , demographics
            , emailpromotion
            , rowguid
            , modifieddate

        from {{source('raw_person', 'person')}}
    )

select *
from person
