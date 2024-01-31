SELECT * FROM (
    SELECT
  		COUNT(*) AS total_count,
        COUNT(CASE WHEN load_date = '2024-01-01' THEN 1 END) AS count_20240101,
        COUNT(CASE WHEN load_date = '2024-01-02' THEN 1 END) AS count_20240102
        FROM {{ ref('sat_customer_crm_details' )}}
) AS TMP
WHERE (
  total_count != 2 OR count_20240101 != 1 OR count_20240102 !=1    
)