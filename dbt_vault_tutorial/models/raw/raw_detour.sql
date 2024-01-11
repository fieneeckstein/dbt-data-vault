with retour_data as (
    select *, current_timestamp as load_date from {{ source('bikerpoint','retour') }}
)

select * from retour_data