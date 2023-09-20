
use ExaminationSystem
-----------------------------------------------------------------------------------------------------------
create database ExaminationSystem
on primary
(
Name = 'Examination System File1',
filename ='C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\Examination System File1.mdf',
	Size = 8MB,
	Maxsize = unlimited,
	filegrowth = 8MB
),
filegroup secondary
(
Name = 'Examination System File2',
filename ='C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\Examination System File2.ndf',
	Size = 8MB,
	Maxsize = unlimited,
	filegrowth = 8MB
)
log on
(
	
Name = 'Examination System Log File',
filename ='C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\Examination System Log File.ldf',
	Size = 8MB,
	Maxsize = unlimited,
	filegrowth = 8MB
)

------------------------------------------ Create Tables ----------------------------------------

create table Instructor --done  
( 
	ID int ,
	Name varchar(70) not null,
	User_Name nvarchar(50) not null,
	Password nvarchar(50) not null,
	Manger_ID int ,
	Role_type nvarchar(50) not null
	constraint Instructor_PK primary key (ID)
	constraint Instructor_Role_Type_Check check (Role_type in ('Instructor','Manager'))
)



create table Student --done
(
	ID int ,
	Name varchar(70) not null,
	User_Name nvarchar(50) not null,
	Password nvarchar(50) not null,
	Role_type nvarchar(50)  default 'Student' ,
	Address nvarchar(Max) ,
	Intake_ID int not null
	constraint Student_PK primary key (ID),
	constraint Student_Intake_FK foreign key (Intake_ID) references Intake(ID) on delete cascade on update cascade
)

create table Department --done
(
	ID int  ,
	Name nvarchar(50) not null
	constraint Department_PK primary key (ID)
)


create table Branch --done
(
	ID int ,
	Name nvarchar(50) not null,
	Department_ID int 
	constraint Branch_PK primary key (ID)
	constraint Branch_Department_FK foreign key (Department_ID) references Department(ID) on delete cascade on update cascade
)

create table Track --done
( 
	ID int ,
	name nvarchar(50) not null
	constraint Track_PK primary key (ID)
)

create table Intake --done 
(
	ID int ,
	Name nvarchar(50) not null,
	Start_Date date ,
	End_Date date
	constraint Intake_PK primary key (ID)
)

create table Course  --done
(
	ID int ,
	Name nvarchar(50) not null,
	Description nvarchar(50),
	Min_Degree int not null ,
	Max_Degree int not null ,
	Instructor_ID int 
	constraint Course_PK primary key (ID)
	constraint Course_Instructor_FK  foreign key (Instructor_ID)  references Instructor(ID) on delete cascade on update cascade
)

create table Exam --done 
(
	ID int  ,
	Name nvarchar(50)not null,
	Type nvarchar(50)not null,
	[Date] Date,
	total_degree int ,
	year int ,
	Allowance_Option nvarchar(50)  ,
	Instructor_ID int ,
	Course_ID int 

	constraint Exam_PK primary key (ID),
	constraint Exam_Instructor_FK foreign key (Instructor_ID) references Instructor(ID)on delete cascade on update cascade,
	constraint Exam_Course_FK foreign key (Course_ID) references Course(id)on delete cascade on update cascade
)
create table Student_Answer--done 
(
	Exam_ID int ,
	Student_ID int ,
	Pool_Question_ID int ,
	Answer nvarchar(max),
	Score int ,
	constraint Student_Answer_PK primary key (Pool_Question_ID),
	constraint Student_Answer_Pool_Question_FK foreign key (Pool_Question_ID) references Question_Pool(ID) on delete cascade on update cascade,
	constraint Student_Answer_Student_Exam_FK foreign key (Exam_ID,Student_ID) references Student_Exam(Exam_ID,Student_ID) on delete cascade on update cascade
)
 
create table Question_Exam --done
(
	ID int ,
	question_degree int not null ,
	Exam_ID int 
	constraint Question_Exam_PK primary key (ID),
	constraint Question_Exam_Exam_FK foreign key (Exam_ID) references Exam(ID)on delete cascade on update cascade
)

