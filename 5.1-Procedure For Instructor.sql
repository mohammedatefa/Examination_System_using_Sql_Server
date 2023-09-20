
----------------------------------- Some Sequences to use ----------------------
create sequence Exam_Seq -- okay
as int 
start with 1 
INCREMENT by 1;


create sequence Question_Exam_Seq -- okay 
as int 
start with 1 
INCREMENT by 1;




--drop sequence  Question_Exam_Seq
--drop sequence  Exam_Seq


-------------------------------------------------------- Procedure for instructor ------------------------------------------
--------- create view >>> to show Exam_ID 
create view Exam_ID as
select * from [Courses].[Exam]
--------- create view to show Question Exam 
create view Question_Exam_View as
select [Pool_ID] 'Question ID' , [question_degree] , [Exam_ID] from [Courses].[Question_Exam] qe join [Courses].[Question_Exam_Pool] qp on qe.ID = qp.Question_Exam_ID 
--------- Create view to show Student Exam 
create view Student_Exam_View as 
select * from [Members].[Student_Exam] 

-----------------------------------Creating Exam ---------------------

create proc Creating_Exam
@Exam_name nvarchar(50) ,
@Exam_type nvarchar(50) ,
@Exam_Date date ,
@Total_degree int ,
@Exam_year int ,
@Instructor_ID int,
@Course_ID int 
as begin 

if		EXISTS ( select 1 FROM [Courses].[Course] c
        JOIN [Members].[Instructor] i ON c.Instructor_ID = i.ID
        WHERE c.ID = @Course_ID AND i.ID = @Instructor_ID)

		begin 
		declare @next_value int
		set @next_value = NEXT VALUE FOR Exam_Seq
			insert into [Courses].[Exam]([ID],[Name],[Type],[Date],[total_degree],[year],[Instructor_ID],[Course_ID])
			values ( @next_value , @Exam_name , @Exam_type , @Exam_Date , @Total_degree , @Exam_year , @Instructor_ID ,@Course_ID )
			select * from Exam_ID where ID = @next_value
			print 'Your Exam Added Successfully'
			
		end 
else 
		begin 
		THROW 51000, 'Instructor does not teach the course.', 1;
			rollback
		end

end

exec Creating_Exam 'C# Exam' , 'Corrective' , '2023-09-10', 100 , 2024 , 1,1


--------------------------------- Choose questions of exam ---------------------------

create proc insert_Question
@Question_ID int ,
@Question_Degree int ,
@Exam_ID int ,
@Instructor_ID int ,
@Course_ID int
as
begin 
	declare @sum int 
	if (@Exam_ID not in (select [Exam_ID] from[Courses].[Question_Exam] ))
	begin 

		set @sum = 0
	end
	else 
	begin 
		set @sum=(SELECT SUM(isnull([question_degree],0)) FROM [Courses].[Question_Exam] WHERE [Exam_ID] = @Exam_ID )
	end
	if  (
	(exists(select 1 from [Courses].[Exam] where [ID]=@Exam_ID and [Instructor_ID] =@Instructor_ID) )
	and 
	(@Question_ID in (select [ID] from [Courses].[Question_Pool] where [Course_ID] = @Course_ID  ))
	and
	(
        (SELECT @Question_Degree + @sum)
        <=
        (SELECT [total_degree] FROM [Courses].[Exam] WHERE [ID] = @Exam_ID)
    )
		)
	begin 
	declare @Next_value int 
	set @Next_value = next value for Question_Exam_Seq
		insert into [Courses].[Question_Exam]([ID],[question_degree],[Exam_ID])
		values (@Next_value ,@Question_Degree,@Exam_ID)


		insert into [Courses].[Question_Exam_Pool]([Pool_ID],[Question_Exam_ID])
		values (@Question_ID,@Next_value )
		select 'Question inserted successfully.'
		select * from Question_Exam_View where @Exam_ID = Exam_ID
	end
