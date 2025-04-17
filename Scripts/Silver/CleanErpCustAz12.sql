/*
==============================================================
Cleaning the data of Bronze.erp_cust_az12
==============================================================

Purpose of the Script
	This Piece of code cleans the table by following:
		1. Removes unwanted characters 
		2. Removes empty spaces from the string type columns
		3. Stardardization of columns into something meaningful
		4. Cleans the invalid inputs

	Then this script inserts the cleaned data to the table in the silver layer
*/
PRINT 'Truncating Table: Silver.erp_cust_az12'
TRUNCATE TABLE Silver.erp_cust_az12

PRINT 'Inserting Into Table: Silver.erp_cust_az12'
INSERT INTO Silver.erp_cust_az12(cid, bdate, gen)

SELECT
-- Removing the unwanted characters
CASE 
	WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LEN(cid))
	ELSE cid
END AS cid,

-- Removing invalid dates
CASE 
	WHEN bdate > GETDATE() THEN NULL
	ELSE bdate
END AS bdate,

-- Handling and converting abbrevations to full forms
CASE 
	WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
	WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
	ELSE 'n/a'
END AS gen
FROM Bronze.erp_cust_az12

