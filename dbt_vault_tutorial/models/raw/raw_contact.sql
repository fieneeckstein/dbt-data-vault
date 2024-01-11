with contact_data as (
    select *, current_timestamp as load_date from {{ source('bikerpoint','contact') }}
)

select * from contact_data