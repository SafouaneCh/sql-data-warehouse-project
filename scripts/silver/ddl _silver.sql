/*
===============================================================================
Script: Create Silver Layer Tables - DDL
===============================================================================
Script Purpose:
    This script creates all tables in the silver layer (datawarehouse_silver).
    These tables will store cleaned and transformed data from bronze layer.

⚠️ IMPORTANT NOTES:
    - Run this script BEFORE loading data with load_silver.sql
    - This script will DROP existing silver tables if they exist
    - Table structures match your bronze layer data structure

Usage:
    Execute this script in MySQL Workbench or via command line:
    mysql -u username -p datawarehouse_silver < create_silver_tables.sql
===============================================================================
*/

-- Create database if not exists
CREATE DATABASE IF NOT EXISTS datawarehouse_silver;

USE datawarehouse_silver;

-- Drop tables if they exist
DROP TABLE IF EXISTS crm_cust_info;
DROP TABLE IF EXISTS crm_prd_info;
DROP TABLE IF EXISTS crm_sales_details;
DROP TABLE IF EXISTS erp_cust_az12;
DROP TABLE IF EXISTS erp_loc_a101;
DROP TABLE IF EXISTS erp_px_cat_g1v2;

SELECT '================================================' AS '';
SELECT 'Creating Silver Layer Tables' AS '';
SELECT '================================================' AS '';

-- =============================================
-- CRM Tables
-- =============================================
SELECT '>> Creating CRM Tables...' AS '';

-- Table: crm_cust_info
CREATE TABLE crm_cust_info (
    cst_id INT,
    cst_key VARCHAR(50),
    cst_firstname VARCHAR(50),
    cst_lastname VARCHAR(50),
    cst_material_status VARCHAR(50),
    cst_gndr VARCHAR(50),
    cst_create_date DATE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

SELECT '   - crm_cust_info created' AS '';

-- Table: crm_prd_info
CREATE TABLE crm_prd_info (
    prd_id INT,
    prd_key VARCHAR(50),
    prd_nm VARCHAR(50),
    prd_cost INT,
    prd_line VARCHAR(50),
    prd_start_dt DATETIME,
    prd_end_dt DATETIME
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

SELECT '   - crm_prd_info created' AS '';

-- Table: crm_sales_details
CREATE TABLE crm_sales_details (
    sls_ord_num VARCHAR(50),
    sls_prd_key VARCHAR(50),
    sls_cust_id INT,
    sls_order_dt INT,
    sls_ship_dt INT,
    sls_due_dt INT,
    sls_sales INT,
    sls_quantity INT,
    sls_price INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

SELECT '   - crm_sales_details created' AS '';

-- =============================================
-- ERP Tables
-- =============================================
SELECT '>> Creating ERP Tables...' AS '';

-- Table: erp_cust_az12
CREATE TABLE erp_cust_az12 (
    cid VARCHAR(50),
    bdate DATE,
    gen VARCHAR(50)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

SELECT '   - erp_cust_az12 created' AS '';

-- Table: erp_loc_a101
CREATE TABLE erp_loc_a101 (
    cid VARCHAR(50),
    loc_cntry VARCHAR(50)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

SELECT '   - erp_loc_a101 created' AS '';

-- Table: erp_px_cat_g1v2
CREATE TABLE erp_px_cat_g1v2 (
    id VARCHAR(50),
    cat VARCHAR(50),
    subcat VARCHAR(50),
    maintenance VARCHAR(50)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

SELECT '   - erp_px_cat_g1v2 created' AS '';

-- =============================================
-- Verification
-- =============================================
SELECT '================================================' AS '';
SELECT 'Silver Layer Tables Created Successfully!' AS '';
SELECT '================================================' AS '';
SELECT 'Tables in datawarehouse_silver:' AS '';
SHOW TABLES;
