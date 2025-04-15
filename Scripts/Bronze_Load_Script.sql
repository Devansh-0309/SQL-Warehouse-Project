/*
--------------------------------------------------------------
Write Load Scripts
--------------------------------------------------------------

Purpose of Script
	This script is used to load the data to the database 'DataWarehouse' 
	We used the BULK INSERT method to acheive this.
	Also, We added some parameters like FIRSTROW, FIELDTERMINATOR
	This script also creates a stored procedure for the query

Steps 
	1. Truncate the table first
	2. Insert the data using bulk inset

Warning
	This script truncate the whole table at first and adds new data.
	Be careful with the data and take a backup before running it.
*/

CREATE OR ALTER PROCEDURE Bronze.load_Bronze AS 
BEGIN

PRINT '========================================================';
PRINT 'LOADING CRM TABLES';
PRINT '========================================================';

	-- Table 1
	PRINT '<< Truncating Table: Bronze.crm_cust_info';
	TRUNCATE TABLE Bronze.crm_cust_info;

	PRINT '<< Inserting Into: Bronze.crm_cust_info';
	BULK INSERT Bronze.crm_cust_info
	FROM 'C:\Users\Admin\Desktop\Placement\SQL Project\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
	WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
	);

	-- Table 2
	PRINT '<< Truncating Table: Bronze.crm_prd_info';
	TRUNCATE TABLE Bronze.crm_prd_info;

	PRINT '<< Inserting Into: Bronze.crm_prd_info';
	BULK INSERT Bronze.crm_prd_info
	FROM 'C:\Users\Admin\Desktop\Placement\SQL Project\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
	WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
	);

	-- Table 3
	PRINT '<< Truncating Table: Bronze.crm_sales_details';
	TRUNCATE TABLE Bronze.crm_sales_details;

	PRINT '<< Inserting Into: Bronze.crm_sales_details';
	BULK INSERT Bronze.crm_sales_details
	FROM 'C:\Users\Admin\Desktop\Placement\SQL Project\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
	WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
	);

PRINT '========================================================';
PRINT 'LOADING ERP TABLES';
PRINT '========================================================';

	-- Table 4
	PRINT '<< Truncating Table: Bronze.erp_cust_az12';
	TRUNCATE TABLE Bronze.erp_cust_az12;

	PRINT '<< Inserting Into: Bronze.erp_cust_az12';
	BULK INSERT Bronze.erp_cust_az12
	FROM 'C:\Users\Admin\Desktop\Placement\SQL Project\sql-data-warehouse-project\datasets\source_erp\cust_az12.csv'
	WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
	);

	-- Table 5
	PRINT '<< Truncating Table: Bronze.erp_loc_a101';
	TRUNCATE TABLE Bronze.erp_loc_a101;

	PRINT '<< Inserting Into: Bronze.erp_loc_a101s';
	BULK INSERT Bronze.erp_loc_a101
	FROM 'C:\Users\Admin\Desktop\Placement\SQL Project\sql-data-warehouse-project\datasets\source_erp\loc_a101.csv'
	WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
	);

	-- Table 6
	PRINT '<< Truncating Table: Bronze.erp_px_cat_g1v2';
	TRUNCATE TABLE Bronze.erp_px_cat_g1v2;

	PRINT '<< Inserting Into: Bronze.erp_px_cat_g1v2';
	BULK INSERT Bronze.erp_px_cat_g1v2
	FROM 'C:\Users\Admin\Desktop\Placement\SQL Project\sql-data-warehouse-project\datasets\source_erp\px_cat_g1v2.csv'
	WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
	);
END
