/*
==============================================================
Cleaning the data of Bronze.crm_cust_info
==============================================================

Purpose of the Script
	This Piece of code cleans the table by following:
		1. Removes the duplicates and replaces the nulls 
		2. Removes empty spaces from the string type columns
		3. Stardardization of columns into something meaningful

	Then this script inserts the cleaned data to the table in the silver layer
*/
PRINT 'Truncating Table: Silver.crm_cust_info'
TRUNCATE TABLE Silver.crm_cust_info

PRINT 'Inserting Into Table: Silver.crm_cust_info'
-- Inserting the Data into Silver Layer table
INSERT INTO Silver.crm_cust_info(
	cst_id,
	cst_key,
	cst_firstname,
	cst_lastname,
	cst_marital_status,
	cst_gndr,
	cst_create_date
)

SELECT 
cst_id,
cst_key,

-- Trimming the empty spaces from the string type columns
TRIM(cst_firstname) AS cst_firstname,
TRIM(cst_lastname) AS cst_lastname,

-- Case statement for data standardization
CASE 
	WHEN cst_marital_status = 'S' THEN 'Single'
	WHEN cst_marital_status = 'M' THEN 'Married'
	ELSE 'n/a'
END AS cst_marital_status,
CASE 
	WHEN TRIM(UPPER(cst_gndr)) = 'F' THEN 'Female'
	WHEN TRIM(UPPER(cst_gndr)) = 'M' THEN 'Male'
	ELSE 'n/a'
END AS cst_gndr,
cst_create_date
FROM
(
	SELECT 
	*,
	-- Window function to remove the duplicates and nulls from the primary key candidate
	ROW_NUMBER() OVER(PARTITION BY cst_id ORDER BY cst_create_date DESC) AS rank_last
	FROM Bronze.crm_cust_info
	WHERE cst_id IS NOT NULL
)t WHERE rank_last = 1
