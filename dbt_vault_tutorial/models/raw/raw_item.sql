with item_data as (
    select *, to_date('{{var('load_date')}}' ,'yyyy-mm-dd') as load_date from {{ source('bikerpoint','item') }}
),
purchase_nk as (
    select id as purId, orderno from  {{ source('bikerpoint','purchase') }} 
),
product_nk as (
    select id as pid, ean from  {{ source('bikerpoint','product') }} 
),
final as (
    select * from item_data i left join purchase_nk purNk on i.order_id = purNk.purId left join product_nk pnk on i.product_id = pnk.pid
)
select * from final
