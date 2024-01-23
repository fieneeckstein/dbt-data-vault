{%- set yaml_metadata -%}
source_model: "stg_products"
src_pk: "PRODUCT_PK"
src_hashdiff: 
  source_column: "PRODUCT_PRICE_HASHDIFF"
  alias: "HASHDIFF"
src_payload:
  - "price"
src_eff: "EFFECTIVE_FROM"
src_ldts: "LOAD_DATE"
src_source: "RECORD_SOURCE"
{%- endset -%}

{% set metadata_dict = fromyaml(yaml_metadata) %}

{{ automate_dv.sat(src_pk=metadata_dict["src_pk"],
                   src_hashdiff=metadata_dict["src_hashdiff"],
                   src_payload=metadata_dict["src_payload"],
                   src_eff=metadata_dict["src_eff"],
                   src_ldts=metadata_dict["src_ldts"],
                   src_source=metadata_dict["src_source"],
                   source_model=metadata_dict["source_model"])   }}
