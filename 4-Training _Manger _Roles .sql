--Training Manger Roles
--a-The Training manger has a user and login access to the database he can read the data and write a data in three schema ( department Schema that has Track, Branch, Intake) , (Members Schema that has Student and Instructor ) and (courses schema has (Courses & Exams) Tables ).

--b The Training manger SQL Permissions 
-- grant the user permissions to Eng_Mrihan as a training manager that has the permissions to add,update and delete (department,track, branch, intake,instructor,student,courses).
use ExaminationSystem;

grant insert,update,delete on  [Department].[Department]  to Eng_Mrihan;
grant insert,update,delete on  [Department].[Intake]      to Eng_Mrihan;
grant insert,update,delete on  [Department].[Branch]      to Eng_Mrihan;
grant insert,update,delete on  [Department].[Branch_Track] to Eng_Mrihan;
grant insert,update,delete on  [Department].[Intake_Track]     to Eng_Mrihan;
grant insert,update,delete on  [Department].[Track]       to Eng_Mrihan;
grant insert,update,delete on  [Courses].[Course]         to Eng_Mrihan;
grant insert,update,delete on  [Members].[Instructor]	  to Eng_Mrihan;
grant insert,update,delete on  [Members].[Student]		  to Eng_Mrihan;


--c-The training Manger can Insert in these Tables using (Stored Procedures)

--  manager can idet table o department (add,delete,update)
--create procedure AddDepartment 
--@id int,
--@name nvarchar(50),
--@user varchar(50),
--@pass varchar(50)
--as
--begin
--	if @user='Eng_mrihan' and @pass ='123'
--	begin
--		insert into [Department].[Department] 
--		values(@id,@name)
--	end
--	else
--	raiserror('you are not have this permission',16,1);
--end
------ Exec
--exec AddDepartment
--1,'computer scince','Eng_mrihan','123'

--1 manage baranch table(insert,update and delete)
alter procedure AddBranch
	@id int,
	@name nvarchar(50),
	@department_id int,
	@user varchar(50),
	@password varchar(5)
as
begin
	if @user='Eng_Mrihan'and @password='123' and @id not in (select id from [Department].[Branch]) and @name not in (select name from [Department].[Branch])
	begin
		insert into [Department].[Branch] 
		values(@id,@name,@department_id)
	end
	else if  @id in(select id from [Department].Branch)
	begin
		RAISERROR ('id of Branch is exist',16,1)
	end 
	else if  @name in(select [Name] from [Department].Branch)
	begin
		RAISERROR ('branch name is exist',16,1)
	end 

	else
		RAISERROR ('you are not manager you do not have this permission',16,1);
end
---------------EXEC
exec AddBranch
	@id=7,
	@name='ITI-Alex',
	@department_id=1,
	@user='Eng_Mrihan',
	@password='123';

--*****************************************************************************--

--1. 2 manage baranch table(update)
create procedure UpdateBranch
	@id int,
	@name nvarchar(50),
	@dep_id int,
	@user varchar(50),
	@pass varchar(5)
as
begin
	if @user='Eng_Mrihan' and @pass='123'
	begin
		update [Department].[Branch]
		set [Name]=@name
		where [ID]=@id
	end
	else 
	RAISERROR ('you are not manager you do not have this permission',16,1);
end 

---------EXEC
exec UpdateBranch
	@id=7,
	@name='ITI-Alexandria',
	@dep_id=1,
	@user='Eng_Mrihan',
	@pass='123';
--*****************************************************************************--
--1. 3 manage baranch table(delete)

create procedure DeleteBranch
	@name nvarchar(50),
	@user varchar(50),
	@pass varchar(5)
As
begin
	if @user='Eng_Mrihan' and @pass='123'
	begin
		delete from [Department].[Branch]
		where [Name]=@name
	end
	else
	RAISERROR ('you are not manager you do not have this permission',16,1);
end
-------EXEC
exec DeleteBranch
	@name='Qena',
	@user='Eng_Mrihan',
	@pass='123'
--*****************************************************************************--
--2 manage intake table(insert,update and delete) 
-- 2-1 add new intake
alter procedure AddIntake
	@id int,
	@name nvarchar(50),
	@startdate date,
	@enddate date,
	@user varchar(50),
	@pass varchar(5)
as
begin
	if @user='Eng_Mrihan' and @pass='123' and @id not in (select id from [Department].[Intake])and  @name not in(select [Name] from [Department].[Intake]) 
	begin 
		insert into [Department].[Intake]
		values(@id,@name,@startdate,@enddate)
	end
	else if  @id in(select id from [Department].[Intake])
	begin
		RAISERROR ('id of intake is exist',16,1)
	end 
	else if  @name in(select [Name] from [Department].[Intake])
	begin
		RAISERROR ('department name is exist',16,1)
	end 

	else
	RAISERROR ('you are not manager you do not have this permission',16,1);
end
-------Exec

exec AddIntake
	@id=8,
	@name='.Net 23-24 Q1',
	@startdate = '2023/07/05',
	@enddate= '2023/11/05',
	@user='Eng_Mrihan',
	@pass='123';

