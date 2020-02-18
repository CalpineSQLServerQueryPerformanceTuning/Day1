use AdventureWorks;
go

-- Enable Time and IO Statistics
set statistics time on
set statistics io on
go

-- Clear Buffer and Procedure Caches
checkpoint
go
dbcc dropcleanbuffers
dbcc freeproccache
go

-- Query to Demonstrate Estimated and Actual Execution Plans using the GUI
select 
	  p.ProductID
	, p.Name
	, sode.UnitPrice * sode.OrderQty			as [Total Price]
from 
			Sales.SalesOrderDetailEnlarged		as sode
	join	Production.Product					as p		on sode.ProductID = p.ProductID
where 
	sode.ProductID = 745
;
go 2			-- go 2 executes batch 2 times, show physical vs logical reads with no buffer cache flush in between

-- Disable Time and IO Statistics
set statistics time off
set statistics io off
go