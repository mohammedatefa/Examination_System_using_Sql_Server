
---------1
-------view to show final reault of student
go
alter view result
as
select E.ID as Exam_ID, SA.Student_ID,E.Name as Exam_Name,QP.Text as Question,SA.Answer,QP.Answer as correct_answer,SA.Score 
from Student_Answer SA join Question_Pool QP
on SA.Pool_Question_ID=QP.ID
join Exam E on Exam_ID=E.ID
union all
select E.id,se.Student_ID,E.Name as Exam_Name,QP.Text as Question,'no answer',QP.Answer as correct_answer,''
from  Exam E 
join Student_Exam  se on se.Exam_ID=e.ID
 join Question_Exam qe on E.ID=qe.Exam_ID
join Question_Exam_Pool qep on qep.Question_Exam_ID=qe.ID
join Question_Pool qp on qp.ID=qep.Pool_ID  
and qep.Pool_ID not in (select Pool_Question_ID from Student_Answer sa where sa.Student_ID=se.Student_ID  )




----------------------2
-------view to show students who pass the exam
go
	alter view students_pass_exam
	as
	select E.ID,Student_ID,s.Name as student_name,c.Name as course_name ,Final_Result
	from  [dbo].[Course] C 
	join Exam E on C.ID=E.Course_ID 
	join [dbo].[Student_Exam] se on se.Exam_ID=e.ID  and se.Final_Result>=c.Min_Degree
	join Student s on s.ID=se.Student_ID 
--------------------3
-------view to show students who faild in the exam

alter view students_failed_exam
as
select E.ID,Student_ID,s.Name as student_name,c.Name as course_name ,Final_Result
from  [dbo].[Course] C 
join Exam E on C.ID=E.Course_ID 
join [dbo].[Student_Exam] se on se.Exam_ID=e.ID  and se.Final_Result<c.Min_Degree
join Student s on s.ID=se.Student_ID 



--------------------4
-------view to show manager for each instructor
go
alter view Instructor_Manager
as
select B.ID ,B.Name as Instructor_name ,A.Name as Manager_name from Instructor A
join Instructor B 
on A.ID=B.Manger_ID



select * from Instructor
select * from Instructor_Manager





