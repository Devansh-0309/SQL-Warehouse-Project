/*
==============================================================
Cleaning the data of Bronze.erp_px_cat_g1v2
==============================================================

Purpose of the Script
	This Piece of code cleans the table 

NOTE: This table had no dirty data that needed to be cleaned. Therefore it can be inserted as it is

	Then this script inserts the cleaned data to the table in the silver layer
*/
-- Inserting data into silver layer table
INSERT INTO Silver.erp_px_cat_g1v2(
id,
cat,
subcat,
maintenance
)

SELECT
id,
cat,
subcat,
maintenance
FROM Bronze.erp_px_cat_g1v2