-- 2-2 update intake
create procedure UpdateIntake
	@id int,
	@name nvarchar(50),
	@startdate date,
	@enddate date,
	@user varchar(50),
	@pass varchar(5)
as 
begin
	if @user='Eng_Mrihan' and @pass='123'
	begin
		update [Department].[Intake]
		set [Name]=@name,[Start_Date]=@startdate,[End_Date]=@enddate
		where [ID]=@id
	end
	else
	RAISERROR ('you are not manager you do not have this permission',16,1);
end
exec UpdateIntake
	@id=6,
	@name='Mern_Stack 23-24 Q1', --we change name from .net to mern
	@startdate = '2023/07/05',
	@enddate= '2023/11/05',
	@user='Eng_Mrihan',
	@pass='123';

--2-3 delete intake
create procedure DeleteIntake
	@name nvarchar(50),
	@user varchar(50),
	@pass varchar(5)
as
begin
	if @user='Eng_Mrihan' and @pass='123'
	begin
		delete from [Department].[Intake]
		where [Name]=@name
	end
	else
	RAISERROR ('you are not manager you do not have this permission',16,1);
end

-------Exec
exec DeleteIntake
	@name='Mern_Stack 23-24 Q1',
	@user='Eng_Mrihan',
	@pass='123';
--*****************************************************************************--
--2 manage Track table(insert,update and delete) 
-- 2-1 add new Track
alter procedure AddTrack
	@id int,
	@name nvarchar(50),
	@user varchar(50),
	@pass varchar(5)
as
begin
	if @user='Eng_Mrihan' and @pass='123' and @id not in (select id from [Department].[Track])
	and @name not in(select name from [Department].[Track]) 
	begin
		insert into [Department].[Track]
		values(@id,@name)
	end
	else if  @id in(select id from [Department].Track)
	begin
		RAISERROR ('id of track is exist',16,1)
	end 
	else if  @name in(select [Name] from [Department].track)
	begin
		RAISERROR ('track name is exist',16,1)
	end 

	else
	RAISERROR ('you are not manager you do not have this permission',16,1);
end
-------Exec

exec AddTrack
	@id=12,
	@name='Full stack .Net',
	@user='Eng_Mrihan',
	@pass='123';

-- 2-2 update Track
create procedure UpdateTrack
	@oldName nvarchar(50),
	@newName nvarchar(50),
	@user varchar(50),
	@pass varchar(5)
as 
begin
	if @user='Eng_Mrihan' and @pass='123'
	begin
		update [Department].[Track]
		set [Name]=@newName
		where [Name]=@oldName
	end
	else
	RAISERROR ('you are not manager you do not have this permission',16,1);
end


exec UpdateTrack
	@oldName='Full stack .Net',
	@newName='Mern_Stack', --we change name from .net to mern
	@user='Eng_Mrihan',
	@pass='123';

--2-3 delete track
create procedure DeleteTrack
	@name nvarchar(50),
	@user varchar(50),
	@pass varchar(5)
as
begin
	if @user='Eng_Mrihan' and @pass='123'
	begin
		delete from [Department].[Track]
		where [Name]=@name
	end
	else
	RAISERROR ('you are not manager you do not have this permission',16,1);
end

-------Exec
exec DeleteTrack
	@name='Mern_Stack',
	@user='Eng_Mrihan',
	@pass='123';
--*****************************************************************************--
--3 manage instructor table 
--3.1 Add new instructor 
create procedure AddInstructor
	@id int,
	@name varchar(50),
	@Instusername nvarchar(50),
	@Instpass nvarchar(50),
	@manger_id int,
	@roleType nvarchar(50),
	@user varchar(50),
	@pass varchar(50)
as
begin
	if @user='Eng_Mrihan' and @pass='123'
	begin
		insert into [Members].[Instructor]
		values(@id,@name,@Instusername,@Instpass,@manger_id,@roleType)
	end
	else
	RAISERROR ('you are not manager you do not have this permission',16,1);
end

----Exec 
exec AddInstructor
@id=15,
@name='Mariam',
@Instusername='Eng_mariam',
@Instpass='123',
@manger_id=1,
@roleType='instructor',
@user='Eng_Mrihan',
@pass='123'

--3.2 update instructors
create procedure UpdateInstructor
	@id int,
	@name varchar(50),
	@Instusername nvarchar(50),
	@Instpass nvarchar(50),
	@manger_id int,
	@roleType nvarchar(50),
	@user varchar(50),
	@pass varchar(50)
as 
begin
	if @user='Eng_Mrihan' and @pass='123'
	begin
		update [Members].[Instructor]
		set Name=@name,User_Name=@Instusername,Password=@Instpass,Manger_ID=@manger_id,Role_type=@roleType
		where [ID]=@id

	end
	else
	RAISERROR ('you are not manager you do not have this permission',16,1);
end
exec UpdateInstructor
	@id=15,
	@name='Marwa',
	@Instusername='Marwa',
	@Instpass='123',
	@manger_id=1,
	@roleType='instructor',
	@user='Eng_Mrihan',
	@pass='123'

