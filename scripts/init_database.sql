/*
---------------------------------------------
create database and schemas
---------------------------------------------
script purpose:
	This script creates a new database named 'datawarehouse' after checking if it already exists.
	If the database exists, it is dropped and received.Additionally, the script settss up three schemas
	within the daatabase:'bronze' , 'silver' , 'gold'.
warning:
	Running this script will drop the entire 'Datawarehouse' database if it exists.
	All data in the database will be permanently deleted. proceed with caution
	and ensure you have proper backups before running this script,
 */

use master;
go

if exists ( select 1 from sys.databases where name = 'Datawarehouse')
begin
	alter database Datawarehouse Set single_user with rollback immediate;
	drop database Datawarehouse;
end;
go 
-- creating database warehouse
create Database Datawarehouse;
go

Use datawarehouse;
go 

--creating schemas
create schema bronze;
go

create schema silver;
go

create schema gold;
go