else if (
		not exists(select 1 from [Courses].[Exam] where [ID]=@Exam_ID and [Instructor_ID] =@Instructor_ID) 
		)
		begin 
			THROW 51000, 'Instructor does not teach the course.', 1;
			rollback
		end
else if (
		 @Question_ID not in (select [ID] from [Courses].[Question_Pool] where [Course_ID] = @Course_ID  )
		)
		begin 
			THROW 51000, 'Question ID is not in Question Pool or not in the same course ', 1;
			rollback
		end
else if (
		((select @Question_Degree  +(select [total_degree] from [Courses].[Exam] where [ID]  =@Exam_ID))>(select sum([question_degree]) from [Courses].[Question_Exam] where [Exam_ID] =@Exam_ID))
		)
		begin 
			THROW 51000, 'You cannot insert this question becuase its degree will make total degree of exam exceeds the allow value', 1;
			rollback
		end
else 
		begin 
			THROW 51000, 'Wrong Data Inserted', 1;
			rollback
		end

end 

exec insert_Question 1,10,20,1,1





------------------------------- Choose single Student for Exam ----------------------------------

create proc Choose_Single_Student_for_Exam
@Student_ID int ,
@Exam_ID int ,
@Instructor_ID int ,
@Course_ID int ,
@Start_Time time ,
@End_Time time  
as
begin 
	
 	if  (
	(exists(select 1 from [Courses].[Exam] where [ID]=@Exam_ID and [Instructor_ID] =@Instructor_ID) )
	and 
	(@Student_ID in (select [Student_ID] from [Members].[Student_Course] where [Course_ID] = @Course_ID ))
	and (  cast(GETDATE()as date)<(select Date from [Courses].[Exam] where ID=@exam_id) ))
	begin
		insert into [Members].[Student_Exam]
		values (@Exam_ID,@Student_ID,@Start_Time,@End_Time,0)
		select * from Student_Exam_View where [Exam_ID] = @Exam_ID
		print 'Student Added Successfully'
		
	end 
	else if 
	(@Exam_ID not in (select [ID] from [Courses].[Exam] ))
	begin 
		THROW 51000, 'No Exam With This ID', 1;
		rollback
	end
	else if 
	(@Student_ID not in (select [ID] from [Members].[Student]))
	begin 
		THROW 51000, 'No Student With This ID', 1;
		rollback
	end
	else if 
	(not exists(select 1 from [Courses].[Exam] where [ID]=@Exam_ID and [Instructor_ID] =@Instructor_ID) )
	begin 
		THROW 51000, 'Instructor does not teach the course. or not the instructor Exam', 1;
		rollback
	end
	else if 
	(@Student_ID not in (select [Student_ID] from [Members].[Student_Course] where [Course_ID] = @Course_ID ))
	begin 
		THROW 51000, 'Wrong Student ID or Student ID does not match the courses for This Student', 1;
		rollback
	end
	else 
	begin
		THROW 51000, 'Student already exist', 1;
		rollback
	end
end
-- @Student_ID int , @Exam_ID int , @Instructor_ID int , @Course_ID int ,@Start_Time time , @End_Time time 
exec Choose_Single_Student_for_Exam 1,19,1,1,'12:34:56','14:34:56'



---------------------------------------------- Adding Students of specific Course in specific track --------------------------

  
  create proc Choose_Students_for_Exam_in_Course
  @Instructor_ID int ,
  @Course_ID int ,
  @Exam_ID int,
  @Start_Time time , @End_Time time 
  as 
  begin 

	if  (
	exists(select 1 from [Courses].[Exam] where [ID]=@Exam_ID and [Instructor_ID] =@Instructor_ID) )
	begin
	insert into [Members].[Student_Exam] ([Student_ID],[Exam_ID],[Start_Time],[End_Time],[Final_Result])
	SELECT [Student_ID], @Exam_ID ,  @Start_Time , @End_Time,0
	FROM [Members].[Student_Course]
	where [Course_ID]=1
	end
	else if (@Exam_ID not in (select [ID]from [Courses].[Exam]))
	begin 
		THROW 51000, 'Exam is not Exist', 1;
		rollback
	end
	else 
	begin
		THROW 51000, 'Instructor does not teach the course. or not the instructor Exam', 1;
		rollback
	end

  end

   exec Choose_Students_for_Exam_in_Course 1,1,19,'12:34:56','14:34:56'



