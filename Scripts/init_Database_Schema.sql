/*
--------------------------------------------------------------------
Create Database And Schemas
--------------------------------------------------------------------

Script Purpose:
	This Script checks for the existing database and drops it if found.
	Then this script create a new database 'DataWarehouse' and Schemas for each layer

Warning:
	This script drops the database at first and creates the databse again so be careful.
	Take a backup of the database if required
*/

USE master;
GO
-- Check if database exists already
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN
	ALTER DATABASE DataWarehouse SET SINGLE_USER ROLLBACK IMMEDIATE
	DROP DATABASE DataWarehouse
END;
GO


-- Creating database 'DataWarehouse'
CREATE DATABASE DataWarehouse;

-- Use newly created Database
USE DataWarehouse;
GO

-- Create Schemas For Each Layer
CREATE SCHEMA Bronze;
GO

CREATE SCHEMA Silver;
GO

CREATE SCHEMA Gold;
GO
