alter database [ExaminationSystem] modify name = [examination]
--('MCQ','True&False','Text'))
alter table [dbo].[Question_Pool]


alter table [dbo].[Question_Pool]


---------------------------- insert into Quesion Pool ---------------------------------------

insert into [dbo].[Question_Pool] ([ID],[Question_Type],[Text],[Choice_1],[Choice_2],[Choice_3],[Choice_4],[Answer],[Course_ID])
values
(1, 'MCQ' ,	'How many Bytes are stored by ‘Long’ Data type in C# .net?' ,	'8',	'4',	'2',	'1',	'1', 1 ),
(2, 'MCQ','Choose “.NET class” name from which data type “UInt” is derived?','System.Int16',	'System.UInt32',	'System.UInt64',	'System.UInt16','2',1),
(3,'MCQ','Correct Declaration of Values to variables ‘a’ and ‘b’?','int a = 32, b = 40.6;','int a = 42; b = 40;',	'int a = 32; int b = 40;',	' int a = b = 42;' ,'3',1),
(4,'MCQ','Arrange the following data type in order of increasing magnitude sbyte, short, long, int.','long < short < int < sbyte','sbyte < short < int < long','short < sbyte < int < long','short < int < sbyte < long','2',1),
(5,'MCQ','Which data type should be more preferred for storing a simple number like 35 to improve execution speed of a program?','sbyte','short','int','long','1',1),
(6,'MCQ','Correct way to assign values to variable ‘c’ when int a=12, float b=3.5, int c;','c = a + b;','c = a + int(float(b));','c = a + convert.ToInt32(b);','c = int(a + b);','3',1),
(7,'MCQ','Default Type of number without decimal is?','Long int',' Unsigned Long','Int','Unsigned Int','3',1),
(8,'MCQ','Select a convenient declaration and initialization of a floating point number:','float somevariable = 12.502D','float somevariable = (Double) 12.502D','float somevariable = (float) 12.502D','float somevariable = (Decimal)12.502D','3',1),
(9,'MCQ','Number of digits upto which precision value of float data type is valid?','Upto 6 digit','Upto 8 digit','Upto 9 digit','Upto 7 digit','4',1),
(10,'MCQ','Valid Size of float data type is?','10 Bytes','6 Bytes','4 Bytes','8 Bytes','3',1),
(11,'MCQ','The Default value of Boolean Data Type is?','0','true','false','1','3',1),
(12,'MCQ','Storage location used by computer memory to store data for usage by an application is?','Pointers','Constants','Variable','None of the mentioned','3',1),
(13,'MCQ',' What will be the output of the following C# code?int a,b;a = (b = 10) + 5;' ,'b = 10, a = 5','b = 15, a = 5','a = 15, b = 10','a = 10, b = 10','3',1),
(14,'MCQ','What will be the output of the following C# code?
static void Main(string[] args)
 {
     int a = 5;
     int b = 10;
     int c;
     Console.WriteLine(c = a-- - ++b);
     Console.WriteLine(b);
     Console.ReadLine();
 }','-7, 10','-5, 11','-6, 11','15, 11','3',1),
 (15,'MCQ','What will be the output of the following C# code?

 static void Main(string[] args)
 {
     string Name = "He is playing in a ground.";
     char[] characters = Name.ToCharArray();
     StringBuilder sb = new StringBuilder();
     for (int i = Name.Length - 1; i >= 0; --i)
     {
         sb.Append(characters[i]);
     }
     Console.Write(sb.ToString());
     Console.ReadLine(); 
 }','He is playing in a grou','.ground a in playing is He','.dnuorg a ni gniyalp si eH','He playing a','3',1),

 (16,'True&False','is C# an object-oriented programming language?','yes','no',null,null,'1',1),
 (17,'True&False','Is C++ an alias of C#?','yes','no',null,null,'2',1),
 (18,'True&False','Is C# a type safe programming language?','yes','no',null,null,'1',1),
 (19,'True&False','Is C# a structured programming language?','yes','no',null,null,'1',1),
 (20,'True&False','"Garbage collection automatically reclaims memory occupied by unreachable unused objects." – This statement is true or false in C#?','true','false',null,null,'1',1),
 (21,'True&False','Is C# programming language a case-sensitive?','yes','no',null,null,'1',1),
 (22,'True&False','What will be the output of the following C# code?

using System;

class Program {
  static void Main(string[] args) {
    Console.WriteLine(true ^ true);
  }
}','true','false',null,null,'2',1),
(23,'True&False','Comments are visible on the browsers window.
','true','false',null,null,'2',2),
(24,'True&False','<u> tag is used to mark the text italics.','true','false',null,null,'2',2),
(25,'True&False','<font> is has values from 1 to 10','true','false',null,null,'2',2)
,
(26,'Text',



















--------------------------------------------- insert into course -----------------------------

insert into Courses.[Course]([ID],[Name],[Description],[Min_Degree],[Max_Degree],[Instructor_ID])
values
(1,'C#','Learn Programming Language Using C#',100,200,1),
(2,'HTML','First Step in Web Development',50,100,2),
(3,'C','Learn Programming Language Using C ',100,200,3),
(4,'ASP.Net','Main Course of .Net Track',100,200,1)


---------------------------------------------insert into instructor ---------------------------
insert into [Members].[Instructor]([ID],[Name],[User_Name],[Password],[Manger_ID],[Role_type])
values
(2,'Mostafa','Mostafa123','00000',null,'Manager'),
(3,'Osama','Osama123','11111',2,'Instructor'),
(4,'Anas','Anas123','12345',2,'Instructor'),
(5,'Omar','Omar1212','1212',2,'Instructor')







--------------------------------------------insert into  Exam ---------------------------------

-- We should create exam first 

insert into [dbo].[Exam] ([ID],[Name],[Type],[Date],[total_degree],[year],[Instructor_ID],[Course_ID])
values (1,'C# Exam 1','Programming',getdate(),100,2023,1,1)




-------------------------------------------- insert into Question Exam -------------------------

insert into [dbo].[Question_Exam] 
values
(1,10,1),
(2,20,1),
(3,10,1),
(4,10,1),
(5,10,1)

------------------------------------------- insert into Question Exam pool ---------------------

insert into [dbo].[Question_Exam_Pool] ([Pool_ID],[Question_Exam_ID])
values 
(1,1),
(2,2),
(3,3),
(4,4),
(5,5)

 

-- خطوات 


insert into [Department].[Intake]
values 
(1,'Intake 1','2020-11-11','2021-11-11'),
(2,'Intake 2','2021-11-11','2022-11-11'),
(3,'Intake 3','2022-11-11','2023-11-11'),
(4,'Intake 4','2023-11-11','2024-11-11'),
(5,'Intake 5','2024-11-11','2025-11-11'),
(6,'Intake 6','2025-11-11','2026-11-11'),
(7,'Intake 7','2026-11-11','2027-11-11'),
(8,'Intake 8','2027-11-11','2028-11-11'),
(9,'Intake 9','2028-11-11','2029-11-11'),
(10,'Intake 10','2029-11-11','2030-11-11')






-------------------------------------------- insert into Student ---------------------------------


insert into Student 
values
(1,'Mohamed','Mohamed123','123456','Student','Elawamy st-Agamy-Alexandria',1),
(2,'Ahmed','Ahmed123','12345','Student','Elmandra Alex',1),
(3,'Osama','Osama123','1234','Student','20 Obour City',1),
(4,'Sayed','Sayed123','123','Student','28 Cairo St',1),
(5,'Atef','Atef123','123456789','Student','23Cairo',1),
(6,'Mariam','Mariam123','12345611','Student','24st',1),
(7,'Heba','Heba123','123456424','Student','Alexandria',1),
(8,'Nawal','Nawal123','123456423','Student','Taha Husien El Minya',1),
(9,'Ali','Ali123','1234564243','Student','New Cairo cairo',1),
(10,'Omar','Omar123','1234564383','Student','Abo Qeer Alex',1)



--------------------------------------------- insert into Student Course --------------------------

insert into [dbo].[Student_Course]
values 
(1,1),
(1,2),
(1,3),
(2,1),
(2,2),
(2,3),
(3,1),
(3,2),
(3,3)


----------------------------------------------- insert into Track ----------------------------------
alter table track
alter column name nvarchar(max)
 insert into Track
 values
 (1,' '),
 (),
 (),
 (),
 (),
 (),
 (),
 (),
 (),
 (),
 (),