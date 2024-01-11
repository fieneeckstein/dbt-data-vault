with product_data as (
    select *, current_timestamp as load_date  from {{ source('bikerpoint','product') }}
)
select * from product_data