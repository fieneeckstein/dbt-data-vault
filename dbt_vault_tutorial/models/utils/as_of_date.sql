{{ config(materialized='table') }}

{%- set datepart = "minute" -%}
{%- set start_date = "TO_DATE('2023-12-20', 'yyyy-mm-dd')" -%}
{%- set end_date = "TO_DATE('2023-12-21', 'yyyy-mm-dd')" -%}

WITH as_of_date AS (
    {{ dbt_utils.date_spine(datepart=datepart, 
                            start_date=start_date,
                            end_date=end_date) }}
)

SELECT DATE_{{datepart}} as AS_OF_DATE FROM as_of_date
