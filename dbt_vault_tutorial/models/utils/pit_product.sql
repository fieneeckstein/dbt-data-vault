{{ config(materialized='pit_incremental', enabled=true) }}

{%- set yaml_metadata -%}
source_model: hub_product
src_pk: PRODUCT_PK
src_ldts: LOAD_DATE
as_of_dates_table: as_of_date
satellites: 
  sat_product_details:
    pk:
      PK: PRODUCT_PK
    ldts:
      LDTS: LOAD_DATE
  
stage_tables_ldts: 
  stg_products: LOAD_DATE  
{%- endset -%}

{% set metadata_dict = fromyaml(yaml_metadata) %}

{% set source_model = metadata_dict['source_model'] %}
{% set src_pk = metadata_dict['src_pk'] %}
{% set as_of_dates_table = metadata_dict['as_of_dates_table'] %}
{% set satellites = metadata_dict['satellites'] %}
{% set stage_tables_ldts = metadata_dict['stage_tables_ldts'] %}
{% set src_ldts = metadata_dict['src_ldts'] %}

{{ automate_dv.pit(source_model=source_model, src_pk=src_pk,
                   as_of_dates_table=as_of_dates_table,
                   satellites=satellites,
                   stage_tables_ldts=stage_tables_ldts,
                   src_ldts=src_ldts) }}