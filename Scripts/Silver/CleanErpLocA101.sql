/*
==============================================================
Cleaning the data of Bronze.erp_loc_a101
==============================================================

Purpose of the Script
	This Piece of code cleans the table by following:
		1. Removes unwanted characters 
		2. Removes empty spaces from the string type columns
		3. Stardardization of columns into something meaningful

	Then this script inserts the cleaned data to the table in the silver layer
*/
PRINT 'Truncating Table: Silver.erp_loc_a101'
TRUNCATE TABLE Silver.erp_loc_a101

PRINT 'Inserting Into Table: Silver.erp_loc_a101'
-- Inserting data into silver layer table
INSERT INTO Silver.erp_loc_a101 (cid, cntry)

SELECT 
-- replace the unwanted symbol
TRIM(REPLACE(cid ,'-','')) AS cid,

-- Transform the column and remove the abbrevations
CASE 
	WHEN UPPER(TRIM(cntry)) IN ('US', 'USA', 'UNITED STATES') THEN 'United States'
	WHEN UPPER(TRIM(cntry)) IN ('DE', 'GERMANY') THEN 'Germany'
	WHEN UPPER(TRIM(cntry)) IN ('UNITED KINGDOM') THEN 'United Kingdom'
	WHEN UPPER(TRIM(cntry)) IN ('AUSTRALIA') THEN 'Australia'
	WHEN UPPER(TRIM(cntry)) = 'CANADA' THEN 'Canada'
	WHEN UPPER(TRIM(cntry)) = 'FRANCE' THEN 'France'
	ELSE 'n/a'
END AS cntry
FROM Bronze.erp_loc_a101
