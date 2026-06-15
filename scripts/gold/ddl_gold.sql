/*
----------------------------------------------------------------------------
DDL script: Create Gold views
----------------------------------------------------------------------------
script purpose:
This script creates virews for the Gold Layer in the data warehouse.
The Gold Layer represents the final dimension and fact tables (star scheme)

Each view performs transformations and combines data  from the silver layer 
to produce a clean.enriched,and business ready datasset.
Usage:
-These views can be queried directly for analytics amd reporting.
----------------------------------------------------------------------------
*/
-----------------------------------------------------------------
-- create dimensions: gold.dim_customers
-----------------------------------------------------------------
IF OBJECT_ID('gold.dim_customers', 'V') IS NOT NULL
    DROP VIEW gold.dim_customers;
GO
create view gold.dim_customers as
select 
    row_number() over(order by cst_id) as customer_key,
	ci.cst_id as customer_id,
	ci.cst_key as customer_number,
	ci.cst_firstname as first_name,
	ci.cst_lastname as last_name,
	la.cntry as country,
	ci.cst_marital_status as marital_status,
	case when ci.cst_gndr != 'n/a' then ci.cst_gndr
	     else coalesce(ca.gen,'n/a')
    end as gender,
	ca.bdate as birth_date,
	ci.cst_create_date as create_date	
from silver.crm_cust_info  ci
left join silver.erp_cust_az12 ca
on ci.cst_key = ca.cid
left join silver.erp_loc_a101 la
on ci.cst_key = la.cid;
go 

-----------------------------------------------------------------
-- create dimensions: gold.dim_products
----------------------------------------------------------------- 
IF OBJECT_ID('gold.dim_products', 'V') IS NOT NULL
    DROP VIEW gold.dim_products;
GO
create view gold.dim_products as 
select
    row_number() over(order by pd.prd_start_dt,pd.prd_key) as product_key,
	pd.prd_id as product_id,
	pd.prd_key as product_number,
	pd.prd_nm as product_name,
	pd.cat_id as category_id,
	pc.cat as category,
	pc.subcat as subcategory,
	pc.maintenance,
	pd.prd_cost as cost,
	pd.prd_line as product_line,
	pd.prd_start_dt	as start_date
from silver.crm_prd_info as pd
left join silver.erp_px_cat_g1v2 pc
on pd.cat_id = pc.id
where pd.prd_end_dt is null;
go

-----------------------------------------------------------------
-- create fact: gold.fact_sales
-----------------------------------------------------------------  
IF OBJECT_ID('gold.fact_sales', 'V') IS NOT NULL
    DROP VIEW gold.fact_sales;
GO  
create view gold.fact_sales as
select
	sd.sls_ord_num as order_number,
	pr.product_key,
	cu.customer_key,
	sd.sls_order_dt as order_date,
	sd.sls_ship_dt as shipping_date,
	sd.sls_due_dt as due_date,
	sd.sls_sales as sales_amount,
	sd.sls_quantity as quantity,
	sd.sls_price as price
from silver.crm_sales_details as sd
left join gold.dim_products pr
on sd.sls_prd_key = pr.product_number
left join gold.dim_customers cu
on sd.sls_cust_id =  cu.customer_id;
go
