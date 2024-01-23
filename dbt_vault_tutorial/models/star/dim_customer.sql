with active_satellite_entry as (
select customer_pk as active_cpk, sat_customer_details_ldts as active_ldts from {{ ref('pit_customer') }} where  as_of_date  = current_date + 1
),

final as (
    select customer_pk, customerno, birthdate, address, email from {{ ref('sat_customer_details') }} join active_satellite_entry a on customer_pk=active_cpk and load_date = active_ldts
)

select * from final