create table Question_Pool --done
(
	ID int ,
	Course_ID int ,
	Question_Type nvarchar(50) not null,
	Text nvarchar(max) not null,
	Choice_1 nvarchar(max),
	Choice_2 nvarchar(max),
	Choice_3 nvarchar(max),
	Choice_4 nvarchar(max),
	Answer nvarchar(max) not null
	constraint Question_Pool_PK primary key (ID),
	constraint Question_Type_Check check (Question_Type in ('MCQ','True&False','Text')),
	constraint Course_Pool_Course_FK foreign key (Course_ID) references Course(ID)on delete cascade on update cascade
)

-------------------------------------------- Many to Many Relationships ------------------------------------
create table Instructor_Department --done
(
	Instructor_ID int ,
	Department_ID int ,
	Manger_ID int,
	constraint Instructor_Department_PK primary key (Instructor_ID,Department_ID),
	constraint Instructor_Department_Instructor_FK foreign key (Instructor_ID) references Instructor(ID)on delete cascade on update cascade,
	constraint Instructor_Department_Department_FK foreign key (Department_ID) references Department(ID)on delete cascade on update cascade,
)

create table Instructor_Pool --done
(
	Instructor_ID int ,
	Pool_ID int 
	constraint Instructor_Pool_PK primary key (Instructor_ID,Pool_ID),
	constraint Instructor_Pool_Instructor foreign key (Instructor_ID) references Instructor(ID)on delete cascade on update cascade,
	constraint Instructor_Pool_Pool foreign key (Pool_ID) references Question_Pool(ID)on delete cascade on update cascade
)
create table Student_Course --done
(
	Student_ID int ,
	Course_ID int 
	constraint Student_Course_PK primary key (Student_ID,Course_ID),
	constraint Student_Course_Student_FK foreign key (Student_ID) references Student(ID)on delete cascade on update cascade,
	constraint Student_Course_Course_FK foreign key (Course_ID) references Course(ID)on delete cascade on update cascade,
)

create table Student_Answer_Pool --done
(
	Pool_ID int,
	Student_Answer_ID int 
	constraint Student_Answer_Pool_PK primary key (Pool_ID,Student_Answer_ID),
	constraint Student_Answer_Pool_pool_FK foreign key (Pool_ID) references Question_Pool(ID),
	constraint Student_Answer_Pool_Student_Answer_FK foreign key (Student_Answer_ID) references Student_Answer(Pool_Question_ID) 

)
create table Question_Exam_Pool	--done	
(
	Pool_ID int,
	Question_Exam_ID int 
	constraint Question_Exam_Pool_PK primary key (Pool_ID,Question_Exam_ID),
	constraint Question_Exam_Pool_Pool_FK foreign key (Pool_ID) references Question_Pool(ID)on delete cascade on update cascade,
	constraint Question_Exam_Pool_Question_Exam_FK foreign key (Question_Exam_ID) references Question_Exam(ID)on delete cascade on update cascade,
)

create table Branch_Track --done
(
	Branch_ID int ,
	Track_ID int 
	constraint Branch_Track_PK primary key (Branch_ID,Track_ID),
	constraint Branch_Track_Branch_FK foreign key (Branch_ID) references Branch(ID)on delete cascade on update cascade,
	constraint Branch_Track_Track_FK foreign key (Track_ID) references Track(ID)on delete cascade on update cascade
)

create table Intake_Track --done 
(
	Intake_ID int ,
	Track_ID int 
	constraint Intake_Track_PK primary key (Intake_ID,Track_ID),
	constraint Intake_Track_Track_FK foreign key (Track_ID) references Track(ID)on delete cascade on update cascade,
	constraint Branch_Track_Intake_FK foreign key (Intake_ID) references Intake(ID)on delete cascade on update cascade
)

create table Student_Exam --done 
(
	Exam_ID int ,
	Student_ID int ,
	Start_Time time ,
	End_Time time ,
	Final_Result int 
	constraint Student_Exam_PK primary key (Exam_ID,Student_ID),
	constraint Student_Exam_Exam_FK foreign key (Exam_ID) references Exam(ID)on delete cascade on update cascade,
	constraint Student_Exam_Student_FK foreign key (Student_ID) references Student(ID)on delete cascade on update cascade
)
----------------------------------------- End Of Creation -----------------------------------------







