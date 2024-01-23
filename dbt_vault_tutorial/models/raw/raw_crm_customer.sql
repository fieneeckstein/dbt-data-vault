with customers_data as (
    select *, to_date('{{var('load_date')}}' ,'yyyy-mm-dd') as load_date from {{ source('bikerpoint','crm_customer') }}
)

select * from customers_data