---------------------------------------- Create Random Questions depend on course id ---------------------

create proc Choosing_Random_Exam_Questions
@Instructor_ID int ,
@Course_ID int ,
@Question_Degree int ,
@Exam_ID int ,
@Number_OF_Questions int
as 
begin 


	if  (
	(exists(select 1 from [Courses].[Exam] where [ID]=@Exam_ID and [Instructor_ID] =@Instructor_ID) AND @Course_ID IN (SELECT [ID] FROM [Courses].[Course] WHERE [Instructor_ID]=@Instructor_ID ) )

	and
	(@Exam_ID not in (select [Exam_ID] from[Courses].[Question_Exam] ))

	and
		((@Number_OF_Questions * @Question_Degree) <= (select [total_degree] from [Courses].[Exam] where [ID] =@Exam_ID ))
		)
	begin 
	declare @Random_Number int
	declare @Next_value int 
	set @Next_value = next value for Question_Exam_Seq
	declare @counter int
	set @counter =1 
	while @counter <= @Number_OF_Questions 
	begin

		insert into [Courses].[Question_Exam]([ID],[question_degree],[Exam_ID])
		values (@Next_value ,@Question_Degree,@Exam_ID)
		
		while (2>-1)
		begin
		set @Random_Number =(SELECT TOP 1 [ID]
		FROM [Courses].[Question_Pool]
		WHERE [Course_ID] = @Course_ID  
		ORDER BY NEWID()) 
		if (@Random_Number not in (select [Pool_ID] from [Courses].[Question_Exam_Pool] QP JOIN [Courses].[Question_Exam] QE ON QP.Question_Exam_ID = QE.ID AND QE.Exam_ID = @Exam_ID ))
		begin
		break;
		end
		end
		INSERT INTO [Courses].[Question_Exam_Pool] ([Pool_ID], [Question_Exam_ID])
		VALUES( @Random_Number, @Next_value)
		
		set @Next_value = NEXT VALUE FOR Question_Exam_Seq
		set @counter = @counter +1 

	end
    SELECT 'Questions inserted successfully.' AS Result;
	select * from Question_Exam_View where @Exam_ID = Exam_ID
	end
else if (
		(not exists(select 1 from [Courses].[Exam] where [ID]=@Exam_ID and [Instructor_ID] =@Instructor_ID) ) OR ((@Course_ID NOT IN (SELECT [ID] FROM [Courses].[Course] WHERE [Instructor_ID]=@Instructor_ID )))
		)
		begin 
			THROW 51000, 'Instructor does not teach the course .', 1;
			rollback
		end

else if (
		((@Number_OF_Questions * @Question_Degree) > (select [total_degree] from [Courses].[Exam] where [ID] =@Exam_ID ))
		)
		begin 
			THROW 51000,'Your Data Exceeds The Max Value of the Exam ' , 1;
			rollback
		end
else if (
		@Exam_ID in (select[Exam_ID] from [Courses].[Question_Exam] )
		)
		begin 
			THROW 51000,'Exam Questions already Created before ' , 1;
			rollback
		end
else 
		begin 
			THROW 51000, 'Wrong Data Inserted', 1;
			rollback
		end

end


exec Choosing_Random_Exam_Questions 1,1,10,18,10


---------------------------------------------------------update on exam table ------------------------------------------------------
---------- Update Single Value ------------------------------
 
create PROCEDURE Update_Single_Exam_Value	
	@instructorID int,
    @ColumnName NVARCHAR(50),
    @ColumnValue NVARCHAR(MAX),
    @ExamId INT
