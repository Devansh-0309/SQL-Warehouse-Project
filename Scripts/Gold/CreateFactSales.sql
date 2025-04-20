/*
----------------------------------------------------
Creating Gold Layer View: dim_customers
----------------------------------------------------

Purpose of this script:
	This script aims to connect the view on the basis of various columns that can be used further for analysis.

What we did:
	1. Connected gold layer and silver layer (Fact and dimesion tables) on basis of different columns
	2. Renamed the columns to user friendly type
	3. Created a view
*/

-- Creating View for fact table
CREATE VIEW Gold.fact_sales AS

-- Connecting gold layer to silver layer 
SELECT 
sd.sls_ord_num AS order_number,
gp.product_key,
gc.customer_key,
sd.sls_sales AS sales,
sd.sls_quant AS quantity,
sd.sls_price AS price,
sd.sls_order_dt AS order_date,
sd.sls_ship_dt AS ship_date,
sd.sls_due_dt AS due_date
FROM Silver.crm_sales_details AS sd
LEFT JOIN Gold.dim_products AS gp
ON sd.sls_prd_key = gp.product_number
LEFT JOIN Gold.dim_customers AS gc
ON sd.sls_cust_id = gc.customer_id 
