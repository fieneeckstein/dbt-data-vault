SELECT *
FROM (
    SELECT 'dim_p' AS table_name, COUNT(*) AS entry_count
    FROM {{ ref('dim_product' )}}
    UNION ALL
    SELECT 'dim_c' AS table_name, COUNT(*) AS entry_count
    FROM {{ ref('dim_customer' )}}
) AS table_counts
WHERE
    (table_name = 'dim_p' AND entry_count != 100)
    OR
    (table_name = 'dim_c' AND entry_count != 64)
