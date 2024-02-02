with active_satellite_entry as (
select customer_pk as active_cpk, sat_customer_details_ldts as active_ldts from {{ ref('pit_customer') }} where as_of_date = to_date('{{var('star_date')}}' ,'yyyy-mm-dd') 
),

active_crm_satellite_entry as (
select customer_pk as active_crmpk, sat_customer_crm_details_ldts as active_crm_ldts from  {{ ref('pit_customer') }} where as_of_date = to_date('{{var('star_date')}}' ,'yyyy-mm-dd') 
),

join1 as (
     select customer_pk, customerno, birthdate, address, email from {{ ref('sat_customer_details') }} join active_satellite_entry a on customer_pk=active_cpk and load_date = active_ldts
),
join2 as (
     select customer_pk as customer_crm_pk, email as crm_email from {{ ref('sat_customer_crm_details') }} join active_crm_satellite_entry a on customer_pk=active_crmpk and load_date = active_crm_ldts
),
final as  (
  select * from join1 full outer join join2 on customer_pk = customer_crm_pk
)

select * from final
