use AdventureWorks;

-- Query to see sizes of all indexes in the current database
select 
	  t.[name]								as [TableName]
	, i.[name]								as [IndexName]
	, sum(ddps.[used_page_count]) * 8		as [IndexSizeKB]
from 
			sys.dm_db_partition_stats		as ddps
	join	sys.indexes						as i					on		ddps.[object_id]	= i.[object_id] 
																		and ddps.[index_id]		= i.[index_id]
	join	sys.tables						as t					on		t.object_id			= i.object_id
group by 
	t.[name], i.[name]
order by 
	[IndexSizeKB] desc
;