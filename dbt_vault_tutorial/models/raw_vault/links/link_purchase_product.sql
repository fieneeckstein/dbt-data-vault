
{% set source_model = "stg_items" %}

{% set src_pk = "ITEM_PK" %}

{% set src_fk = ["PRODUCT_PK", "PURCHASE_PK"] %}

{% set src_ldts = "LOAD_DATE" %}

{% set src_source = "RECORD_SOURCE" %}


{{ automate_dv.link(src_pk=src_pk, src_fk=src_fk, src_ldts=src_ldts,
                   src_source=src_source, source_model=source_model) }}
