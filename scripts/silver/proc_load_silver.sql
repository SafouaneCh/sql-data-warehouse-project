DELIMITER $$

CREATE PROCEDURE load_silver_layer()
BEGIN
    -- Declare variables for error handling
    DECLARE exit handler for sqlexception
    BEGIN
        -- Rollback the transaction on error
        ROLLBACK;
        -- Log or signal the error
        SELECT 'Error occurred during silver layer load. Transaction rolled back.' AS error_message;
    END;
    
    -- Start transaction
    START TRANSACTION;
    
    -- Log start time
    SELECT CONCAT('Silver layer load started at: ', NOW()) AS log_message;
    
    -- 1. Load crm_prd_info
    SELECT 'Loading crm_prd_info...' AS log_message;
    
    TRUNCATE TABLE datawarehouse_silver.crm_prd_info;
    
    INSERT INTO datawarehouse_silver.crm_prd_info (
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
        REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id,
        SUBSTRING(prd_key, 7, LENGTH(prd_key)) AS prd_key,
        prd_nm,
        prd_cost,
        CASE
            WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'
            WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
            WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Other Sales'
            WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'Touring'
            ELSE 'n/a'
        END AS prd_line,
        prd_start_dt,
        DATE_SUB(
            LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt),
            INTERVAL 1 DAY
        ) AS prd_end_dt
    FROM datawarehouse_bronze.crm_prd_info;
    
    SELECT CONCAT('crm_prd_info loaded: ', ROW_COUNT(), ' rows') AS log_message;
    
    -- 2. Load crm_sales_details
    SELECT 'Loading crm_sales_details...' AS log_message;
    
    TRUNCATE TABLE datawarehouse_silver.crm_sales_details;
    
    INSERT INTO datawarehouse_silver.crm_sales_details (
        sls_ord_num,
        sls_prd_key,
        sls_cust_id,
        sls_order_dt,
        sls_ship_dt,
        sls_due_dt,
        sls_sales,
        sls_quantity,
        sls_price
    )
    SELECT *
    FROM (
        SELECT 
            sls_ord_num,
            sls_prd_key,
            sls_cust_id,
            CASE
                WHEN sls_order_dt = 0 OR LENGTH(sls_order_dt) != 8 THEN NULL
                ELSE STR_TO_DATE(CAST(sls_order_dt AS CHAR), '%Y%m%d')
            END AS sls_order_dt,
            CASE
                WHEN sls_ship_dt = 0 OR LENGTH(sls_ship_dt) != 8 THEN NULL
                ELSE STR_TO_DATE(CAST(sls_ship_dt AS CHAR), '%Y%m%d')
            END AS sls_ship_dt,
            CASE
                WHEN sls_due_dt = 0 OR LENGTH(sls_due_dt) != 8 THEN NULL
                ELSE STR_TO_DATE(CAST(sls_due_dt AS CHAR), '%Y%m%d')
            END AS sls_due_dt,
            CASE
                WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * ABS(sls_price)
                THEN sls_quantity * ABS(sls_price)
                ELSE sls_sales
            END AS sls_sales,
            CASE
                WHEN sls_price IS NULL OR sls_price <= 0 THEN sls_sales / NULLIF(sls_quantity, 0)
                ELSE sls_price
            END AS sls_price,
            sls_quantity
        FROM datawarehouse_bronze.crm_sales_details
        WHERE sls_ord_num IS NOT NULL
    ) AS src;
    
    SELECT CONCAT('crm_sales_details loaded: ', ROW_COUNT(), ' rows') AS log_message;
    
    -- 3. Load erp_cust_az12
    SELECT 'Loading erp_cust_az12...' AS log_message;
    
    TRUNCATE TABLE datawarehouse_silver.erp_cust_az12;
    
    INSERT INTO datawarehouse_silver.erp_cust_az12 (cid, bdate, gen)
    SELECT
        CASE
            WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4)
            ELSE cid
        END AS cid,
        CASE
            WHEN bdate > CURDATE() THEN NULL
            ELSE bdate
        END AS bdate,
        CASE
            WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
            WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
            ELSE 'n/a'
        END AS gen
    FROM datawarehouse_bronze.erp_cust_az12;
    
    SELECT CONCAT('erp_cust_az12 loaded: ', ROW_COUNT(), ' rows') AS log_message;
    
    -- 4. Load erp_loc_a101
    SELECT 'Loading erp_loc_a101...' AS log_message;
    
    TRUNCATE TABLE datawarehouse_silver.erp_loc_a101;
    
    INSERT INTO datawarehouse_silver.erp_loc_a101 (cid, loc_cntry)
    SELECT
        REPLACE(cid, '-', '') AS cid,
        CASE
            WHEN TRIM(loc_cntry) = 'DE' THEN 'Germany'
            WHEN TRIM(loc_cntry) IN ('US', 'USA') THEN 'United States'
            WHEN TRIM(loc_cntry) = '' OR loc_cntry IS NULL THEN 'n/a'
            ELSE TRIM(loc_cntry)
        END AS loc_cntry
    FROM datawarehouse_bronze.erp_loc_a101;
    
    SELECT CONCAT('erp_loc_a101 loaded: ', ROW_COUNT(), ' rows') AS log_message;
    
    -- Commit transaction
    COMMIT;
    
    -- Log completion
    SELECT CONCAT('Silver layer load completed successfully at: ', NOW()) AS log_message;
    
END$$

DELIMITER ;
