use AdventureWorks;

-- Query to find Heap Tables in the Current Database
select 
	t.[Name]				as [HeapTable], t.type
from 
		sys.indexes			as i 
  join	sys.tables			as t				on i.object_id = t.object_id
where 
		i.type = 0			-- 0 is Heap, 1 is Clustered, 2 is NonClustered, 3 is XML and 4 is Spatial 
	and t.type = 'U'		-- U is User Table, S is System Table
;