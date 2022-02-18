----------------------------------------------Insert Data------------------------------------------------
use Examination_System;
go
------Insert Data Into  Person.Students Table------
insert into Person.Students(StudentName,UserName,[Password])
values
 ('Azza','azza123@gmail.com','123')
,('Bebo','Bebo456@gmail.com','456')
,('Fady','Fady789@gmail.com','789'),
('Ali','Ali111@gmail.com','111'),
('mohammed','mohmmed222@gmail.com','222'),
('ahmed','Ahmed333@gmail.com','333'),
('Aya','Aya444@gmail.com','444'),
('Evon','Evon555@gmail.com','555'),
('Hager','Hager666@gmail.com','666'),
('Samah777','Samah777@gmail.com','777');

------Insert Data Into  into StudentData.Branch Table------
insert into StudentData.Branch(BranchName)
values('Minia')
,('Alex')
,('Minufiyah')
,('Assuit');


------Insert Data Into  into CourseData.Class Table------
insert into CourseData.Class (ClassName)
values('Lab1'),('Lab2'),('Lab3'),('Lab4'),('Lab5');

insert into Person.Instructor(SupervisorID,InstructorName,UserName,[Password])
values(null,'Sara','Sara1111','111'),
(1,'Sally','Sally22','222'),
(1,'Ahmed','AHmed33','333'),
(1,'Tony','Tony44','444');


insert into [CourseData].[Course] (CourseName,InstructorID,[Description],MinDegree,MaxDegree)
values('Js',2,'Js',20,40),
('ES6',1,'ES6',40,80),
('JSNEXT',3,'JSNEXT',30,60),
('Html',1,'html',25,50),
('CSS',2,'css',15,30);


insert into StudentData.Department(DeptName)
values('Computer Science'),('Infromation System'),('MultiMedia');

insert into StudentData.Track(TrackName)
values('Full Stack .NET'),(' Full Stack PHP'),('ui/ux'),('Front end');

insert into StudentData.Intake(IntakeName)
values ('Q1'),('Q2'),('Q3'),('Q4');

insert into StudentData.DIBT
(DeptID_FK,IntakeID_FK,BranchID_FK,TrackID_FK,CourseID_FK,StudentID_FK,ClassID_FK)
values(2,3,4,1,3,1,2),(3,2,2,2,3,2,1),(1,4,3,4,2,6,5),(2,1,4,3,1,7,4);

insert into CourseData.TeachingInfo (CourseID_FK,InstructorID_FK,ClassID_FK,[Year])
values (2,4,1,2022),(3,2,2,2021)



  insert into Exam.ExamInfo (CourseID_FK,ExamDate,StartTime,endTime,IsCorrective,ExamTotalGrade)
  values(2,'2021-01-22','09:00:00','12:00:00',0,50),
  (5,'2021-01-22','08:00:00','10:00:00',1,100)