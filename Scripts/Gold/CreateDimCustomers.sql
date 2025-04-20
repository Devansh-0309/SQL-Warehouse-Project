/*
----------------------------------------------------
Creating Gold Layer View: dim_customers
----------------------------------------------------

Purpose of this script:
	This script aims to connect the tables on the basis of various columns that can be used further for analysis.

What we did:
	1. Connected tables on basis of different columns
	2. Renamed the columns to user friendly type
	3. Created a primary key using window function
	4. Created a view
*/



-- Creating a View in the database
CREATE VIEW Gold.dim_customers AS

--  Integrating the data using keys
SELECT 

-- Using window function to create a primary key
ROW_NUMBER() OVER(ORDER BY cst_id) AS customer_key,
ci.cst_id AS customer_id,
ci.cst_key AS customer_number,
ci.cst_firstname AS first_name,
ci.cst_lastname AS last_name,
lo.cntry AS country,
ci.cst_marital_status AS marital_status,
CASE 
	WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr
	ELSE COALESCE(ca.gen, 'n/a')
END AS gender,
ca.bdate AS birth_date,
ci.cst_create_date AS create_date
FROM Silver.crm_cust_info AS ci
LEFT JOIN Silver.erp_cust_az12 AS ca
ON ci.cst_key = ca.cid
LEFT JOIN Silver.erp_loc_a101 AS lo
ON ci.cst_key = lo.cid
