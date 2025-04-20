/*
----------------------------------------------------
Creating Gold Layer View: dim_products
----------------------------------------------------

Purpose of this script:
	This script aims to connect the tables on the basis of various columns that can be used further for analysis.

What we did:
	1. Connected tables on basis of different columns
	2. Renamed the columns to user friendly type
	3. Created a primary key using window function
	4. Created a view
*/

-- Creating a view in the database
CREATE VIEW Gold.dim_products AS 

SELECT 

-- Creating a primary key using window function
ROW_NUMBER() OVER(ORDER BY prd_start_dt, prd_key) AS product_key,
pr.prd_id AS product_id,
pr.prd_key AS product_number,
pr.prd_nm AS product_name,
pr.cat_id AS category_id,
ps.cat AS category,
ps.subcat AS sub_category,
ps.maintenance AS maintenance,
pr.prd_cost AS cost,
pr.prd_line AS product_line,
pr.prd_start_dt AS start_date
FROM Silver.crm_prd_info AS pr
LEFT JOIN Silver.erp_px_cat_g1v2 AS ps
ON pr.cat_id = ps.id
WHERE prd_end_dt IS NULL  -- Where condition to have only current data
