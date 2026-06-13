/*
--------------------------------------------------------------------------
stored procedure: Load bronze Layer (Source -> Bronze)
--------------------------------------------------------------------------
script procedure:
  This is stored procedure loads data into the 'bronze' schema from external CSV files.
  It performs the following actions:
  -Truncates the Bronze tables before loading data.
  -Uses the Block Insert command to load data from csv files to bronze tables.
parameters:
  None.
  This storeed procedure doees not accept any parameters or return any values.
Usage Example:
Exec bronze.load_bronze;
--------------------------------------------------------------------------
*/
create or alter procedure bronze.load_bronze as
begin
    declare @start_time datetime,@end_time datetime,@batch_start datetime,@batch_end datetime;
	begin try
		set @batch_start = getdate();
		print '============================';
		print 'Loading bronze layer';
		print '============================';

		print '----------------------------';
		print 'Loading CRM Files';
		print '----------------------------';

		set @start_time = getdate();
		print 'truncating table: bronze.crm_cust_info';
		truncate table bronze.crm_cust_info;
	
		print 'inserting data into: bronze.crm_cust_info';
		bulk insert bronze.crm_cust_info
		from 'C:\Users\Srija\Downloads\ALL PROJECTS\SQL\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		with (
		firstrow = 2,
		fieldterminator = ',',
		tablock
		);
		set @end_time = getdate();
		print '>> load duration: ' + cast(datediff(second,@start_time,@end_time) as nvarchar) + 'seconds';
		print '--------------------';

		set @start_time = getdate();
		print 'truncating table: bronze.crm_prd_info';
		truncate table bronze.crm_prd_info;

		print 'inserting data into: bronze.crm_prd_info';
		bulk insert bronze.crm_prd_info
		from 'C:\Users\Srija\Downloads\ALL PROJECTS\SQL\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		with (
		firstrow = 2,
		fieldterminator = ',',
		tablock
		);
		set @end_time = getdate();
		print '>> load duration: ' + cast(datediff(second,@start_time,@end_time) as nvarchar) + 'seconds';
		print '--------------------';

		set @start_time = getdate();
		print 'truncating table: bronze.crm_sales_details';
		truncate table bronze.crm_sales_details;

		print 'inserting data into: bronze.crm_sales_details'
		bulk insert bronze.crm_sales_details
		from 'C:\Users\Srija\Downloads\ALL PROJECTS\SQL\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		with (
		firstrow = 2,
		fieldterminator = ',',
		tablock
		);
		set @end_time = getdate();
		print '>> load duration: ' + cast(datediff(second,@start_time,@end_time) as nvarchar) + 'seconds';
		print '--------------------';

		print '----------------------------';
		print 'Loading ERP Files';
		print '----------------------------';

		set @start_time = getdate();
		print 'truncating table: bronze.erp_loc_a101';
		truncate table bronze.erp_loc_a101;

		print 'inserting data into: bronze.erp_loc_a101'
		bulk insert bronze.erp_loc_a101
		from 'C:\Users\Srija\Downloads\ALL PROJECTS\SQL\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\loc_a101.csv'
		with (
		firstrow = 2,
		fieldterminator = ',',
		tablock
		);
		set @end_time = getdate();
		print '>> load duration: ' + cast(datediff(second,@start_time,@end_time) as nvarchar) + 'seconds';
		print '--------------------';

		set @start_time = getdate();
		print 'truncating table: bronze.erp_cust_az12';
		truncate table bronze.erp_cust_az12;

		print 'inserting data into: bronze.erp_cust_az12'
		bulk insert bronze.erp_cust_az12
		from 'C:\Users\Srija\Downloads\ALL PROJECTS\SQL\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\cust_az12.csv'
		with (
		firstrow = 2,
		fieldterminator = ',',
		tablock
		);
		set @end_time = getdate();
		print '>> load duration: ' + cast(datediff(second,@start_time,@end_time) as nvarchar) + 'seconds';
		print '--------------------';

		set @start_time = getdate();
		print 'truncating table: bronze.erp_px_cat_g1v2';
		truncate table bronze.erp_px_cat_g1v2;

		print 'inserting data into: bronze.erp_px_cat_g1v2'
		bulk insert bronze.erp_px_cat_g1v2
		from 'C:\Users\Srija\Downloads\ALL PROJECTS\SQL\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\px_cat_g1v2.csv'
		with (
		firstrow = 2,
		fieldterminator = ',',
		tablock
		);
		set @end_time = getdate();
		print '>> load duration: ' + cast(datediff(second,@start_time,@end_time) as nvarchar) + 'seconds';
		print '--------------------';

		set @batch_end = getdate();
		print '===========================================================';
		print 'Loading bronze layer completed';
	    print ' >> whole batch time:' + cast(datediff(second,@batch_start,@batch_end) as nvarchar) + 'seconds';
	    print '===========================================================';
	end try
	begin catch
		print '============================================';
		print 'error occured during loading bronze layer'
		print 'error message' + error_message();
		print 'error message' + cast(error_number() as nvarchar);
		print 'error message' + cast(error_state() as nvarchar);
		print '=============================================';
	end catch
end;





