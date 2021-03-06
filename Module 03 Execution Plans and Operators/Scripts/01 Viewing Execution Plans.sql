use AdventureWorks;
go

-- Query to Demonstrate Estimated (Ctrl+L) and Actual Execution Plans (Ctrl+M) using the GUI
select 
	  p.ProductID
	, p.[Name]
	, sode.UnitPrice * sode.OrderQty			as [Total Price]
from 
			Sales.SalesOrderDetailEnlarged		as sode
	join	Production.Product					as p		on sode.ProductID = p.ProductID
where 
	sode.ProductID = 745
;
go


-- Set Commands to View XML or Text Execution Plans
-- Turn off GUI Include Actual Execution Plan

--set showplan_xml on				-- Estimated XML
--set statistics xml on				-- Actual XML (Scroll down in Results Window to 2nd Query Results)
--set showplan_text on				-- Estimated Text
--set showplan_all on				-- Estimated Text with more info
--set statistics profile on			-- Actual Text (Scroll down in Results Window to 2nd Query Results)
go

select * from Production.Product;
go

--set showplan_xml off				-- Estimated XML
--set statistics xml off			-- Actual XML
--set showplan_text off				-- Estimated Text
--set showplan_all off				-- Estimated Text with more info
--set statistics profile off		-- Actual Text
go


-- Execution Plan Warnings
-- SQL Server 2005 Warnings:  NoJoinPredicate, ColumnsWithNoStatistics
-- SQL Server 2008 Warnings:  UnMatchedIndexes
-- SQL Server 2012 Warnings:  SpillToTempDb, PlanAffectingConvert, FullUpdateForOnlineIndexBuild

-- Example of NoJoinPredicate Warning (2nd Query is a Cross Join)
-- Vendor Syntax for Inner Join
select *
from 
	  Production.Product				as p
	, Production.ProductSubcategory		as ps
where 
	p.ProductSubcategoryID = ps.ProductSubcategoryID
;

-- Ooops, Cross Join
select 
	*
from 
	  Production.Product				as p
	, Production.ProductSubcategory		as ps
--where 
--	p.ProductSubcategoryID = ps.ProductSubcategoryID
;
go