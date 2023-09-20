
--procedure that add answer for question while exame running and add  score for answer and calculate final result
alter procedure student_insert
@exam_id int,
@student_id int,
@pool_question int,
@answer nvarchar(max)
as
begin
---------variables----------

declare @counter nvarchar(max)
set @counter=0

---------check for exam----------
	  if( EXISTS(select*from Student_Exam where Student_ID=@student_id and Exam_ID=@exam_id) and
	   @pool_question in(select Pool_ID from [dbo].[Question_Exam] join [dbo].[Question_Exam_Pool] on [Question_Exam_ID]=[ID]and Exam_ID=@exam_id)and
		cast(GETDATE()as time(7))<=(select End_Time from Student_Exam where Student_ID=@student_id and Exam_ID=@exam_id) and 
		 cast(GETDATE()as time(7))>=(select Start_Time from Student_Exam where Student_ID=@student_id and Exam_ID=@exam_id)and
		 cast(GETDATE()as date)=(select Date from Exam where ID=@exam_id)   and      
		@pool_question not in(select Pool_Question_ID from Student_Answer where Student_ID=@student_id and Exam_ID=@exam_id)
	   )
     begin

		-------------insert answer in table--------
					  insert into Student_Answer(Exam_ID,Student_ID,Pool_Question_ID,Answer,Score)
					  values (@exam_id,@student_id,@pool_question,@answer,0)
	    ------------add score for answer---------
					 select @counter= [Answer] from [dbo].[Question_Pool]
					 where [ID]=@pool_question

					if @counter=@answer
					   begin
							 select @counter=[question_degree] from [dbo].[Question_Exam] join [dbo].[Question_Exam_Pool]
							 on [Question_Exam_ID]=[ID] and [Pool_ID] =@pool_question 

							  update [dbo].[Student_Answer]
							  set score=@counter
							 where pool_question_id =@pool_question and Student_ID=@student_id and Exam_ID=@exam_id
					    end

             ------------update result of student------

							  update [dbo].[Student_Exam] 
								 set [Final_Result]=(select sum(Score) from Student_Answer
								 where [Exam_ID]=@exam_id and Student_ID=@student_id 
								 group by Exam_ID)
								 where  [Exam_ID]=@exam_id and Student_ID=@student_id

       end
else if (    cast(GETDATE()as time(7))>=(select End_Time from Student_Exam where Student_ID=@student_id and Exam_ID=@exam_id ))
   begin
      Throw 51000,'exam has been ended',1;
   end

else if (	 cast(GETDATE()as time(7))<=(select Start_Time from Student_Exam where Student_ID=@student_id and Exam_ID=@exam_id ))
	 begin
      Throw 51000,'please wait until exam start',1;
   end

else  
   begin
      Throw 51000,'please enter correct data of student and exam ',1;
   end
end


-----------exec the procdure student_insert-------
--@exam_id int,@student_id int,@pool_question int,@answer nvarchar(max)
exec student_insert  15,3,8,'1'


--procedure that change answer while exame running and add new score for answer and calculate final result 
go
alter procedure student_update_answer
@exam_id int,
@student_id int,
@pool_question int,
@answer nvarchar(max)
as
begin
---------variables----------
declare @counter nvarchar(max)
set @counter=0
---------variables----------
if( EXISTS(select*from Student_Exam where Student_ID=@student_id and Exam_ID=@exam_id) and
   @pool_question in(select Pool_ID from Question_Exam join Question_Exam_Pool on [Question_Exam_ID]=[ID]and Exam_ID=@exam_id)and
     cast(GETDATE()as time(7))<=(select End_Time from Student_Exam where Student_ID=@student_id and Exam_ID=@exam_id) and 
	 cast(GETDATE()as time(7))>=(select Start_Time from Student_Exam where Student_ID=@student_id and Exam_ID=@exam_id)and
	 cast(GETDATE()as date)=(select Date from Exam where ID=@exam_id) and
	  @pool_question  in(select Pool_Question_ID from Student_Answer where Student_ID=@student_id and Exam_ID=@exam_id)
   
   )
     begin
