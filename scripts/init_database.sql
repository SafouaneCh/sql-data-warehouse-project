/*
=============================================================
MySQL Data Warehouse Initialization Script
=============================================================
Purpose:
    This script initializes a MySQL-based Data Warehouse environment.

    It performs the following actions:
      1. Drops the main "DataWarehouse" database if it already exists.
      2. Recreates "DataWarehouse".
      3. Creates separate databases to represent data layers:
            - DataWarehouse_bronze
            - DataWarehouse_silver
            - DataWarehouse_gold

Notes:
    - MySQL does NOT support schemas inside a database (unlike SQL Server).
      Therefore, bronze/silver/gold layers are implemented as separate databases.

WARNING:
    Running this script will permanently delete any existing DataWarehouse*
    databases. Ensure you have backups before executing.
=============================================================
*/

-- Drop main database if exists
DROP DATABASE IF EXISTS DataWarehouse;

-- Create main database
CREATE DATABASE DataWarehouse;

-- Select main database
USE DataWarehouse;

-- Create layer databases
DROP DATABASE IF EXISTS DataWarehouse_bronze;
DROP DATABASE IF EXISTS DataWarehouse_silver;
DROP DATABASE IF EXISTS DataWarehouse_gold;

CREATE DATABASE DataWarehouse_bronze;
CREATE DATABASE DataWarehouse_silver;
CREATE DATABASE DataWarehouse_gold;
