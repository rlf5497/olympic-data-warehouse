/* =============================================================================
	File: init_database.sql

	Project: Olympic Data Warehouse
	Environment: PostgreSQL

	Purpose:
		- Initialize the Olympic Data Warehouse database
		- Create schemas for all data layers following Medallion Architecture
			(bronze -> silver -> gold -> gold_bi)

	Execution Notes:
		- This script should be executed by a superuser or a role with:
			* CREATEDB privileges
			* CREATE privileges on the target database
		- DROP DATABASE is destructive - use only in local/dev environments

	Layer Responsibilities:
		bronze 	-> Raw ingested data (as-is from source files)
		silver 	-> Cleaned, standardized, conformed data
		gold 	-> Star Schema (fact & dimension tables)
		gold_bi	-> Business-facing semantic views for BI tools (e.g., Tableau)

============================================================================= */



------------------------------------------------------------
-- DATABASE INITIALIZATION
------------------------------------------------------------

-- Drop the database if it already exists (DEV / LOCAL ONLY)
DROP DATABASE IF EXISTS olympic_data_warehouse;

-- Create the Olympic Data Warehouse database
CREATE DATABASE olympic_data_warehouse;



------------------------------------------------------------
-- SCHEMA INITIALIZATION 
-- (Run AFTER connecting to olympic_data_warehouse)
------------------------------------------------------------

-- Raw ingestion layer (CSV, source extracts, minimal validation)
CREATE SCHEMA IF NOT EXISTS bronze;

-- Cleansed and standardized layer
CREATE SCHEMA IF NOT EXISTS silver;

-- Curated analytical layer (facts & dimension / star schema)
CREATE SCHEMA IF NOT EXISTS gold;

-- Business Intelligence semantic layer (read-only views)
CREATE SCHEMA IF NOT EXISTS gold_bi;
