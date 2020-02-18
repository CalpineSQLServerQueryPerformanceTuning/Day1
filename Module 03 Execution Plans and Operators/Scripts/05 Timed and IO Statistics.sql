use AdventureWorks;
go

-- Enable Time and IO Statistics
set statistics time on;
set statistics io on;
go

select * from Person.Person;
go

-- Disable Time and IO Statistics
set statistics time off;
set statistics io off;
go