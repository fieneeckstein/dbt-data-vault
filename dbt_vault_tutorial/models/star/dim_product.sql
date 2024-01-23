with active_satellite_entry as (
select product_pk as active_ppk, sat_product_details_ldts as active_ldts from {{ ref('pit_product') }} where as_of_date = to_date('{{var('star_date')}}' ,'yyyy-mm-dd') 
),

final as (
    select product_pk, ean, price from {{ ref('sat_product_details') }} join active_satellite_entry a on product_pk=active_ppk and load_date = active_ldts
)

select * from final