--3.3 delete instructor
create procedure DeleteInstructor
	@name varchar(50),
	@user varchar(50),
	@pass varchar(50)
as
begin
	if @user='Eng_Mrihan' and @pass='123'
	begin
		delete from [Members].[Instructor]
		where Name=@name
	end
	else
	RAISERROR ('you are not manager you do not have this permission',16,1);
end
-----Exec
exec DeleteInstructor
@name='Marwa',
@user='Eng_Mrihan',
@pass='123'

--*************************************************************************---
--4 manage the student table
--4.1 Add new student
create procedure AddStudent
	@ID int ,
	@Name varchar(50),
	@student_user varchar(50),
	@student_pass varchar(50),
	@Role_type varchar(50),
	@Address varchar(50),
	@intacke_id int,
	@user varchar(50),
	@pass varchar(50)
as
begin
	if @user='Eng_Mrihan' and @pass='123'
	begin
		insert into[Members].[Student]
		values(@ID,@Name,@student_user,@student_pass,@Role_type,@Address,@intacke_id)
	end
	else
	RAISERROR ('you are not manager you do not have this permission',16,1);
end
----exec
exec AddStudent 
	@id=29,
	@name='Hadeer Hossam',
	@student_user='Hadeer',
	@student_pass='123',
	@Role_type='student',
	@Address='minya',
	@intacke_id=3,
	@user='Eng_mrihan',
	@pass='123'

--4.2 update student
create procedure UpdateStudent
	@ID int ,
	@Name varchar(50),
	@student_user varchar(50),
	@student_pass varchar(50),
	@Role_type varchar(50),
	@Address varchar(50),
	@intacke_id int,
	@user varchar(50),
	@pass varchar(50)
as
begin
	if @user='Eng_Mrihan' and @pass='123'
	begin
		update [Members].[Student]
		set Name=@Name,User_Name=@student_user,Password=@student_pass,Role_type=@Role_type,Address=@Address,Intake_ID=@intacke_id
		where id=@ID
	end
	else
	RAISERROR ('you are not manager you do not have this permission',16,1);
end
----exec
exec UpdateStudent
	@id=3, @name='khaled Gamal',
	@student_user='Kaled', @student_pass='123',
	@Role_type='student', @Address='minya',
	@intacke_id=2,  --change the id of intake
	@user='Eng_mrihan',
	@pass='123'

--4.3 delete student
create procedure DeleteStudent
	@name varchar(50),
	@user varchar(50),
	@pass varchar(50)
as
begin
	if @user='Eng_Mrihan' and @pass='123'
	begin
		delete from [Members].[Student]
		where Name=@name
	end
	else
	RAISERROR ('you are not manager you do not have this permission',16,1);
end
-----Exec
exec DeleteStudent
@name='Khaled Gamal',
@user='Eng_Mrihan',
@pass='123'
--*************************************************************************---
--5 manage course table
--5.1 add new course
create procedure AddCourse
	@id int,
	@name varchar(50),
	@description varchar(max),
	@mindegree int,
	@maxdegree int,
	@instructorId int,
	@user varchar(50),
	@pass varchar(50)
as
begin
	if @user='Eng_Mrihan' and @pass='123'
	begin
		insert into[Courses].[Course]
		values(@id,@name,@description,@mindegree,@maxdegree,@instructorId)
	end
	else
	RAISERROR ('you are not manager you do not have this permission',16,1);
end
-----Exec
exec AddCourse
@id=10,
@name='Bootstarb',
@description='course to make responsive website',
@mindegree=50,
@maxdegree=100,
@instructorId=2,
@user='Eng_Mrihan',
@pass='123'

--5.1 update new course
create procedure UpdateCourse
	@id int,
	@name varchar(50),
	@description varchar(max),
	@mindegree int,
	@maxdegree int,
	@instructorId int,
	@user varchar(50),
	@pass varchar(50)
as
begin
	if @user='Eng_Mrihan' and @pass='123'
	begin
		update[Courses].[Course]
		set Name=@name,Description=@description,Min_Degree=@mindegree,Max_Degree=@maxdegree,Instructor_ID=@instructorId
		where ID=@id
	end
	else
	RAISERROR ('you are not manager you do not have this permission',16,1);
end
-----Exec
exec UpdateCourse
@id=10, @name='Bootstarb',
@description='course to make responsive website',
@mindegree=50, @maxdegree=100,
@instructorId=3, --cahnge the instructor id
@user='Eng_Mrihan',
@pass='123'

--5.3 delete course
create procedure DeleteCourse
	@name varchar(50),
	@user varchar(50),
	@pass varchar(50)
as
begin
	if @user='Eng_Mrihan' and @pass='123'
	begin
		delete from [Courses].[Course]
		where [Name]=@name
	end
	else
	RAISERROR ('you are not manager you do not have this permission',16,1);
end
drop procedure DeleteCourse
-----Exec
exec DeleteCourse
@name='Bootstrab',
@user='Eng_Mrihan',
@pass='123'
