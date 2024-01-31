-- copied from run_1
SELECT table_name, COUNT(*)
FROM (
    SELECT 'hub_product' AS table_name, load_date
    FROM {{ ref('hub_product' )}}
    UNION ALL
    SELECT 'hub_customer' AS table_name, load_date
    FROM {{ ref('hub_customer' )}}
    UNION ALL
    SELECT 'hub_purchase' AS table_name, load_date
    FROM {{ ref('hub_purchase' )}}
    UNION ALL
    SELECT 'link_customer_purchase' AS table_name, load_date
    FROM {{ ref('link_customer_purchase' )}}
    UNION ALL
    SELECT 'link_purchase_product' AS table_name, load_date
    FROM {{ ref('link_purchase_product' )}}
    UNION ALL
    SELECT 'sat_customer_details' AS table_name, load_date
    FROM {{ ref('sat_customer_details' )}}
    UNION ALL
    SELECT 'sat_purchase_details' AS table_name, load_date
    FROM {{ ref('sat_purchase_details' )}}
    UNION ALL
    SELECT 'sat_product_details' AS table_name, load_date
    FROM {{ ref('sat_product_details' )}}
    UNION ALL
    SELECT 'sat_customer_crm_details' AS table_name, load_date
    FROM {{ ref('sat_customer_crm_details' )}}
) AS combined_tables
WHERE load_date != '2024-01-01'
GROUP BY table_name
HAVING COUNT(*) > 0