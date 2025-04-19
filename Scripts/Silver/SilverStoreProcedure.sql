--Creating a stored procedure
CREATE OR ALTER PROCEDURE Silver.load_Silver AS 
BEGIN
	
	-- Declare the variables for time duration
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME; 

	BEGIN TRY 
		SET @batch_start_time = GETDATE()
		PRINT '============================================================'
		PRINT 'Cleaning and Inserting Data to CRM  Silver Tables '
		PRINT '============================================================'

		-- Table 1
		SET @start_time = GETDATE()
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
		SET @end_time = GETDATE()
		PRINT '<< Load Duration: '+ CAST (DATEDIFF(second,@start_time,@end_time) AS NVARCHAR)+ ' seconds' ;
		PRINT '***************'

		-- Table 2
		SET @start_time = GETDATE()
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
		SET @end_time = GETDATE()
		PRINT '<< Load Duration: '+ CAST (DATEDIFF(second,@start_time,@end_time) AS NVARCHAR)+ ' seconds' ;
		PRINT '***************'

		-- Table 3
		SET @start_time = GETDATE()
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
			WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quant * ABS(sls_price)
				THEN sls_quant * ABS(sls_price)
		END AS sls_sales,
		sls_quant,
		CASE 
			WHEN sls_price IS NULL OR sls_price <= 0 THEN sls_sales/NULLIF(sls_quant, 0)
			ELSE sls_price
		END AS sls_price
		FROM Bronze.crm_sales_details
		SET @end_time = GETDATE()
		PRINT '<< Load Duration: '+ CAST (DATEDIFF(second,@start_time,@end_time) AS NVARCHAR)+ ' seconds' ;
		PRINT '***************'

		PRINT '============================================================'
		PRINT 'Cleaning and Inserting Data to ERP Silver Tables '
		PRINT '============================================================'

		-- Table 4
		SET @start_time = GETDATE()
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
		SET @end_time = GETDATE()
		PRINT '<< Load Duration: '+ CAST (DATEDIFF(second,@start_time,@end_time) AS NVARCHAR)+ ' seconds' ;
		PRINT '***************'


		-- Table 5
		SET @start_time = GETDATE()
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
		SET @end_time = GETDATE()
		PRINT '<< Load Duration: '+ CAST (DATEDIFF(second,@start_time,@end_time) AS NVARCHAR)+ ' seconds' ;
		PRINT '***************'

		-- Table 6
		SET @start_time = GETDATE()
		PRINT 'Truncating Table: Silver.erp_px_cat_g1v2'
		TRUNCATE TABLE Silver.erp_px_cat_g1v2

		PRINT 'Inserting Into Table: Silver.erp_px_cat_g1v2'
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
		SET @end_time = GETDATE()
		PRINT '<< Load Duration: '+ CAST (DATEDIFF(second,@start_time,@end_time) AS NVARCHAR)+ ' seconds' ;
		PRINT '***************'

		PRINT '========================================================';
		PRINT 'Loading Silver Layer is Completed.'
		PRINT '========================================================';
		PRINT 'Total Batch Duration: '+ CAST (DATEDIFF(second,@batch_start_time,@batch_end_time) AS NVARCHAR) + ' seconds' ;
	END TRY
	BEGIN CATCH
		PRINT '========================================================';
		PRINT 'ERROR OCCURED DURING LOADING SILVER LAYER';
		PRINT 'ERROR MESSAGE: '+ ERROR_MESSAGE();
		PRINT 'ERROR MESSAGE: '+ CAST (ERROR_NUMBER() AS NVARCHAR);
		PRINT 'ERROR STATE: '+ ERROR_STATE();
		PRINT '========================================================';
	END CATCH
END 
