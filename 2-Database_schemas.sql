-- divide the database into three schema ( department Schema that has Track, Branch, Intake) , (Members Schema that has Student and Instructor ) and (courses schema has (Courses & Exams) Tables ).

--create department schema
use ExaminationSystem
create schema Department;

--transfer tables into department schema 
alter schema Department
transfer [dbo].[Department]

alter schema Department
transfer [dbo].[Branch]

alter schema Department
transfer [dbo].[Branch_Track]

alter schema Department
transfer [dbo].[Intake]

alter schema Department
transfer [dbo].[Intake_Track]

alter schema Department
transfer [dbo].[Track]

--create schema members 
create schema Members

--transfer tables int the new members schema 
alter schema Members
transfer [dbo].[Instructor]

alter schema Members
transfer [dbo].[Instructor_Department]

alter schema Members
transfer [dbo].[Instructor_Pool]

alter schema Members
transfer [dbo].[Student]

alter schema Members
transfer [dbo].[Student_Answer]

alter schema Members
transfer [dbo].[Student_Course]

alter schema Members
transfer [dbo].[Student_Exam]


--craete courses schema
create schema Courses

--add tables int courses schema
alter schema courses
transfer [dbo].[Course]

alter schema courses
transfer [dbo].[Exam]

alter schema courses
transfer [dbo].[Question_Exam]

alter schema courses
transfer [dbo].[Question_Exam_Pool]

alter schema courses
transfer [dbo].[Question_Pool]