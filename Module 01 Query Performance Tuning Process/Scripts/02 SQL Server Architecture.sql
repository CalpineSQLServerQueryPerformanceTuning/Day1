use master;

-- View All Memory Usage (Overwhelming)
dbcc memorystatus;


-- Memory Usage / Availability
select
	  physical_memory_kb	/ 1024			as [PhysicalMemoryMB]
	, virtual_memory_kb		/ 1024			as [VirtualMemoryMB]
	, committed_kb			/ 1024			as [CommittedMB]
	, committed_target_kb	/ 1024			as [CommittedTargetMB]
from 
	sys.dm_os_sys_info
;


-- Show Buffer and Plan Cache Usage
--		Try commenting out the WHERE clause to view all Memory Clerks
select 
	  [type]								as [ClerkType]
	, sum(pages_kb)			/ 1024			as [MemoryAllocatedMB]
from 
	sys.dm_os_memory_clerks
where 
		[Type] = 'CACHESTORE_OBJCP'
	or	[Type] = 'CACHESTORE_SQLCP'
	or	[Type] = 'MEMORYCLERK_SQLBUFFERPOOL'
group by 
	[type]
order by 
	[type]
;


-- Buffer Cache Usage by Database
select
	  dbs.name								as [Database]
	, count(*) * 8 / 1024					as [MB Used]
from 
			sys.dm_os_buffer_descriptors	as dobd
	join	sys.databases					as dbs		on dbs.database_id = dobd.database_id
group by 
	dbs.name
order by 
	count(*) desc
;

-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- !!! Beware on Production Server !!!
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

-- Clear Buffer Cache
dbcc dropcleanbuffers;

-- Clear Plan Cache
dbcc freeproccache;