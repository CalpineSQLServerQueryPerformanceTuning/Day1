use AdventureWorks;
go


-- Turn on Actual Execution Plan (Ctrl-M)


-- Stream Aggregate (Aggregate)
--		Index:	[AdventureWorks].[Production].[Product].[PK_Product_ProductID]

--		Note:	Click on Compute Scalar and Stream Aggregate Operators 
--				and view Defined Values in the Properties Window
select avg(ListPrice) 
from Production.Product;

--		Note:	Or view Defined Values info using Text Execution Plan
set showplan_text on
go

select avg(ListPrice) 
from Production.Product;
go

set showplan_text off
go


-- Stream Aggregate (Aggregate)
--		Index:	[AdventureWorks].[Production].[Product].[PK_Product_ProductID]
--		Note:	Sort now required since Stream Aggregate requires 
--				sorting by group
select ProductLine, avg(ListPrice) 
from Production.Product 
group by ProductLine;


-- Stream Aggregate (Aggregate)
--		Index:	[AdventureWorks].[Sales].[SalesOrderDetail].
--				[PK_SalesOrderDetail_SalesOrderID_SalesOrderDetailID]
--		Note:	Data is Pre-Sorted (SalesOrderID is part of composite PK)
select SalesOrderID, avg(OrderQty) 
from Sales.SalesOrderDetail 
group by SalesOrderID;


-- Hash Match (Aggregate)
--		Index:	[AdventureWorks].[Sales].[SalesOrderHeader].
--				[PK_SalesOrderHeader_SalesOrderID]
--		Note:	The Query Optimizer can select a Hash Aggregate for big tables 
--				where the data is not sorted, there is no need to sort it, and 
--				its cardinality estimates only a few groups.
--		Note:	In Hash Match Operator, view Hash Keys Build Property
select TerritoryID, count(*) 
from Sales.SalesOrderHeader
group by TerritoryID;

--		Note:	10 Groups from previous query, so only 10 entries in the hash table
--				And this query shows 31,465 rows in table (so big table is not so big)
select count(*) from Sales.SalesOrderHeader;


-- Hash Match (Aggregate)
--		Note: Sort because of order by clause
select TerritoryID, count(*) 
from Sales.SalesOrderHeader 
group by TerritoryID 
order by TerritoryID;


-- Stream Aggregate vs Hash Aggregate forced with query hint
--		Note: Compare both Execution Plans to one another
select ProductLine, avg(ListPrice) 
from Production.Product 
group by ProductLine;

select ProductLine, avg(ListPrice) 
from Production.Product 
group by ProductLine
option (hash group);


-- Hash Aggregate vs Stream Aggregate forced with query hint
--		Note: Compare both Execution Plans to one another
select TerritoryID, count(*) 
from Sales.SalesOrderHeader 
group by TerritoryID;

select TerritoryID, count(*) 
from Sales.SalesOrderHeader 
group by TerritoryID
option(order group);


-- Distinct Sort
--		Note:	Indentical Execution Plans
select distinct JobTitle
from HumanResources.Employee;

select JobTitle
from HumanResources.Employee 
group by JobTitle;


-- Stream Aggregate used because Non-Clustered index pre-sorts
--		Note:	View Stream Aggregate Group By Property
create index IX_JobTitle on HumanResources.Employee(JobTitle);

select distinct JobTitle 
from HumanResources.Employee;

drop index HumanResources.Employee.IX_JobTitle;


-- Hash Aggregate may be used for bigger tables
select distinct TerritoryID 
from Sales.SalesOrderHeader;