AS
BEGIN
	if (@ColumnName = 'ID')
	begin
			THROW 51000,'You Cannot edit Exam ID' , 1;
			rollback
	end
		else if (@ColumnName = 'Instructor_ID')
	begin
			THROW 51000,'You Cannot edit Instructor ID' , 1;
			rollback
	end
		else if (@ColumnName = 'Course_ID')
	begin
			THROW 51000,'You Cannot edit Course ID' , 1;
			rollback
	end
	 if (@ColumnName = 'Date' and (cast(@ColumnValue as date) < (cast(getdate()as date)) ))
	begin 
			THROW 51000,'You Cannot set Date to this Date ' , 1;
			rollback
	end

	else if  (@instructorID in (select [Instructor_ID] from [Courses].[Exam] where [ID]=@ExamId )and
	(cast(GETDATE()as date)<(select Date from [Courses].[Exam] where ID=@ExamId) ))
		begin 
			DECLARE @tempSP NVARCHAR(MAX)
    
			SET @tempSP = 'UPDATE [Courses].[Exam] SET ' + QUOTENAME(@ColumnName) + ' = @ColumnValue WHERE [Courses].[Exam].[ID] = @ExamId'
    
			EXEC sp_executesql @tempSP, N'@ColumnValue NVARCHAR(MAX), @ExamId INT', @ColumnValue, @ExamId
		 end
	else if (@ExamId not in (select [ID]from [Courses].[Exam]))
	begin
			THROW 51000,'Wrong Exam ID' , 1;
			rollback
	end
	else if (cast(GETDATE()as date)>(select Date from [Courses].[Exam] where ID=@ExamId))
	begin 
			THROW 51000,'sorry you Cannot edit exam cause its date is over' , 1;
			rollback
	end
	else 
	begin
			THROW 51000,'Instructor ID that you entered does not match the instructor id of this exam' , 1;
			rollback
	end
END

exec Update_Single_Exam_Value 1,'Date','2023-09-5',18


----------------- Update Multi Values --------------------------------

create TYPE ExamMultiValueUpdateType AS TABLE
(
    Column_Name NVARCHAR(50),
   Column_Value NVARCHAR(MAX)
);

