with purchase_data as (
    select *, current_timestamp as load_date from {{ source('bikerpoint','purchase') }}
)

select * from purchase_data
