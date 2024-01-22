
with purchase_data as (
    select *, current_timestamp as load_date from {{ source('bikerpoint','purchase') }}
),
customer_nk as (
    select id as cid, customerno from  {{ source('bikerpoint','customer') }} 
),
final as (
    select * from purchase_data p left join customer_nk cnk on p.customer_id = cnk.cid
)
select * from final
