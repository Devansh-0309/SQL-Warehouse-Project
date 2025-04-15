/*
---------------------------------------------------------------
Create Tables For Bronze Layer
---------------------------------------------------------------

Purpose of Script:
	This script creates tables for the bronze layer
	All the column names and datatypes in the tables are matched to the provided in the datasets
	The naming convention throughout the script has been strictly followed

Warning:
	This script creates the tables only for the bronze layer so make sure to have it predefined in your system.
*/

-- Creating the tables for Bronze Layer

-- Table 1 
CREATE TABLE bronze.crm_customer_info(
	cst_id INT,
	cst_key NVARCHAR(30),
	cst_firstname NVARCHAR(30),
	cst_lastname NVARCHAR(30),
	cst_marital_status NVARCHAR(30),
	cst_gndr NVARCHAR(8),
	cst_create_date DATE
);

-- Table  2
CREATE TABLE bronze.crm_prd_info(
	prd_id INT,
	prd_key NVARCHAR(30),
	prd_nm NVARCHAR(30),
	prd_cost INT,
	prd_line NVARCHAR(30),
	prd_start_dt DATETIME,
	prd_end_dt DATETIME
);

-- Table 3
CREATE TABLE bronze.crm_sales_details(
	sls_ord_num NVARCHAR(30),
	sls_prd_key NVARCHAR(30),
	sls_cust_id INT,
	sls_order_dt INT,
	sls_ship_dt INT,
	sls_due_dt INT,
	sls_sales INT,
	sls_quant INT,
	sls_price INT
);

-- Table 4
CREATE TABLE bronze.erp_cust_az12(
	cid NVARCHAR(30),
	bdate DATE,
	gen NVARCHAR(30)
);

-- Table 5
CREATE TABLE bronze.erp_loc_a101(
	cid NVARCHAR(30),
	cntry NVARCHAR(30)
);
 
-- Table 6
CREATE TABLE bronze.erp_px_cat_g1v2(
	id NVARCHAR(30),
	cat NVARCHAR(30),
	subcat NVARCHAR(30),
	maintenance NVARCHAR(30)
);