-------------change answer in table--------

	  	  update Student_Answer
	  set Answer=@answer
	  where Student_ID=@student_id and Exam_ID =@exam_id and Pool_Question_ID=@pool_question

	 
------------add score for answer---------
           select @counter= [Answer] from [dbo].[Question_Pool]
            where [ID]=@pool_question

    if @counter=@answer
       begin
         select @counter=[question_degree] from [dbo].[Question_Exam] join [dbo].[Question_Exam_Pool]
           on [Question_Exam_ID]=[ID] and [Pool_ID] =@pool_question 

          update [dbo].[Student_Answer]
           set score=@counter
            where pool_question_id =@pool_question and Student_ID=@student_id and Exam_ID=@exam_id
       end
     else
	      begin
              update [dbo].[Student_Answer]
               set score=0
                where pool_question_id =@pool_question and Student_ID=@student_id and Exam_ID=@exam_id
          end
------------update result of student------

  update [dbo].[Student_Exam] 
     set [Final_Result]=(select sum(Score) from Student_Answer
     where [Exam_ID]=@exam_id and Student_ID=@student_id 
     group by Exam_ID)
	 where  [Exam_ID]=@exam_id and Student_ID=@student_id

     end 
else if (    cast(GETDATE()as time(7))>=(select End_Time from Student_Exam where Student_ID=@student_id and Exam_ID=@exam_id ))
   begin
      Throw 51000,'exam has been ended',1;
   end

else if (	 cast(GETDATE()as time(7))<=(select Start_Time from Student_Exam where Student_ID=@student_id and Exam_ID=@exam_id ))
	 
	 begin
      Throw 51000,'please wait until exam start',1;
   end

else 
   begin
      Throw 51000,'please enter correct data of student and exam ',1;
   end
end



--procedure that show result of exam that student sign in 



alter procedure student_result 
@student_id int,
@exam_id int
as
begin
if(exists(select *from Student_Exam where Exam_ID=@exam_id and Student_ID=@student_id))
begin
if(  cast(GETDATE()as date)>(select Date from Exam where ID=@exam_id) )
   begin
			if(exists(select *from students_pass_exam where ID=@exam_id and Student_ID=@student_id))		
				begin
					   select Student_ID,student_name,course_name ,Final_Result,'Congratulations you passed the exam'as Exam_Result
					   from students_pass_exam where ID=@exam_id and Student_ID=@student_id
					
				end

			else 
					begin
						  select Student_ID,student_name,course_name ,Final_Result,'Unfortunately, you failed in the exam'as Exam_Result
						  from students_failed_exam where ID=@exam_id and Student_ID=@student_id
					end

		------------show result view table
           
		select Exam_Name,Question,Answer,correct_answer,Score 
		from result
		where student_id =@student_id and Exam_ID=@exam_id		
  end
else if(  cast(GETDATE()as date)=(select Date from Exam where ID=@exam_id)and 
	cast(GETDATE()as time(7))>(select End_Time from Student_Exam where Student_ID=@student_id and Exam_ID=@exam_id ))
		   begin
       
					if(exists(select *from students_pass_exam where ID=@exam_id and Student_ID=@student_id))
					
						begin
					
							select Student_ID,student_name,course_name ,Final_Result,'Congratulations you passed the exam'as Exam_result
					
							from students_pass_exam where ID=@exam_id and Student_ID=@student_id
					
						end

					else 
							begin
								select Student_ID,student_name,course_name ,Final_Result,'Unfortunately, you failed in the exam'as Exam_result
									from students_failed_exam where ID=@exam_id and Student_ID=@student_id 
            
							 end     
				------------show result view table
           
				select Exam_Name,Question,Answer,correct_answer,Score 
				from result
				where student_id =@student_id and Exam_ID=@exam_id   
		  end
else 
		begin
		   Throw 51000,'please wait until exam end',1;
		end

end
else
    begin
	Throw 51000,'The student is not registered for this exam',1;
	end
end



