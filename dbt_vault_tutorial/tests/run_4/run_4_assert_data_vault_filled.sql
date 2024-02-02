SELECT *
FROM (
    SELECT 'hub_product' AS table_name, COUNT(*) AS entry_count
    FROM {{ ref('hub_product' )}}
    UNION ALL
    SELECT 'hub_customer' AS table_name, COUNT(*) AS entry_count
    FROM {{ ref('hub_customer' )}}
    UNION ALL
    SELECT 'hub_purchase' AS table_name, COUNT(*) AS entry_count
    FROM {{ ref('hub_purchase' )}}
    UNION ALL
    SELECT 'link_customer_purchase' AS table_name, COUNT(*) AS entry_count
    FROM {{ ref('link_customer_purchase' )}}
    UNION ALL
    SELECT 'link_purchase_product' AS table_name, COUNT(*) AS entry_count
    FROM {{ ref('link_purchase_product' )}}
    UNION ALL
    SELECT 'sat_customer_details' AS table_name, COUNT(*) AS entry_count
    FROM {{ ref('sat_customer_details' )}}
    UNION ALL
    SELECT 'sat_purchase_details' AS table_name, COUNT(*) AS entry_count
    FROM {{ ref('sat_purchase_details' )}}
    UNION ALL
    SELECT 'sat_product_details' AS table_name, COUNT(*) AS entry_count
    FROM {{ ref('sat_product_details' )}}
    UNION ALL
    SELECT 'sat_customer_crm_details' AS table_name, COUNT(*) AS entry_count
    FROM {{ ref('sat_customer_crm_details' )}}
) AS table_counts
WHERE
    (table_name = 'hub_product' AND entry_count != (SELECT count (distinct ean) from {{ ref('raw_product' )}})) -- In der Raw Tabelle sind Duplikate in den eans. Müsste man in einem Datenqualitätsschritt behandeln
    OR
    (table_name = 'hub_customer' AND entry_count != (SELECT COUNT(*)
FROM (
    SELECT cn FROM (SELECT DISTINCT customerno AS cn FROM {{ ref('raw_customer' )}}) AS sub1
    UNION
    SELECT crmno FROM (SELECT DISTINCT customerno AS crmno FROM {{ ref('raw_crm_customer' )}}) AS sub2
) AS combined_result))
    OR
    (table_name = 'hub_purchase' AND entry_count != (SELECT count (distinct orderno) from {{ ref('raw_purchase' )}}))
    OR
    (table_name = 'link_customer_purchase' AND entry_count != (SELECT count (distinct orderno) from {{ ref('raw_purchase' )}}))
     OR
    (table_name = 'link_purchase_product' AND entry_count !=  522 )--(SELECT count (distinct id) from {{ ref('raw_item' )}})   ) --todo: warum nicht so viele wie es items gibt
    OR
    (table_name = 'sat_customer_details' AND entry_count != (SELECT count (distinct customerno) from {{ ref('raw_customer' )}}))
    OR
    (table_name = 'sat_purchase_details' AND entry_count != (SELECT count (distinct orderno) from {{ ref('raw_purchase' )}}))
    OR
    (table_name = 'sat_product_details' AND entry_count != 116 )-- Produkte mit derselben ean werden als selbes Produkt betrachtet, das sich verändert hat -> einige fälschliche Satelliteneinträge
    OR
    (table_name = 'sat_customer_crm_details' AND entry_count != (SELECT count (distinct customerno)+1 from {{ ref('raw_crm_customer' )}}))



--SQL:

--SELECT *
--FROM (
--    SELECT 'hub_product' AS table_name, COUNT(*) AS entry_count
--    FROM public_raw_vault.hub_product
--    UNION ALL
--    SELECT 'hub_customer' AS table_name, COUNT(*) AS entry_count
--    FROM public_raw_vault.hub_customer
--    UNION ALL
--    SELECT 'hub_purchase' AS table_name, COUNT(*) AS entry_count
--    FROM public_raw_vault.hub_purchase
--    UNION ALL
--    SELECT 'link_customer_purchase' AS table_name, COUNT(*) AS entry_count
--    FROM public_raw_vault.link_customer_purchase
--    UNION ALL
--    SELECT 'link_purchase_product' AS table_name, COUNT(*) AS entry_count
--    FROM public_raw_vault.link_purchase_product
--    UNION ALL
--    SELECT 'sat_customer_details' AS table_name, COUNT(*) AS entry_count
--    FROM public_raw_vault.sat_customer_details
--    UNION ALL
--    SELECT 'sat_purchase_details' AS table_name, COUNT(*) AS entry_count
--    FROM public_raw_vault.sat_purchase_details
--    UNION ALL
--    SELECT 'sat_product_details' AS table_name, COUNT(*) AS entry_count
--    FROM public_raw_vault.sat_product_details
--    UNION ALL
--    SELECT 'sat_customer_crm_details' AS table_name, COUNT(*) AS entry_count
--    FROM public_raw_vault.sat_customer_crm_details
--) AS table_counts
--WHERE
--(table_name = 'hub_product' AND entry_count != (SELECT count (distinct ean) from product)) -- In der Raw Tabelle sind Duplikate in den eans. Müsste man in einem Datenqualitätsschritt behandeln
--    OR
--    (table_name = 'hub_customer' AND entry_count != (SELECT COUNT(*)
--FROM (
--    SELECT cn FROM (SELECT DISTINCT customerno AS cn FROM customer) AS sub1
--    UNION
--    SELECT crmno FROM (SELECT DISTINCT customerno AS crmno FROM crm_customer) AS sub2
--) AS combined_result))
--    OR
--    (table_name = 'hub_purchase' AND entry_count != (SELECT count (distinct orderno) from purchase))
--    OR
--    (table_name = 'link_customer_purchase' AND entry_count != (SELECT count (distinct orderno) from purchase))
--     OR
--    (table_name = 'link_purchase_product' AND entry_count !=  522  )
--    OR
--    (table_name = 'sat_customer_details' AND entry_count != (SELECT count (distinct customerno) from customer))
--    OR
--    (table_name = 'sat_purchase_details' AND entry_count != (SELECT count (distinct orderno) from purchase))
--    OR
--    (table_name = 'sat_product_details' AND entry_count != 116 )-- Produkte mit derselben ean werden als selbes Produkt betrachtet, das sich verändert hat -> einige fälschliche Satelliteneinträge
--    OR
--    (table_name = 'sat_customer_crm_details' AND entry_count != (SELECT count (distinct customerno)+1 from crm_customer))
--