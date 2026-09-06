--check the duplicate cst_id (Primary Key)
select cst_id, count(*) from bronze.crm_cust_info
group by cst_id
having count(*)>1 or cst_id is null;

--identify the valid primary key among duplicates
select * from (select *, 
ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag_last
from bronze.crm_cust_info) where flag_last =1 ;

--check unwanted spaces
select cst_firstname
from bronze.crm_cust_info
where cst_firstname !=TRIM(cst_firstname);

--check unwanted spaces
select cst_lastname
from bronze.crm_cust_info
where cst_lastname !=TRIM(cst_lastname);

select cst_gndr
from bronze.crm_cust_info
where cst_gndr !=TRIM(cst_gndr);

--check the distinct gender category
select distinct cst_gndr
from bronze.crm_cust_info;

--check the distinct gender category
select distinct cst_material_status
from bronze.crm_cust_info;

--check the duplicate prd_id (Primary Key)
select prd_id, count(*) from bronze.crm_prd_info
group by prd_id
having count(*)>1 or prd_id is null;

--check for unwanted space
select prd_nm
from bronze.crm_prd_info
where prd_nm !=trim(prd_nm)

--check data consistency: sales, quantity, and price
--sales=quantity*price
--value must not be null zero or negetive
select distinct sls_sales,
sls_quantity,
sls_price 
from bronze.crm_sales_details
where sls_sales !=sls_quantity*sls_price
or sls_sales is null or sls_quantity is null or sls_price is null
or sls_sales<=0 or sls_quantity<=0 or sls_price<=0;
--rules:
--if sales is nehetive, zero or null, derive it using quantity and price
--if price is zero or null, calculate it using sales and quantity
--if price is negetive, convert it to a posiive number
