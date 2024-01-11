with item_data as (
    select *, current_timestamp as load_date from {{ source('bikerpoint','item') }}
)
select * from item_data

-- Reichere item noch mit dem NK der Purchases und Produkte an
