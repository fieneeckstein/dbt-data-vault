SELECT *
FROM (
    SELECT 1
    FROM {{ ref('dim_product' )}}
    UNION ALL
    SELECT 1
    FROM {{ ref('dim_customer' )}}
) AS combined_tables

WHERE EXISTS (SELECT 1 FROM {{ ref('dim_product' )}}) OR EXISTS (SELECT 1 FROM {{ ref('dim_customer' )}})