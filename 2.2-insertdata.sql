use ExaminationSystem;

--insert into department table
insert into [Department].[Department]
values  (1,'Computer Science'),
		(2,'Information technology'),
		(3,'Computer Engineering'),
		(4,'Software Engineering'),
		(5,'Artificial Intelligence')

--insert into table of branch
insert into [Department].[Branch]
values  (1,'ITI-Smart Village',5),
		(2,'ITI-Minya',2),
		(3,'ITI-Sohag',4),
		(4,'ITI-Assuit',3),
		(5,'ITI-Menofia',1)

--insert into table of track
insert into [Department].[Track]
values  (1,'Web Development and Design'),
		(2,'Cybersecurity'),
		(3,'Data Science and Analytics'),
		(4,'Software Quality Assurance and Testing'),
		(5,'Mobile App Development'),
		(6,'Machine Learning'),
		(7,'Deep Learning'),
		(8,'Embedded Systems');

--insert into intake table 
insert into [Department].[Intake]
values  (1,'FullStack.Mern 23-24 Q1','2023/07/05','2023/11/05'),
		(2,'FullStack php 23-24 Q1','2023/07/05','2023/11/05'),
		(3,' FullStack Python 23-24 Q1','2023/07/05','2023/11/05'),
		(4,'Mopile Apllication 23-24 Q1','2023/07/05','2023/11/05'),
		(5,'Flluter 23-24 Q1','2023/07/05','2023/11/05');

--insert into branch track
insert into [Department].[Branch_Track]
values (1,7),(2,2),(5,3),(3,4),(4,8)

--insert into intake track
insert into [Department].[Intake_Track]
values (1,1),(2,1),(3,1),(4,2),(5,2)
