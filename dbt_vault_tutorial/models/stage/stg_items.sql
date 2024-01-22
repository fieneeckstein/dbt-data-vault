{%- set yaml_metadata -%}
source_model: 'raw_item'
derived_columns:
  RECORD_SOURCE: '!raw_item'
  LOAD_DATE: load_date
hashed_columns:
  ITEM_PK:
    - orderno
    - ean
  PRODUCT_PK:
    - ean
  PURCHASE_PK:
    - orderno
  ITEAM_HASHDIFF:
    is_hashdiff: true
    columns:
      - pieces
      - order_id
      - product_id
      - purid
      - orderno
      - pid
      - ean

{%- endset -%}

{% set metadata_dict = fromyaml(yaml_metadata) %}
{% set source_model = metadata_dict['source_model'] %}
{% set derived_columns = metadata_dict['derived_columns'] %}
{% set hashed_columns = metadata_dict['hashed_columns'] %}

{{ automate_dv.stage(include_source_columns=true,
                  source_model=source_model,
                  derived_columns=derived_columns,
                  hashed_columns=hashed_columns,
                  ranked_columns=none) }}