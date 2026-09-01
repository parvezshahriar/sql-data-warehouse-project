CREATE OR REPLACE PROCEDURE bronze.load_bronze()
LANGUAGE plpgsql
AS $$
DECLARE
    start_time TIMESTAMP;
    end_time TIMESTAMP;
BEGIN

    start_time := clock_timestamp();
    RAISE NOTICE 'Loading bronze.crm_cust_info...';
    TRUNCATE TABLE bronze.crm_cust_info;
    COPY bronze.crm_cust_info
    FROM 'C:/datasets/source_crm/cust_info.csv'
    WITH (
        FORMAT CSV,
        HEADER TRUE,
        DELIMITER ','
    );
    end_time := clock_timestamp();
    RAISE NOTICE 'Load Time: % seconds',
        EXTRACT(EPOCH FROM (end_time - start_time));
    RAISE NOTICE '.................................';


    start_time := clock_timestamp();
    RAISE NOTICE 'Loading bronze.crm_prd_info...';
    TRUNCATE TABLE bronze.crm_prd_info;
    COPY bronze.crm_prd_info
    FROM 'C:/datasets/source_crm/prd_info.csv'
    WITH (
        FORMAT CSV,
        HEADER TRUE,
        DELIMITER ','
    );
    end_time := clock_timestamp();
    RAISE NOTICE 'Load Time: % seconds',
        EXTRACT(EPOCH FROM (end_time - start_time));
    RAISE NOTICE '.................................';


    start_time := clock_timestamp();
    RAISE NOTICE 'Loading bronze.crm_sales_details...';
    TRUNCATE TABLE bronze.crm_sales_details;
    COPY bronze.crm_sales_details
    FROM 'C:/datasets/source_crm/sales_details.csv'
    WITH (
        FORMAT CSV,
        HEADER TRUE,
        DELIMITER ','
    );
    end_time := clock_timestamp();
    RAISE NOTICE 'Load Time: % seconds',
        EXTRACT(EPOCH FROM (end_time - start_time));
    RAISE NOTICE '.................................';


    start_time := clock_timestamp();
    RAISE NOTICE 'Loading bronze.erp_cust_az12...';
    TRUNCATE TABLE bronze.erp_cust_az12;
    COPY bronze.erp_cust_az12
    FROM 'C:/datasets/source_erp/CUST_AZ12.csv'
    WITH (
        FORMAT CSV,
        HEADER TRUE,
        DELIMITER ','
    );
    end_time := clock_timestamp();
    RAISE NOTICE 'Load Time: % seconds',
        EXTRACT(EPOCH FROM (end_time - start_time));
    RAISE NOTICE '.................................';


    start_time := clock_timestamp();
    RAISE NOTICE 'Loading bronze.erp_loc_a101...';
    TRUNCATE TABLE bronze.erp_loc_a101;
    COPY bronze.erp_loc_a101
    FROM 'C:/datasets/source_erp/LOC_A101.csv'
    WITH (
        FORMAT CSV,
        HEADER TRUE,
        DELIMITER ','
    );
    end_time := clock_timestamp();
    RAISE NOTICE 'Load Time: % seconds',
        EXTRACT(EPOCH FROM (end_time - start_time));
    RAISE NOTICE '.................................';


    start_time := clock_timestamp();
    RAISE NOTICE 'Loading bronze.erp_px_cat_g1v2...';
    TRUNCATE TABLE bronze.erp_px_cat_g1v2;
    COPY bronze.erp_px_cat_g1v2
    FROM 'C:/datasets/source_erp/PX_CAT_G1V2.csv'
    WITH (
        FORMAT CSV,
        HEADER TRUE,
        DELIMITER ','
    );
    end_time := clock_timestamp();
    RAISE NOTICE 'Load Time: % seconds',
        EXTRACT(EPOCH FROM (end_time - start_time));
    RAISE NOTICE '.................................';
    RAISE NOTICE 'BRONZE LAYER LOADED SUCCESSFULLY';

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE '..............................................';
        RAISE NOTICE 'ERROR OCCURRED DURING LOADING BRONZE LAYER';
        RAISE NOTICE 'Error Message: %', SQLERRM;
        RAISE NOTICE 'SQLSTATE: %', SQLSTATE;
        RAISE;

END;
$$;
