use ExaminationSystem;

--	Four accounts are needed for the system, one admin account that perform admin tasks only, account for training manager, account for instructors and account for students.

--1 admin account that perform admin tasks
create login Dr_Ahmed with password ='123';
--associate Dr_Ahmed with our database
use ExaminationSystem;
create user Dr_Ahmed for login Dr_Ahmed;

--2 account for training manager
create login Eng_Mrihan with password ='123';
--associate the account with the database 
use ExaminationSystem;
create user Eng_Mrihan for login Eng_Mrihan;

--3 account for instructor.
create login Eng_sara with password ='123';
--associate the account with the database
use ExaminationSystem;
create user Eng_sara for login Eng_sara;

--4 account for test student 
create login student with password ='123';
--associate the account with the database
use ExaminationSystem;
create user student for login  student;