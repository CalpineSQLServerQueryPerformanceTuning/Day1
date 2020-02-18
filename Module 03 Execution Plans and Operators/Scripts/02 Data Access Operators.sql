use AdventureWorks;
go


-- Turn on Actual Execution Plan (Ctrl-M)


-- Table Scan
select * from DatabaseLog;


-- Clustered Index Scan
--		Index = [AdventureWorks].[Person].[Address].[PK_Address_AddressID]
--		Note:	Ordered Property on Clustered Index Operator 
--				(false on first query, true on second query)
--				Possible Execution Engine reads clustered 
--				index data non-sequentially for performance
select * from Person.[Address];
select * from Person.[Address] order by AddressID;		

exec sp_helpindex 'Person.[Address]';


-- Index Scan 
--		Index = [AdventureWorks].[Person].[Address].[IX_Address_StateProvinceID]
--		Note:	AddressID is not in index column list, but is
--				included since non-clustered index uses either
--				PK column or RowID to refer back to base table
select AddressID, StateProvinceID 
from Person.[Address];


-- Clustered Index Seek
--		Index = [AdventureWorks].[Person].[Address].[PK_Address_AddressID]
--		Note:	Does not use non-clustered index since it is not sorted by
--				the PK AddressID
select AddressID, StateProvinceID 
from Person.[Address] 
where AddressID = 12037;


-- Index Seek (1 row returned)
--		Index = [AdventureWorks].[Person].[Address].[IX_Address_StateProvinceID]
--		Note:	Covering index because AddressID is the PK 
select AddressID, StateProvinceID 
from Person.[Address]
where StateProvinceID = 32;


-- Index Seek (4,564 rows returned)
--		Index = [AdventureWorks].[Person].[Address].[IX_Address_StateProvinceID]
--		Note:	Many rows returned, same execution plan as previous
--				Still a covering index
select AddressID, StateProvinceID 
from Person.[Address]
where StateProvinceID = 9;


-- Key Lookup (Bookmark Lookup to clustered index table)
--		Index = [AdventureWorks].[Person].[Address].[IX_Address_StateProvinceID]
--		Index = [AdventureWorks].[Person].[Address].[PK_Address_AddressID]
--		Note:	Bookmark Lookup since IX_Address_StateProvinceID is indexed 
--				on the predicate, but is non-covering because ModifiedDate 
--				is not included in the non-clustered index
select AddressID, StateProvinceID, ModifiedDate
from Person.[Address]
where StateProvinceID = 32;


-- Clustered Index Scan
--		Index = [AdventureWorks].[Person].[Address].[PK_Address_AddressID]
--		Note:	So many rows returned, better to scan than bookmark lookup
--				Important to note 2 different execution plans for this query
--				vs previous query based entirely on predicate cardinality!
select AddressID, StateProvinceID, ModifiedDate
from Person.[Address]
where StateProvinceID = 9;


-- RID Lookup (Bookmark Lookup to heap table)
--		Note:	An non-clustered index to a heap table uses Row ID 
--				instead of PK to identify which row to reference
go
create index IX_Object on DatabaseLog(Object);				
-- View type of index created in the Object Explorer (may need a refresh)
go

select * from DatabaseLog where Object = 'City';

go
drop index DatabaseLog.IX_Object;
go
