with retour_data as (
    select *, to_date('{{var('load_date')}}' ,'yyyy-mm-dd') as load_date from {{ source('bikerpoint','retour') }}
)

select * from retour_data