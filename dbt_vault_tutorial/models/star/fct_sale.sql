with active_purchase_details as (
   select  deliverydate, orderdate, shipdate, deliverydate - orderdate as waiting_time,  shipdate-orderdate as processing_time, customerno, purchase_pk from {{ ref('sat_purchase_details') }} where load_date < current_date + 1
),
dim_customer_fk as (
    select customer_pk, customerno as custno from {{ ref('dim_customer') }}
),
dim_product_fk as (
    select product_pk, ean as custno from {{ ref('dim_product') }}
),
total_sales_volume as (
    select sum(price) as total_sale, purchase_pk as tsv_purchase_pk from {{ ref('link_purchase_product') }} l left join {{ ref('dim_product') }} d on l.product_pk = d.product_pk group by purchase_pk
),
joined as (
    select * from active_purchase_details a left join dim_customer_fk d on a.customerno = d.custno left join total_sales_volume on purchase_pk = tsv_purchase_pk
)

select * from joined