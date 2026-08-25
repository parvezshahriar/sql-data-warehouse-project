/*
==============================================================================
Create databae and schemas
==============================================================================

Script Purpose:
 This script created as a new database named 'DataWarehouse' after checking if it already exist. If the database exist, it is dropped and recreated. Additionally. the script
 set up these schemas within the database: 'bronze','silver', and 'gold'.

WARNING: Running the sript will permanently drop the entire 'DataWarehouse' database if exist. All data in the database will be permanently deleted. Proceed with causion and 
ensure you have proper backup before running the script.

*/
--Drop database if its already created
DROP DATABASE IF EXISTS "DataWarehouse" WITH (FORCE);
--Create a database
CREATE DATABASE "DataWarehouse";
--create schemas for data warehouse
CREATE SCHEMA IF NOT EXISTS bronze;
CREATE SCHEMA IF NOT EXISTS silver;
CREATE SCHEMA IF NOT EXISTS gold;
