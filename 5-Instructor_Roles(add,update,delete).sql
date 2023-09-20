use ExaminationSystem

--a The Instructor has a user and login access to the database he can read the data and write a data in one schema (Course Schema).
--b The Instructor SQL Permissions 
--grant the user permissions to Eng_sara as an Instructor that has permission to edit exam questions and add exam
grant insert,delete,update on [Courses].[Question_Pool] to  Eng_sara;
grant insert,delete,update on [Courses].[Question_Exam] to  Eng_sara;
grant insert,delete,update on [Courses].[Exam] to  Eng_sara;

--revoke instructor from permissions on database
revoke insert,delete,update on schema::[Members] to Eng_sara;
revoke insert,delete,update on schema:: [Department]to Eng_sara;

--***************************************************************************--
--istructor Roles can edit (insert,update,delete) on his course only

-- first we make a function to check if the instructor edit questions from his course only
create function Check_Instructor_Course
(
	@instructor_id int,
	@course_id int
)
returns int
as
begin
	declare @check int;
	select @check=count(*)
	from [Courses].[Course] as c
	where c.[ID]=@course_id and c.Instructor_ID=@instructor_id
	return @check
end

-- make sequence to insert the id questin 
CREATE SEQUENCE QuestionPoolIDSequence
    AS int
    START WITH 26
    INCREMENT BY 1
    MINVALUE 1
    NO MAXVALUE
--1 add question into question pool 
create procedure AddQuestions
@question_type nvarchar(50),
@text nvarchar(max),
@choice_1 nvarchar(max)=null,
@choice_2 nvarchar(max)=null,
@choice_3 nvarchar(max)=null,
@choice_4 nvarchar(max)=null,
@answer nvarchar(max),
@course_id int,
@instructor_id int
as
begin
	declare @check int;
	set @check= [dbo].[Check_Instructor_Course](@instructor_id,@course_id) --calling function 
	if @check=1
	begin
	-- sequence id -----------
		declare @id int 
		set @id = NEXT VALUE FOR dbo.QuestionPoolIDSequence;
		insert into [Courses].[Question_Pool]
		values (@id,@question_type,@text,@choice_1,@choice_2,@choice_3,@choice_4,@answer,@course_id);
		if @question_type <>'MCQ'
		begin
			if @question_type ='TRUE&False'
			begin
				update [Courses].[Question_Pool] 
				set [Choice_3]=null,[Choice_4]=null
				where [ID]=@id;
			end 
			else
			begin
				update [Courses].[Question_Pool] 
				set [Choice_1]=null,[Choice_2]=null,[Choice_3]=null,[Choice_4]=null
				where [ID]=@id;
			end
		end
	end
	else
		raiserror('sorry you do not have permission it me be you are not instructor or you  are add question in course is not belong you ',16,1);
end
-------Exec 
-- add question type of choose
EXEC AddQuestions
    @question_type = 'MCQ',
    @text = 'Which of the following is 
	not a valid SQL type',
    @choice_1 = 'FLOAT',
    @choice_2 = 'NUMERIC',
    @choice_3 = 'DECIMAL',
    @choice_4 = 'Int',
    @answer = 'CHARACTER',
    @course_id = 1,
    @instructor_id = 1;

-- add qouestion type of text
EXEC AddQuestions
    @question_type = 'text',
    @text = 'Which statement is
	used to delete 
	all rows in a table without having
	the action logged',
    @answer = 'TRUNCATE',
    @course_id = 1,
    @instructor_id = 1;
-- add qouestion type of true/false
EXEC AddQuestions
    @question_type = 'true&false',
	@choice_1='True',
	@choice_2='False',
    @text = 'SQL Views are also known as
	Virtual tables',
    @answer = 'true',
    @course_id = 1,
    @instructor_id = 1;
--**********************************************************************************--
--2 update question in the question pool 
create procedure UpdateQuestions 
@id int,
@question_type nvarchar(50),
@text nvarchar(max),
@choice_1 nvarchar(max)=null,
@choice_2 nvarchar(max)=null,
@choice_3 nvarchar(max)=null,
@choice_4 nvarchar(max)=null,
@answer nvarchar(max),
@course_id int,
@instructor_id int
as 
begin
	declare @check int;
	set @check= [dbo].[Check_Instructor_Course](@instructor_id,@course_id)
	if @check=1
	begin
		update [Courses].[Question_Pool]
		set Question_Type=@question_type,Text=@text,@choice_1=@choice_1,@choice_2=@choice_2,@choice_3=@choice_3,Choice_4=@choice_4,Answer=@answer,course_Id=@course_id
		where id=@id;
		if @question_type != 'MCQ'
		begin
			update [Courses].[Question_Pool] 
			set [Choice_1]=null,[Choice_2]=null,[Choice_3]=null,[Choice_4]=null
			where [ID]=@id;
		end
	end
	else
		raiserror('sorry you do not have permission it me be you are not instructor or you  are add question in course is not belong you ',16,1);
end

------Exec
exec UpdateQuestions
	@id=28,
    @question_type = 'true&false',
    @text = 'SQL Views are also known as
	actual tables',
    @answer = 'false',
    @course_id = 1,
    @instructor_id = 1;
--***********************************************************************************---
--3 delete quesition from pool questions
create procedure DeleteQuestion
@id int,
@ins_id int,
@course_id int
as 
begin
	declare @check int;
	set @check= [dbo].[Check_Instructor_Course](@ins_id,@course_id);
	if @check=1
	begin
		delete from [Courses].[Question_Pool] 
		where id=@id;
	end
	else
	raiserror('sorry you do not have permission it me be you are not instructor or you  are add question in course is not belong you ',16,1);
end
----Exec 
exec DeleteQuestion 
@id=41,
@ins_id=1,
@course_id=1

