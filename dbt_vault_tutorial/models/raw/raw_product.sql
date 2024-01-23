with product_data as (
    select *, to_date('{{var('load_date')}}' ,'yyyy-mm-dd') as load_date  from {{ source('bikerpoint','product') }}
)
select * from product_data