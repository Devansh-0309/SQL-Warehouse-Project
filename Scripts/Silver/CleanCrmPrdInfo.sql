/*
==============================================================
Cleaning the data of Bronze.crm_prd_info
==============================================================

Purpose of the Script
	This Piece of code cleans the table by following:
		1. Removes the duplicates and replaces the nulls 
		2. Removes empty spaces from the string type columns
		3. Stardardization of columns into something meaningful
		4. Changes the datatype of the columns when necessary
		5. Uses Windows functions to perform various necessary operations

	Then this script inserts the cleaned data to the table in the silver layer
*/
PRINT 'Truncating Table: Silver.crm_prd_info'
TRUNCATE TABLE Silver.crm_prd_info

PRINT 'Inserting Into Table: Silver.crm_prd_info'
-- Inserting the Data into Silver Layer table
INSERT INTO Silver.crm_prd_info(
	prd_id,
	cat_id,
	prd_key,
	prd_nm,
	prd_cost,
	prd_line,
	prd_start_dt,
	prd_end_dt
)
SELECT 
	prd_id,

	-- Breaking a column into tow new columns 
	REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id,
	SUBSTRING(prd_key, 7, LEN(prd_key)) AS prd_key,
	prd_nm,

	-- Converting the null values to 0
	ISNULL(prd_cost, 0) AS prd_cost,

	-- Mapping the values to their full forms
	CASE UPPER(TRIM(prd_line))
		WHEN 'M' THEN 'Mountain'
		WHEN 'R' THEN 'Road'
		WHEN 'T' THEN 'Touring'
		WHEN 'S' THEN 'Other Sales'
		ELSE 'n/a'
	END AS prd_line,

	-- Changing the datatype and handling the errors in the date
	CAST(prd_start_dt AS DATE) AS prd_start_dt,
	CAST(LEAD(prd_start_dt) OVER(PARTITION BY prd_key ORDER BY prd_start_dt)-1 AS DATE) AS prd_end_dt
FROM Bronze.crm_prd_info;