create proc Update_Multi_Exam_Value
@Updates ExamMultiValueUpdateType readonly ,
@Exam_ID int,
@instructorID int
as
begin
	if ('ID' in(select Column_Name from @Updates)   )
	begin
			THROW 51000,'You Cannot edit Exam ID' , 1;
			rollback
	end
	else IF (SELECT CAST(Column_Value AS DATE) FROM @Updates WHERE Column_Name = 'Date') < CAST(GETDATE() AS DATE)
	BEGIN
    THROW 51000, 'You cannot set the Date to this Date.', 1;
    ROLLBACK;
	END
	else if ('Instructor_ID' in (select Column_Name from @Updates  ))
		begin
			THROW 51000,'You Cannot edit Instructor ID' , 1;
			rollback
	end
	else if ('Course_ID'in(select Column_Name from @Updates  ))
	begin 
		 THROW 51000, 'You cannot edit Course ID', 1;
		 ROLLBACK;
	end

	else if  (@instructorID in (select [Instructor_ID] from [Courses].[Exam] where [ID]=@Exam_ID ))
		begin 
			DECLARE @tempSP NVARCHAR(MAX)
    
			SET @tempSP = 'UPDATE [Courses].[Exam] SET ' 
			     SELECT @tempSP = @tempSP + QUOTENAME(Column_Name) + ' = ''' + REPLACE(Column_Value, '''', '''''') + ''', ' FROM @Updates
				 SET @tempSP = LEFT(@tempSP, LEN(@tempSP) - 1)
			set @tempSP = @tempSP + ' WHERE [Courses].[Exam].[ID] = @ExamId'
   
			EXEC sp_executesql @tempSP, N'@ExamId int', @Exam_ID 
		 end
	else 
	begin
			THROW 51000,'Instructor ID that you entered does not match the instructor id of this exam' , 1;
			rollback
	end
	
end
 
declare @Updates ExamMultiValueUpdateType 
insert into @Updates
values
('Date','2023-09-15')
exec Update_Multi_Exam_Value  @Updates,20,1



-------------------------------------------------------------- Update in Student Exam ---------------------------------------------

create PROCEDURE Update_Single_Student_Exam_Value	
	@instructorID int,
    @ColumnName NVARCHAR(50),
    @ColumnValue time(7),
    @ExamId INT
AS
BEGIN
	if  (@ColumnName = 'Exam_ID' )
	begin 
			THROW 51000,'You cannot update Exam_ID' , 1;
			rollback
	end
	else if  (@ColumnName = 'Student_ID') 
	begin 
			THROW 51000,'You cannot update Student_ID' , 1; 
			rollback
	end
	else if  (@ColumnName = 'Final_Result') 
	begin 
			THROW 51000,'You cannot update Final Result' , 1;
			rollback
	end
	IF (
    @instructorID IN (SELECT DISTINCT [Instructor_ID] FROM [Courses].[Exam] WHERE [ID] = @ExamId)
    AND
    CAST(GETDATE() AS DATE) < (SELECT (Date) FROM [Courses].[Exam] WHERE ID = @ExamId)
    )
		begin 
			DECLARE @tempSP NVARCHAR(MAX)
    
			SET @tempSP = 'UPDATE [Members].[Student_Exam] SET ' + QUOTENAME(@ColumnName) + ' = @ColumnValue WHERE [Exam_ID] = @ExamId'
    
			EXEC sp_executesql @tempSP, N'@ColumnValue time(7), @ExamId INT', @ColumnValue, @ExamId
		 end
	else if (
    @instructorID IN (SELECT DISTINCT [Instructor_ID] FROM [Courses].[Exam] WHERE [ID] = @ExamId)
    OR
    CAST(GETDATE() AS DATE) > (SELECT (Date) FROM Exam WHERE ID = @ExamId)
    )
	begin 
			THROW 51000,'You Cannot Set this Time to this  Exam' , 1;
			rollback
	end
	else 
	begin
			THROW 51000,'Instructor ID that you entered does not match the instructor id of this exam' , 1;
			rollback
	end
end

exec Update_Single_Student_Exam_Value 1, 'Start_Time' , '12:30:56',20


-----------------------------------------------------------Update in Question Pool -----------------------------------

create TYPE Question_pool_Type AS TABLE
(
    Column_Name NVARCHAR(50),
   Column_Value NVARCHAR(MAX)
);

create proc Update_Multi_Question_Pool_Value
@Updates Question_pool_Type readonly ,
@Question_ID int,
@instructorID int,
@Course_ID int
as
begin
	if  (@instructorID = (select [Instructor_ID] from [Courses].[Course] where  [ID]= @Course_ID  ))

		begin 
			DECLARE @tempSP NVARCHAR(MAX)
    
			SET @tempSP = 'UPDATE [Courses].[Question_Pool] SET ' 
			     SELECT @tempSP = @tempSP + QUOTENAME(Column_Name) + ' = ''' + REPLACE(Column_Value, '''', '''''') + ''', ' FROM @Updates
				 SET @tempSP = LEFT(@tempSP, LEN(@tempSP) - 1)
			set @tempSP = @tempSP + ' WHERE [Courses].[Question_Pool].[ID] = @Question_ID'
   
			EXEC sp_executesql @tempSP, N'@Question_ID int', @Question_ID 
		 end
	else if (@Question_ID not in (select [ID] from [Courses].[Question_Pool]))
	begin 
			THROW 51000,'Question ID Invalid' , 1;
			rollback
	end
	else 
	begin
			THROW 51000,'Instructor ID that you entered does not match the instructor id of this exam' , 1;
			rollback
	end
	
	
end

declare @Updates Question_pool_Type 
insert into @Updates
values
('Choice_1','test'),
('Choice_2','test 2 ')
exec Update_Multi_Question_Pool_Value  @Updates,1,1,1
----------------------------------------------------------- Update in Question Exam table -----------------------

create proc Update_on_Question_Degree_IN_Exam_Table
@Instructor_ID int ,
@CourseID int ,
@Exam_ID int ,
@Question_ID int ,
@New_Question_Degree int 
as begin 
		if (@Instructor_ID in (select [Instructor_ID] from[Courses].[Exam] where [ID] =@Exam_ID)
		
		and (@Question_ID in (select [Pool_ID] from [Courses].[Question_Exam] qe join [Courses].[Question_Exam_Pool] qp on qe.ID = qp.Question_Exam_ID and  @Exam_ID = qe.Exam_ID   ))
		and  CAST(GETDATE() AS DATE) < (SELECT (Date) FROM [Courses].[Exam] WHERE ID = @Exam_ID)
		and ((-(select [question_degree] from [Courses].[Question_Exam] qe join [Courses].[Question_Exam_Pool] qp on qe.ID = qp.Question_Exam_ID and  @Exam_ID = qe.Exam_ID and Pool_ID = @Question_ID)+
		@New_Question_Degree+(select sum([question_degree])from [Courses].[Question_Exam] where [Exam_ID] = @Exam_ID)) <= (select [total_degree] from [Courses].[Exam] where [ID] =  @Exam_ID) ))

		begin 
			update [Courses].[Question_Exam] 
			set [question_degree] = @New_Question_Degree 
			where ([ID] = (select [ID] from [Courses].[Question_Exam] qe join [Courses].[Question_Exam_Pool] qp on qe.ID = qp.Question_Exam_ID and  @Exam_ID = qe.Exam_ID and Pool_ID = @Question_ID))
			select 'Value Updated Successfully'
			select * from Question_Exam_View where @Exam_ID = Exam_ID
		end

		else if (@Instructor_ID not in (select [Instructor_ID] from[Courses].[Exam] where [ID] =@Exam_ID))
		begin 
			THROW 51000,'Instructor didn''t create this exam' , 1;
			rollback
		end
		else if ((@Question_ID not in (select [Pool_ID] from [Courses].[Question_Exam] qe join [Courses].[Question_Exam_Pool] qp on qe.ID = qp.Question_Exam_ID and  @Exam_ID = qe.Exam_ID   )))
		begin 
			THROW 51000,' Wrong Question ID' , 1;
			rollback
		end
		else if (CAST(GETDATE() AS DATE) > (SELECT (Date) FROM [Courses].[Exam] WHERE ID = @Exam_ID))
		begin 
			THROW 51000,' you cannot Edit in exam in this time ' , 1;
			rollback
		end
		else 
		begin
			THROW 51000,' you cannot Edit Question Degree to this value because it exeeds the maximum value of the exam  ' , 1;
			rollback
		end
end

exec Update_on_Question_Degree_IN_Exam_Table 1,1,20,4,5
---------------------------------------------------------- Delete in Exam Table ----------------------------

create proc Delete_From_Exam_Table 
	@instructorID int,
    @ExamId INT
as
begin 
	if  (@instructorID in (select [Instructor_ID] from [Courses].[Exam] where [ID]=@ExamId )and
	(cast(GETDATE()as date)<(select Date from [Courses].[Exam] where ID=@ExamId) ))
		begin 
			delete from [Courses].[Exam] where [ID] = @ExamId
			delete from [Members].[Student_Exam] where [Exam_ID] = @ExamId
			delete from [Courses].[Question_Exam] where [Exam_ID] = @ExamId
		end
		-- Question-Exam-Pool-Deleted by Default
end
exec Delete_From_Exam_Table 1,20
-------------------------------------------------------------------------------- End ------------------------------------------------------------------




