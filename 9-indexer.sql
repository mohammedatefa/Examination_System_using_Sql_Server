
-- create non-clusterd indexer on student-name
create nonclustered index idx_StudentName
on [Members].[Student]([Name]);

-- create non-clusterd indexer on instructor-name
create nonclustered index idx_instructorName
on [Members].[Student]([Name]);