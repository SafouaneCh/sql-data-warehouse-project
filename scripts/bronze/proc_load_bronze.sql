SET GLOBAL local_infile = 1;

/*
===============================================================================
Script: Load Bronze Layer (Source -> Bronze)
===============================================================================
Script Purpose:
    This script loads data into the bronze tables from external CSV files. 
    It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses the `LOAD DATA LOCAL INFILE` command to load data from csv Files to bronze tables.

⚠️ IMPORTANT NOTES:
    - This script will TRUNCATE (delete all data from) bronze tables before loading.
    - The data in the bronze database tables will be replaced.
    - If you have important data in bronze tables, back them up first.

Usage:
    Before running, enable local_infile:
    SET GLOBAL local_infile = 1;
    
    Execute this script in MySQL Workbench or via command line:
    mysql -u username -p --local-infile=1 datawarehouse_bronze < load_bronze.sql
===============================================================================
*/

USE datawarehouse_bronze;

SET @batch_start_time = NOW();
SELECT '================================================' AS '';
SELECT 'Loading Bronze Layer' AS '';
SELECT '================================================' AS '';

-- Loading CRM Tables
SELECT '------------------------------------------------' AS '';
SELECT 'Loading CRM Tables' AS '';
SELECT '------------------------------------------------' AS '';

-- Load crm_cust_info
SET @start_time = NOW();
SELECT '>> Truncating Table: crm_cust_info' AS '';
TRUNCATE TABLE crm_cust_info;

SELECT '>> Inserting Data Into: crm_cust_info' AS '';
LOAD DATA LOCAL INFILE 'C:/Users/dell/OneDrive/Bureau/sql-data-warehouse-project/datasets/source_crm/cust_info.csv'
INTO TABLE crm_cust_info
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

SET @end_time = NOW();
SELECT CONCAT('>> Rows Loaded: ', ROW_COUNT()) AS '';
SELECT CONCAT('>> Load Duration: ', TIMESTAMPDIFF(SECOND, @start_time, @end_time), ' seconds') AS '';
SELECT '>> -------------' AS '';

-- Load crm_prd_info
SET @start_time = NOW();
SELECT '>> Truncating Table: crm_prd_info' AS '';
TRUNCATE TABLE crm_prd_info;

SELECT '>> Inserting Data Into: crm_prd_info' AS '';
LOAD DATA LOCAL INFILE 'C:/Users/dell/OneDrive/Bureau/sql-data-warehouse-project/datasets/source_crm/prd_info.csv'
INTO TABLE crm_prd_info
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

SET @end_time = NOW();
SELECT CONCAT('>> Rows Loaded: ', ROW_COUNT()) AS '';
SELECT CONCAT('>> Load Duration: ', TIMESTAMPDIFF(SECOND, @start_time, @end_time), ' seconds') AS '';
SELECT '>> -------------' AS '';

-- Load crm_sales_details
SET @start_time = NOW();
SELECT '>> Truncating Table: crm_sales_details' AS '';
TRUNCATE TABLE crm_sales_details;

SELECT '>> Inserting Data Into: crm_sales_details' AS '';
LOAD DATA LOCAL INFILE 'C:/Users/dell/OneDrive/Bureau/sql-data-warehouse-project/datasets/source_crm/sales_details.csv'
INTO TABLE crm_sales_details
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

SET @end_time = NOW();
SELECT CONCAT('>> Rows Loaded: ', ROW_COUNT()) AS '';
SELECT CONCAT('>> Load Duration: ', TIMESTAMPDIFF(SECOND, @start_time, @end_time), ' seconds') AS '';
SELECT '>> -------------' AS '';

-- Loading ERP Tables
SELECT '------------------------------------------------' AS '';
SELECT 'Loading ERP Tables' AS '';
SELECT '------------------------------------------------' AS '';

-- Load erp_cust_az12
SET @start_time = NOW();
SELECT '>> Truncating Table: erp_cust_az12' AS '';
TRUNCATE TABLE erp_cust_az12;

SELECT '>> Inserting Data Into: erp_cust_az12' AS '';
LOAD DATA LOCAL INFILE 'C:/Users/dell/OneDrive/Bureau/sql-data-warehouse-project/datasets/source_erp/CUST_AZ12.csv'
INTO TABLE erp_cust_az12
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

SET @end_time = NOW();
SELECT CONCAT('>> Rows Loaded: ', ROW_COUNT()) AS '';
SELECT CONCAT('>> Load Duration: ', TIMESTAMPDIFF(SECOND, @start_time, @end_time), ' seconds') AS '';
SELECT '>> -------------' AS '';

-- Load erp_loc_a101
SET @start_time = NOW();
SELECT '>> Truncating Table: erp_loc_a101' AS '';
TRUNCATE TABLE erp_loc_a101;

SELECT '>> Inserting Data Into: erp_loc_a101' AS '';
LOAD DATA LOCAL INFILE 'C:/Users/dell/OneDrive/Bureau/sql-data-warehouse-project/datasets/source_erp/LOC_A101.csv'
INTO TABLE erp_loc_a101
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

SET @end_time = NOW();
SELECT CONCAT('>> Rows Loaded: ', ROW_COUNT()) AS '';
SELECT CONCAT('>> Load Duration: ', TIMESTAMPDIFF(SECOND, @start_time, @end_time), ' seconds') AS '';
SELECT '>> -------------' AS '';

-- Load erp_px_cat_g1v2
SET @start_time = NOW();
SELECT '>> Truncating Table: erp_px_cat_g1v2' AS '';
TRUNCATE TABLE erp_px_cat_g1v2;

SELECT '>> Inserting Data Into: erp_px_cat_g1v2' AS '';
LOAD DATA LOCAL INFILE 'C:/Users/dell/OneDrive/Bureau/sql-data-warehouse-project/datasets/source_erp/PX_CAT_G1V2.csv'
INTO TABLE erp_px_cat_g1v2
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

SET @end_time = NOW();
SELECT CONCAT('>> Rows Loaded: ', ROW_COUNT()) AS '';
SELECT CONCAT('>> Load Duration: ', TIMESTAMPDIFF(SECOND, @start_time, @end_time), ' seconds') AS '';
SELECT '>> -------------' AS '';

-- Completion
SET @batch_end_time = NOW();
SELECT '==========================================' AS '';
SELECT 'Loading Bronze Layer is Completed' AS '';
SELECT CONCAT('   - Total Load Duration: ', TIMESTAMPDIFF(SECOND, @batch_start_time, @batch_end_time), ' seconds') AS '';
SELECT '==========================================' AS '';
