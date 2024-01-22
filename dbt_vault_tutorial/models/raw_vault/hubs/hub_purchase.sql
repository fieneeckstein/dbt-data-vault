
{% set source_model = "stg_purchase" %}
{% set src_pk = "PURCHASE_PK" %}
{% set src_nk = "orderno" %}
{% set src_ldts = "LOAD_DATE" %}
{% set src_source = "RECORD_SOURCE" %}

{{ automate_dv.hub(src_pk=src_pk, src_nk=src_nk, src_ldts=src_ldts,
                   src_source=src_source, source_model=source_model) }}

