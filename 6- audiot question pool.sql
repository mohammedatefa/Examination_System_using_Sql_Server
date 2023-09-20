--we make audiots table that help us to know what occur on the table of questions pool such as 
-- who add or delete question and when he make it 
-- each question that added by each instructors 

-- first we make the audiot table that contain the details of editing  
use ExaminationSystem;
create table Audiot_QuestionPool
(
	question_id int, 
	course_id int,
	operation nvarchar(10),
	operation_time date
)

transfer  Audiot_QuestionPool

--trigger 
create trigger audiots_questions
on [Courses].[Question_Pool]
After insert ,delete 
as
begin
	insert into [dbo].[Audiot_QuestionPool]
	(
		question_id, course_id, operation, operation_time
	)
	select 
		i.id, i.Course_ID, 'INSERT', getdate()
	from inserted i
	union all
	select
		d.id, d.Course_ID, 'deleted', getdate()
	from deleted d;
end

--create view to show the instructor and its edit question details
create view Show_QuestionsPool_Edit_Details
as
select i.Name as 'Instructor-Name ', c.Name as 'Course-Name', QP.Text as 'Question',Qp.Question_Type as 'Question-Type', Aq.operation_time 
from [dbo].[Audiot_QuestionPool] AQ join [Courses].[Question_Pool] Qp
on Qp.ID=AQ.question_id join [Courses].[Course] c
on c.ID=Qp.Course_ID join [Members].[Instructor] i
on i.ID=c.Instructor_ID
drop view Show_QuestionsPool_Edit_Details
select * from Show_QuestionsPool_Edit_Details