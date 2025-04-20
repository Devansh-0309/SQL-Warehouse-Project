/*
==============================================================
Cleaning the data of Bronze.crm_sales_details
==============================================================

Purpose of the Script
	This Piece of code cleans the table by following:
		1. Removes the duplicates and replaces the nulls 
		2. Removes empty spaces from the string type columns
		3. Stardardization of columns into something meaningful
		4. Converts the data type to appropriate type
		5. Mathematical formulaes to clean the columns

	Then this script inserts the cleaned data to the table in the silver layer
*/ 

PRINT 'Truncating Table : Silver.crm_sales_details'
TRUNCATE TABLE Silver.crm_sales_details

PRINT 'Inserting Into Table: Silver.crm_sales_details'
INSERT INTO Silver.crm_sales_details(
sls_ord_num,
sls_prd_key,
sls_cust_id,
sls_order_dt,
sls_ship_dt,
sls_due_dt,
sls_sales,
sls_quant,
sls_price
)

SELECT 
sls_ord_num,
sls_prd_key,
sls_cust_id,

-- Case statement to check, change and clean the date columns 
CASE 
	WHEN sls_order_dt = 0 OR LEN(sls_order_dt) != 8 THEN NULL
	ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE)
END AS sls_order_dt,
CASE 
	WHEN sls_ship_dt = 0 OR LEN(sls_ship_dt) != 8 THEN NULL
	ELSE CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE)
END AS sls_ship_dt,
CASE 
	WHEN sls_due_dt = 0 OR LEN(sls_due_dt) != 8 THEN NULL
	ELSE CAST(CAST(sls_due_dt AS VARCHAR) AS DATE)
END AS sls_due_dt,

-- Case statements to clean the numerical columns
CASE
	WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quant * ABS(sls_price) THEN sls_quant * ABS(sls_price)
	ELSE sls_sales
END AS sls_sales,
sls_quant,
CASE 
	WHEN sls_price IS NULL OR sls_price <= 0 THEN sls_sales/NULLIF(sls_quant, 0)
	ELSE sls_price
END AS sls_price
FROM Bronze.crm_sales_details
SELECT * FROM Bronze.crm_sales_details;
