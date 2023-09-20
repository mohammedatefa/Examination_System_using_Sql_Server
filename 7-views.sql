use ExaminationSystem;

--1 cretae view to show all department and it branch, track and intake 
create view Show_Department_Detailes
as
select d.Name as 'Department-Name',b.Name  as 'Branch-Name',t.name as 'Track-Name',i.Name as 'Intake-Name'
from [Department].[Department] d join [Department].[Branch] b
on d.ID=b.Department_ID join [Department].[Branch_Track] bt
on b.ID= bt.Branch_ID join [Department].[Track] t
on t.ID=bt.Track_ID join [Department].[Intake_Track] it
on it.Track_ID=t.ID join [Department].[Intake] i
on i.ID=it.Intake_ID

--2 create view to show students courses details (course->instuctor->intake)
create view Show_students_courses_Details
as
select s.Name as 'student name', c.Name as  'course name', i.Name as 'course instructor' ,it.Name as 'student intake'
from [Members].[Student] s join [Members].[Student_Course] sc
on s.ID=sc.Student_ID join [Courses].[Course] c
on sc.Course_ID=c.ID join [Members].[Instructor] i
on i.ID=c.Instructor_ID join [Department].[Intake] it
on s.Intake_ID=it.ID

--3 View to show the instructors and their courses.
create view Show_instructor_courses 
as
select i.Name as 'instructor name', c.Name as 'course name',de.Name as'department name'
from [Courses].[Course] c join [Members].[Instructor] i
on c.ID=i.ID join [Members].[Instructor_Department] d
on d.Instructor_ID=i.ID join [Department].[Department] de
on d.Department_ID=de.ID


 








