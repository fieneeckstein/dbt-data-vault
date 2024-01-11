with customers_data as (
    select *, current_timestamp as load_date from {{ source('bikerpoint','crm_customer') }}
)

select * from customers_data