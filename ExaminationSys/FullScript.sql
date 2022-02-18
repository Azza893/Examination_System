-------------------------------------------------------------------------------------------------------------
----------------------------------------------Create Database------------------------------------------------
----------------------------------------------With file Groups-----------------------------------------------

use master
go
CREATE DATABASE Examination_System
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'ExaminationSys_Data', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\Examination_System_Data.mdf' ,	size=10MB, maxsize=unlimited, FILEGROWTH = 10 ), 
 FILEGROUP [SECONDARY] 
( NAME = N'ExaminationSys', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\ExaminationSys.ndf' , SIZE = 3072KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'ExaminationSys_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\Examination_System_Log.ldf' , size=10MB, maxsize=unlimited, FILEGROWTH = 10 )
go

go
/* begin use Examination_System Database */
use Examination_System;
----------------------------------------------Create Tables------------------------------------------------
go
------Creating Student Table------
create table Students
(
studentID int not null identity(1,1),
StudentName nvarchar(50) not null,
UserName nvarchar(50) not null unique,
[Password] nvarchar(20) not null,
IsDeleted bit not null default 0
constraint studentID_PK primary key(studentID)
);
------Creating TrueOrFalse Table------
create table TrueOrFalse
(
TrueOrFalseID int not null identity(1,1),
Content nvarchar(400) not null unique,
CorrectAnswer varchar(5) not null,
CourseID_FK INT not null,IsDeleted bit not null default 0
constraint TFQID_PK primary key(TrueOrFalseID)
);
------Creating MCQ Table------
create table MCQ
(
MCQID int not null identity(1,1),
Content nvarchar(400) not null unique,
CorrectAnswer char(1) not null,
Option1  Nvarchar(max) not null,
Option2  Nvarchar(max) not null,
Option3  Nvarchar(max) not null,
CourseID_FK INT not null,
IsDeleted bit not null default 0
constraint MCQID_PK primary key(MCQID)
);
------Creating TextQ Table------
create table TextQ
(
TextQID int not null identity(1,1),
Content nvarchar(400) not null unique,
CorrectAnswer nvarchar(MAX) not null,
CourseID_FK INT not null,
IsDeleted bit not null default 0,
constraint TextQID_PK primary key(TextQID)
);
------Creating Intake Table------
create table Intake
(
IntakeID int not null identity(1,1) ,
IntakeName nvarchar(225) not null,
IsDeleted bit not null default 0
constraint IntakeID_PK primary key(IntakeID)
);
------Creating Track Table------
Create table Track
(
TrackID int not null identity(1,1),
TrackName nvarchar(40) not null ,
IsDeleted bit not null default 0
constraint TrackID_PK primary key(TrackID)
);
------Creating Branch Table------
create table Branch
(
BranchID int not null identity(1,1) ,
BranchName nvarchar(225),
IsDeleted bit not null default 0
constraint BranchID_PK primary key (BranchID)
);
------Creating Department Table------
create table Department
(
DeptID int not null identity(1,1),
DeptName nvarchar(225),
IsDeleted bit not null default 0
constraint DeptID_PK primary key (DeptID)
);

------Creating Class Table------
create table Class
(
ClassID int not null  identity(1,1),
ClassName nvarchar(50),
IsDeleted bit not null default 0
constraint ClassID_PK primary key (ClassID)
);
------Creating Instructor Table------
create table Instructor
(
InstructorID int not null primary key identity(1,1),
SupervisorID int,
InstructorName nvarchar(30) not null,
UserName nvarchar(50) not null unique,
[Password] nvarchar(50) not null,
IsDeleted bit not null default 0
constraint Manager_FK FOREIGN KEY(SupervisorID)
REFERENCES Instructor(InstructorID)
);
------Creating Course Table------
create table Course
(
CourseID int not null identity(1,1) ,
InstructorID int not null,
CourseName nvarchar(30) not null,
[Description] nvarchar(max) not null,
MinDegree int not null ,
MaxDegree int not null,
IsDeleted bit not null default 0
constraint CourseID_PK primary key(CourseID)
constraint InstructorID_FK FOREIGN KEY(InstructorID)
REFERENCES Instructor(InstructorID)
);
------Creating MCQ Table------
Alter table MCQ
add constraint CourseID_MCQ_FK FOREIGN KEY (CourseID_FK)
REFERENCES Course(CourseID)
Alter table TextQ
add constraint CourseID_TextQ_FK FOREIGN KEY (CourseID_FK)
REFERENCES Course(CourseID)
Alter table TrueOrFalse
add constraint CourseID_TrueOrFalse_FK FOREIGN KEY (CourseID_FK)
REFERENCES Course(CourseID)
------Creating QuestionPool Table------
Create table QuestionPool
(
QuestionID int not null identity(1,1) primary key,
MCQID_FK INT ,
TrueOrFalse_FK INT,
TextQ_FK INT,
Exam_FK int,
QType nvarchar(5) CHECK (QType in ('MCQ','TXT','TOF')) not null,
IsDeleted bit not null default 0
constraint TextID_FK FOREIGN KEY(TextQ_FK)
REFERENCES TextQ(TextQID)
);
Alter table QuestionPool
add constraint TrueOrFalseID_FK FOREIGN KEY(TrueOrFalse_FK)
REFERENCES [TrueOrFalse](TrueOrFalseID);
Alter table QuestionPool
add constraint MCQID_FK FOREIGN KEY(MCQID_FK)
REFERENCES MCQ(MCQID);
------Creating ExamInfo Table------
Create table ExamInfo
(
ExamID int  identity(1,1) primary key,
CourseID_FK int ,
ExamDate date not null,
StartTime time not null,
endTime time not null,
IsCorrective bit not null default 0,
ExamTotalGrade int not null,
IsDeleted bit not null default 0
constraint CourseID_ExamInfo_FK FOREIGN KEY (CourseID_FK)
REFERENCES Course(CourseID)
);
------Creating TeachingInfo Table------
create table TeachingInfo
(
TeachingID int not null primary key identity(1,1),
CourseID_FK int not null,
InstructorID_FK int not null,
ClassID_FK int not null,
[Year] int not null,
IsDeleted bit not null default 0
);
Alter table QuestionPool
add constraint ExamID_QuestionPool_FK FOREIGN KEY(Exam_FK)
REFERENCES ExamInfo(ExamID);
Alter table TeachingInfo
ADD constraint CourseID_TeachingInfo_FK FOREIGN KEY (CourseID_FK)
REFERENCES Course(CourseID)
Alter table TeachingInfo
ADD constraint InstructorID_TeachingInfo_FK FOREIGN KEY (InstructorID_FK)
REFERENCES [dbo].[Instructor] (InstructorID)
Alter table TeachingInfo
ADD constraint ClassID_TeachingInfo_FK FOREIGN KEY (ClassID_FK)
REFERENCES [dbo].[Class] (ClassID)
------Creating StudentAnswer Table------
create table StudentAnswer
(
AnswerID int not null primary key identity(1,1),
ExamID_FK int not null,
StudentID_FK int not null,
QuestionID_FK int not null,
AnsContent nvarchar(max) ,
QuestionGrade int not null,
AnsGrade int ,
IsDeleted bit not null default 0
);
Alter table StudentAnswer
ADD constraint ExamID_StudentAnswer_FK FOREIGN KEY (ExamID_FK)
REFERENCES [dbo].[ExamInfo] (ExamID)

Alter table StudentAnswer
ADD constraint StudentID_StudentAnswer_FK FOREIGN KEY (StudentID_FK)
REFERENCES [Students] (studentID)

Alter table StudentAnswer
ADD constraint QuestionID_StudentAnswer_FK FOREIGN KEY (QuestionID_FK)
REFERENCES [dbo].[QuestionPool] ([QuestionID])

------Creating Department Intake Branch Track (DIBT) Table------
CREATE TABLE DIBT(
DIBTID INT  primary key IDENTITY(1,1),
DeptID_FK int not null FOREIGN KEY REFERENCES [dbo].[Department] (DeptID),
IntakeID_FK int not null FOREIGN KEY REFERENCES [dbo].[Intake] (IntakeID),
BranchID_FK int not null FOREIGN KEY REFERENCES [dbo].[Branch] (BranchID),
TrackID_FK int not null FOREIGN KEY REFERENCES [dbo].[Track] (TrackID),
CourseID_FK int not null FOREIGN KEY REFERENCES [dbo].[Course] (CourseID),
StudentID_FK int not null FOREIGN KEY REFERENCES [dbo].[Students] (StudentID),
ClassID_FK int not null FOREIGN KEY REFERENCES [dbo].[Class] (ClassID),
IsDeleted bit not null default 0
);
go

----------------------------------------------Create Schema------------------------------------------------

CREATE SCHEMA CourseData
go
ALTER SCHEMA CourseData 
    TRANSFER [dbo].[Class];

ALTER SCHEMA CourseData 
    TRANSFER [dbo].[Course];

ALTER SCHEMA CourseData 
    TRANSFER [dbo].[TeachingInfo];

go
CREATE SCHEMA Exam
go
ALTER SCHEMA Exam 
    TRANSFER [dbo].[ExamInfo];
  
ALTER SCHEMA Exam 
    TRANSFER [dbo].[StudentAnswer];
	go
CREATE SCHEMA Person
go
ALTER SCHEMA Person 
    TRANSFER [dbo].[Instructor];

ALTER SCHEMA Person 
    TRANSFER [dbo].[Students];
	go
CREATE SCHEMA Question
go
ALTER SCHEMA Question 
    TRANSFER [dbo].[QuestionPool];

ALTER SCHEMA Question 
    TRANSFER [dbo].[TextQ];

ALTER SCHEMA Question 
    TRANSFER [dbo].[MCQ];
  
ALTER SCHEMA Question 
    TRANSFER [dbo].[TrueOrFalse];
	go
CREATE SCHEMA StudentData
go
ALTER SCHEMA StudentData 
    TRANSFER [dbo].[Branch];
  
ALTER SCHEMA StudentData 
    TRANSFER [dbo].[Department];
  
ALTER SCHEMA StudentData 
    TRANSFER [dbo].[DIBT];
  
ALTER SCHEMA StudentData 
    TRANSFER [dbo].[Intake];
  
ALTER SCHEMA StudentData 
    TRANSFER [dbo].[Track];

	----------------------------------------------Create Triggers------------------------------------------------

go
create trigger SoftDeleteClass 
on  [CourseData].[Class]
instead of delete
as 
begin
	 update [CourseData].[Class]
	 set IsDeleted=1
 where [ClassID] = (select [ClassID] from deleted);
end
go
-------------------------------------

create trigger SoftDeleteCourse 
on  [CourseData].[Course]
instead of delete
as 
begin
	 update [CourseData].[Course]
	 set IsDeleted=1
 where [CourseID] = (select [CourseID] from deleted);
end
go
-------------------------------------

create trigger SoftDeleteTeachingInfo
on  [CourseData].[TeachingInfo]
instead of delete
as 
begin
	 update [CourseData].[TeachingInfo]
	 set IsDeleted=1
 where [TeachingID] = (select [TeachingID] from deleted);
end
go
-------------------------------------

create trigger SoftDeleteExamInfo
on  [Exam].[ExamInfo]
instead of delete
as 
begin
	 update [Exam].[ExamInfo]
	 set IsDeleted=1
 where [ExamID] = (select [ExamID] from deleted);
end
go
-----------------------------------------

create trigger SoftDeleteStudentAnswer
on  [Exam].[StudentAnswer]
instead of delete
as 
begin
	 update [Exam].[StudentAnswer]
	 set IsDeleted=1
 where [AnswerID] = (select [AnswerID] from deleted);
end
go
----------------------------------------

create trigger SoftDeleteInstructor
on  [Person].[Instructor]
instead of delete
as 
begin
	 update [Person].[Instructor]
	 set IsDeleted=1
 where [InstructorID] = (select [InstructorID] from deleted);
end
go
-------------------------------------

create trigger SoftDeleteStudent
on  [Person].[Students]
instead of delete
as 
begin
	 update [Person].[Students]
	 set IsDeleted=1
 where [StudentID] = (select [StudentID] from deleted);
end
go
---------------------------------

create trigger SoftDeleteMCQ
on  [Question].[MCQ]
instead of delete
as 
begin
	 update [Question].[MCQ]
	 set IsDeleted=1
 where [MCQID] = (select [MCQID] from deleted);
end
go
-----------------------------------

create trigger SoftDeleteQuestionPool
on  [Question].[QuestionPool]
instead of delete
as 
begin
	 update [Question].[QuestionPool]
	 set IsDeleted=1
 where [QuestionID] = (select [QuestionID] from deleted);
end
go
-----------------------------------------

create trigger SoftDeleteTextQ
on  [Question].[TextQ]
instead of delete
as 
begin
	 update [Question].[TextQ]
	 set IsDeleted=1
 where [TextQID]= (select [TextQID] from deleted);
end
go
---------------------------------------

create trigger SoftDeleteTrueOrFalse
on  [Question].[TrueOrFalse]
instead of delete
as 
begin
	 update [Question].[TrueOrFalse]
	 set IsDeleted=1
 where [TrueOrFalseID] = (select [TrueOrFalseID] from deleted);
end
go
-------------------------------------------
create trigger SoftDeleteBranch 
on  [StudentData].[Branch]
instead of delete
as 
begin
	 update [StudentData].[Branch]
	 set IsDeleted=1
 where [BranchID] = (select [BranchID] from deleted);
end
go
-----------------------------------------------

create trigger SoftDeleteDepartment
on  [StudentData].[Department]
instead of delete
as 
begin
	 update [StudentData].[Department]
	 set IsDeleted=1
 where [DeptID] = (select [DeptID] from deleted);
end
go
---------------------------------------------------

create trigger SoftDeleteDIBT
on  [StudentData].[DIBT]
instead of delete
as 
begin
	 update [StudentData].[DIBT]
	 set IsDeleted=1
 where [DIBTID] = (select [DIBTID] from deleted);
end
go
----------------------------------------------------

create trigger SoftDeleteIntake
on  [StudentData].[Intake]
instead of delete
as 
begin
	 update [StudentData].[Intake]
	 set IsDeleted=1
 where [IntakeID] = (select [IntakeID] from deleted);
end
go
---------------------------------------------------

create trigger SoftDeleteTrack
on  [StudentData].[Track]
instead of delete
as 
begin
	 update [StudentData].[Track]
	 set IsDeleted=1
 where [TrackID] = (select [TrackID] from deleted);
end



go
	----------------------------------------------Insert Data------------------------------------------------
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

  insert into Exam.StudentAnswer(ExamID_FK,StudentID_FK,QuestionID_FK,AnsContent,QuestionGrade,AnsGrade)
  values (1,6,1,'A',5,0),(1,6,2,'A',5,0)
	----------------------------------------------Create Views------------------------------------------------
	go
create view  ShowAllCourses
with SchemaBinding
as

	select cr.CourseName as course ,i.InstructorName instructorName,
	t.TrackName as track,cl.ClassName as class,b.BranchName as branch
	from CourseData.Course cr,Person.Instructor i,StudentData.Track t,CourseData.Class cl,
	StudentData.Branch b,
	CourseData.TeachingInfo cty,
	StudentData.DIBT 
	where
	cr.CourseID=cty.CourseID_FK and
	cr.IsDeleted=0 and
	cl.ClassID=cty.ClassID_FK and
	i.InstructorID=cty.InstructorID_FK and
	DIBT.CourseID_FK=cr.CourseID and
	DIBT.TrackID_FK=t.TrackID and
	DIBT.BranchID_FK=b.BranchID

--select * from ShowAllCourses
go

--create unique clustered index showCourses_inx
--on ShowAllCourses(course);
--go

-------View contain details about Department-----
Create View DetailsAboutDepartment


AS

		select d.DeptName as NameOfDepartment,t.TrackName as NameOfTrack ,b.BranchName as NameOfBranch
		from StudentData.Department d, StudentData.Track t,StudentData.Branch b ,StudentData.DIBT x
		where x.BranchID_FK=b.BranchID and x.DeptID_FK=d.DeptID and x.TrackID_FK=t.TrackID
		
		go
--select * from DetailsAboutDepartment


-----View contain details about Instructor-----
create  VIEW DetailsInstructor
with schemaBinding
AS

select ins.InstructorName as InstructorName,c.CourseName as CourseTitle
from Person.Instructor ins,CourseData.TeachingInfo cty,CourseData.Course c
where ins.InstructorID=cty.InstructorID_FK and c.CourseID=cty.CourseID_FK
go
create unique clustered index DetailsInstructor_inx
on DetailsInstructor(InstructorName,CourseTitle);
go

--select * from DetailsInstructor



	----------------------------------------------Create Functions------------------------------------------------

create function CourseData.AvailableCourses() 
returns @AvailableCourses table
  (
   CourseTitle nvarchar(50),
   InstructorName nvarchar(50),
   TrackName  nvarchar(50),
   ClassNumber nvarchar(50),
   BranchName nvarchar(50)
   )
as
begin
  insert into @AvailableCourses
  select cr.CourseName ,i.InstructorName ,
	t.TrackName,cl.ClassName,b.BranchName as branch
	from 	CourseData.Course cr,Person.Instructor i,StudentData.Track t,CourseData.Class cl,
StudentData.Branch b,
CourseData.TeachingInfo cty,
StudentData.DIBT where
	cr.CourseID=cty.CourseID_FK and
	cr.IsDeleted=0 and
	cl.ClassID=cty.ClassID_FK and
	i.InstructorID=cty.InstructorID_FK and
	DIBT.CourseID_FK=cr.CourseID and
	DIBT.TrackID_FK=t.TrackID and
	DIBT.BranchID_FK=b.BranchID
return
end
go
--SELECT * FROM CourseData.AvailableCourses();

----------------------------

create function Person.ShowInstructors(@UserName nvarchar(50)) 
returns @ShowInstructors table
		(
		 ID int  primary key,
		Name nvarchar(50),
		UserName nvarchar(50)
		)
as
begin
	insert into @ShowInstructors
	select InstructorID,InstructorName,UserName
	from Person.Instructor 
	where UserName=@UserName and IsDeleted=0

return
end
go
--select * from Person.ShowInstructors('Sally22')

--------------------------------------

Create function Person.ShowManagers() 
returns @ShowManagers table
		(
		 ID int primary key,
		Name nvarchar(50),
		UserName nvarchar(50)
		)
as
begin
	insert into @ShowManagers
	select InstructorID,InstructorName,UserName
	from Person.Instructor 
	where SupervisorID IS NULL

return
end
go
--select * from Person.ShowManagers() 
----------------------------------

Create function Question.ShowMCQQuestions(@TitleCourse nvarchar(50)) 
returns @ShowMCQQuestions table
		(
		 ID int,
		Content nvarchar(max),
		CorrectChoice char(1),
		Choice1 nvarchar(max),
		Choice2 nvarchar(max),
		Choice3 nvarchar(max)
		)
as
begin
	insert into @ShowMCQQuestions
	select m.MCQID ,m.Content,m.CorrectAnswer,m.Option1,m.Option2,m.Option3
	from Question.MCQ m
	where m.CourseID_FK in
	(
	   select c.CourseID
	   from CourseData.Course c
	   where CourseName=@TitleCourse and c.CourseID=m.CourseID_FK
	)

return
end
go
--select * from Question.ShowMCQQuestions('ES6')
--------------------------------------------


Create function Question.ShowTextQuestions(@TitleCourse nvarchar(50)) 
returns @ShowTextQuestions table
		(
		 ID int,
		Content nvarchar(max),
		BestAnswer nvarchar(max)
		)
as
begin
	insert into @ShowTextQuestions
	select txt.TextQID,txt.Content,txt.CorrectAnswer
	from Question.TextQ txt
	where txt.CourseID_FK in
	(
	   select c.CourseID
	   from CourseData.Course c
	   where CourseName=@TitleCourse and c.CourseID=txt.CourseID_FK
	)

return
end
go
--select * from Question.ShowTextQuestions('ES6')

------------------------------------------

Create function Question.ShowTFQuestions(@TitleCourse nvarchar(50)) 
returns @ShowTFQuestions table
		(
		 ID int,
		Content nvarchar(max),
		CorrectAnswer nvarchar(5)
		)
as
begin
	insert into @ShowTFQuestions
	select TF.TrueOrFalseID,TF.Content,TF.CorrectAnswer
	from Question.TrueOrFalse TF
	where TF.CourseID_FK in
	(
	   select c.CourseID
	   from CourseData.Course c
	   where CourseName=@TitleCourse and c.CourseID=TF.CourseID_FK
	)

return
end
go
--select * from Question.ShowTFQuestions('ES6')

	----------------------------------------------Create Stored proc------------------------------------------------
	
	-----SP to edit MCQ Questions-----
create proc Question.SP_EditMCQ (@MCQID int = 0 ,@MCQContent nvarchar(max), @MCQCorrectAnswer char(1),@MCQOption1 nvarchar(max),@MCQOption2 nvarchar(max),@MCQOption3 nvarchar(max),@MCQCourseID_FK int, @Action nvarchar(6),@MCQIsDeleted bit = 0)
as
begin
begin TRY  
    if @Action = 'Insert'
	begin
		insert into Question.MCQ (Content, CorrectAnswer, Option1, Option2, Option3,CourseID_FK  )
		values (@MCQContent,@MCQCorrectAnswer,@MCQOption1,@MCQOption2,@MCQOption3,@MCQCourseID_FK)
	end

	if @Action = 'Update'
	begin
		update Question.MCQ
		set
			Content = @MCQContent
			,CorrectAnswer = @MCQCorrectAnswer
			, Option1 = @MCQOption1
			, Option2 = @MCQOption2
			, Option3 = @MCQOption3
		where MCQID = @MCQID 
		end

	else if @Action = 'Delete'
		begin
			delete from Question.MCQ
			where MCQID = @MCQID
		end
end TRY  
begin catch  
   print 'Enter valid data'
end catch ; 
end
go
--exec Question.SP_EditMCQ  @MCQContent='Shrboco isss data set', @MCQCorrectAnswer='C', @MCQOption1='DataBase',@MCQOption2= 'Ali', @MCQOption3='Esraa',@MCQCourseID_FK= 3 ,@Action = 'Insert';
--exec Question.SP_EditMCQ @MCQID= 2 , @MCQContent='What is data set', @MCQCorrectAnswer='C', @MCQOption1='DataBase',@MCQOption2= 'walaa', @MCQOption3='Esraa',@MCQCourseID_FK= 3 ,@Action = 'Update';


	-----SP to edit True of False Questions-----
create proc Question.SP_EditTrueOrFalse (@TOFID int = 0 ,@TOFContent nvarchar(max), @TOFCorrectAnswer nvarchar(max),@TOFCourseID_FK int, @Action nvarchar(6),@TOFIsDeleted bit = 0)
as
begin
begin TRY
	if @Action = 'Insert'
	begin
		insert into Question.TrueOrFalse (Content, CorrectAnswer,CourseID_FK)
		values (@TOFContent,@TOFCorrectAnswer,@TOFCourseID_FK)
	end

	if @Action = 'Update'
	begin
		update Question.TrueOrFalse
		set
			Content = @TOFContent
			,CorrectAnswer = @TOFCorrectAnswer
		where TrueOrFalseID = @TOFID
		end

	else if @Action = 'Delete'
		begin
			delete from Question.TrueOrFalse
			where TrueOrFalseID = @TOFID
		end
		end TRY  
begin catch 
     print 'Enter valid data'
end catch;
end
go
--exec Question.SP_EditTrueOrFalse  @TOFContent='is thaaaaat true?', @TOFCorrectAnswer='True',@TOFCourseID_FK= 3 ,@Action = 'Insert';
--exec Question.SP_EditTrueOrFalse  @TOFID = 1, @TOFContent='is that true?', @TOFCorrectAnswer='False',@TOFCourseID_FK= 3 ,@Action = 'Update';

	-----SP to edit Text Questions-----
create proc Question.SP_EditTextQ (@TXTID int = 0 ,@TXTContent nvarchar(max), @TXTCorrectAnswer nvarchar(max),@TXTCourseID_FK int, @Action nvarchar(6),@TXTIsDeleted bit = 0)
as
begin
begin TRY  
	if @Action = 'Insert'
	begin
		insert into Question.TextQ (Content, CorrectAnswer,CourseID_FK)
		values (@TXTContent,@TXTCorrectAnswer,@TXTCourseID_FK)
	end

	if @Action = 'Update'
	begin
		update Question.TextQ
		set
			Content = @TXTContent
			,CorrectAnswer = @TXTCorrectAnswer
		where TextQID = @TXTID
		end

	else if @Action = 'Delete'
		begin
			delete from Question.TextQ
			where TextQID = @TXTID
		end
		end TRY  
begin catch 
     print 'Enter valid data'
end catch;
end
go

--exec Question.SP_EditTextQ  @TXTContent='is that true?', @TXTCorrectAnswer='',@TXTCourseID_FK= 3 ,@Action = 'Insert';
--exec Question.SP_EditTextQ  @TXTID = 2, @TXTContent='is that true?!?', @TXTCorrectAnswer='False',@TXTCourseID_FK= 3 ,@Action = 'Update';

create proc Question.SP_EditQuestionPool (@ID int,@InstructorName nvarchar(50),@content nvarchar(max),@CorrectAnswer nvarchar(5),@CorrectChoice char(1),@Choice1 nvarchar(max),@Choice2 nvarchar(max),@Choice3 nvarchar(10),@TypeOfQuestion nvarchar(20) = '',@TxtAnswer nvarchar(max) ,@StatmentType nvarchar(20) = '')
as
begin
    declare @CourseID as int ,@InstructorID as int;
	set @InstructorID=(select top 1 InstructorID from Person.[Instructor] where InstructorName=@InstructorName )
	set @CourseID=(select top 1 c.CourseID from CourseData.[Course] c where InstructorID=@InstructorID )
	if @TypeOfQuestion = 'MCQ'  
        begin  
            exec Question.SP_EditMCQ @MCQID = @ID,@MCQContent=@content, @MCQCorrectAnswer=@CorrectChoice, @MCQOption1=@Choice1,@MCQOption2= @Choice2, @MCQOption3=@Choice3,@MCQCourseID_FK= @CourseID ,@Action = @StatmentType;

        end

	if @TypeOfQuestion = 'TOF'
        begin  
          exec Question.SP_EditTrueOrFalse @TOFID = @ID ,@TOFContent=@content, @TOFCorrectAnswer=@CorrectAnswer,@TOFCourseID_FK= @CourseID ,@Action = @StatmentType; 

        end
	if @TypeOfQuestion = 'TXT'  
        begin  
            exec Question.SP_EditTextQ @TXTID=@ID, @TXTContent=@content, @TXTCorrectAnswer=@TxtAnswer,@TXTCourseID_FK= @CourseID ,@Action = @StatmentType;      
        end	
end

go
-----------Insert TOF Questions-----------
exec Question.SP_EditQuestionPool @ID=0, @InstructorName = 'Tony',@content= 'Conductors have low resistance.',@CorrectChoice = '',@CorrectAnswer = 'True' ,@Choice1 ='',@Choice2 ='',@Choice3 ='',@TypeOfQuestion= 'TOF',@TxtAnswer ='',@StatmentType = 'Insert'
go
exec Question.SP_EditQuestionPool @ID=0, @InstructorName = 'Ahmed',@content= 'Sharks are mammals.',@CorrectChoice = '',@CorrectAnswer = 'False' ,@Choice1 ='',@Choice2 ='',@Choice3 ='',@TypeOfQuestion= 'TOF',@TxtAnswer ='',@StatmentType = 'Insert'
go
exec Question.SP_EditQuestionPool @ID=0, @InstructorName = 'Sally',@content= 'Tonle Sap is located in Vietnam.',@CorrectChoice = '',@CorrectAnswer = 'True' ,@Choice1 ='',@Choice2 ='',@Choice3 ='',@TypeOfQuestion= 'TOF',@TxtAnswer ='',@StatmentType = 'Insert'
go
exec Question.SP_EditQuestionPool @ID=0, @InstructorName = 'Sara',@content= 'The study of stars is called astronomy.',@CorrectChoice = '',@CorrectAnswer = 'False' ,@Choice1 ='',@Choice2 ='',@Choice3 ='',@TypeOfQuestion= 'TOF',@TxtAnswer ='',@StatmentType = 'Insert'
go

-----------Insert MCQ Questions-----------
exec Question.SP_EditQuestionPool @ID=1, @InstructorName = 'Sara',@content= ' What type of animal is a seahorse?',@CorrectChoice = 'A',@CorrectAnswer = '' ,@Choice1 ='A) Crustacean',@Choice2 ='B) Arachnid',@Choice3 ='C) Fish',@TypeOfQuestion= 'MCQ',@TxtAnswer ='',@StatmentType = 'Insert'
go
exec Question.SP_EditQuestionPool @ID=0, @InstructorName = 'Ahmed',@content= '  Which of the following dog breeds is the smallest?',@CorrectChoice = 'A',@CorrectAnswer = '' ,@Choice1 ='A) Dachshund',@Choice2 ='B) Poodle
',@Choice3 ='C) Pomeranian
',@TypeOfQuestion= 'MCQ',@TxtAnswer ='',@StatmentType = 'Insert'
go
exec Question.SP_EditQuestionPool @ID=0, @InstructorName = 'Sara',@content= 'What existing bird has the largest wingspan?',@CorrectChoice = 'B',@CorrectAnswer = '' ,@Choice1 ='A) Stork',@Choice2 ='B) Swan',@Choice3 ='C) Condor',@TypeOfQuestion= 'MCQ',@TxtAnswer ='',@StatmentType = 'Insert'
go
exec Question.SP_EditQuestionPool @ID=0, @InstructorName = 'Sara',@content= 'What is the biggest animal that has ever lived?',@CorrectChoice = 'C',@CorrectAnswer = '' ,@Choice1 ='A) Blue whale',@Choice2 ='B) African elephant',@Choice3 ='C) Apatosaurus (aka Brontosaurus)',@TypeOfQuestion= 'MCQ',@TxtAnswer ='',@StatmentType = 'Insert'
go
exec Question.SP_EditQuestionPool @ID=0, @InstructorName = 'Ahmed',@content= ' Which of these animals lives the longest?',@CorrectChoice = 'B',@CorrectAnswer = '' ,@Choice1 ='A) Ocean quahog (clam)',@Choice2 ='B) Red sea urchin',@Choice3 ='C) Galapagos tortoise',@TypeOfQuestion= 'MCQ',@TxtAnswer ='',@StatmentType = 'Insert'
go
-----------Insert Text Questions-----------
exec Question.SP_EditQuestionPool @ID=0, @InstructorName = 'Sara',@content= 'How many days do we have in a week?',@CorrectChoice = '',@CorrectAnswer = '' ,@Choice1 ='',@Choice2 ='',@Choice3 ='',@TypeOfQuestion= 'TXT',@TxtAnswer ='Seven',@StatmentType = 'Insert'
go
exec Question.SP_EditQuestionPool @ID=0, @InstructorName = 'Ahmed',@content= 'Which animal is known as the ‘Ship of the Desert?',@CorrectChoice = '',@CorrectAnswer = '' ,@Choice1 ='',@Choice2 ='',@Choice3 ='',@TypeOfQuestion= 'TXT',@TxtAnswer ='Camel',@StatmentType = 'Insert'
go
exec Question.SP_EditQuestionPool @ID=0, @InstructorName = 'Sara',@content= 'How many sides are there in a triangle?',@CorrectChoice = '',@CorrectAnswer = '' ,@Choice1 ='',@Choice2 ='',@Choice3 ='',@TypeOfQuestion= 'TXT',@TxtAnswer ='Three',@StatmentType = 'Insert'
go
exec Question.SP_EditQuestionPool @ID=0, @InstructorName = 'Ahmed',@content= 'In which direction does the sun rise?',@CorrectChoice = '',@CorrectAnswer = '' ,@Choice1 ='',@Choice2 ='',@Choice3 ='',@TypeOfQuestion= 'TXT',@TxtAnswer ='East',@StatmentType = 'Insert'
go
exec Question.SP_EditQuestionPool @ID=0, @InstructorName = 'Sally',@content= 'Which month of the year has the least number of days?',@CorrectChoice = '',@CorrectAnswer = '' ,@Choice1 ='',@Choice2 ='',@Choice3 ='',@TypeOfQuestion= 'TXT',@TxtAnswer ='February',@StatmentType = 'Insert'
go



---------------------
Create proc CourseData.SP_EditCourse (@ID int,@Title nvarchar(50),@Description  nvarchar(max),@MinDegree int,@MaxDegree int,@InstructorID int,@StatementType NVARCHAR(20) = '')  
AS  
  begin  
      if @StatementType = 'Insert'  
        begin  
            insert into  CourseData.[Course]
                        (CourseName,Description,MinDegree,MaxDegree,InstructorID,IsDeleted)  
            values     (@Title,@Description,@MinDegree,@MaxDegree,@InstructorID,0)  
        end  
  
      if @StatementType = 'Update'  
        begin  
            UPDATE  CourseData.[Course]
            SET    CourseName = @Title,  
                   Description = @Description,  
                   MinDegree = @MinDegree,
				   MaxDegree=@MaxDegree,
				    instructorID=@InstructorID
            WHERE  CourseID = @Id  
        end   
  end 
  go
 --exec CourseData.SP_EditCourse 1,'ANG','Angular Framework',10,25,3,'Insert'

Create proc StudentData.SP_EditDepartment (@DepartmentName nvarchar(50),@TrackName nvarchar(50),@BranchName nvarchar(50))
AS
begin
declare @DepartmentID as int , @TrackID as int , @BranchID as int
    set @DepartmentID = (select DeptID from StudentData.[Department] where DeptName=@DepartmentName);
	set @TrackID = (select TrackID from StudentData.[Track] where TrackName=@TrackName);
	set @BranchID = (select BranchID from StudentData.[Branch] where BranchName=@BranchName);

    UPDATE StudentData.[DIBT]
            SET    BranchID_FK=@BranchID , TrackID_FK=@TrackID
            WHERE   DeptID_FK= @DepartmentID  
end
go
--exec StudentData.SP_EditDepartment 'MultiMedia','Front end','Minia'

-----------------Assign Course to instructor------------------
create proc CourseData.SP_EditInsructorInCourse (@Title nvarchar(50),@UserName nvarchar(50))
AS
begin
 declare @InstructorID as int
 set @InstructorID = (select InstructorID from Person.Instructor where UserName=@UserName);
      UPDATE  CourseData.[Course]
            SET    InstructorID=@InstructorID 
            WHERE  CourseName = @Title  
end
go

--exec CourseData.SP_EditInsructorInCourse 'ANG','Tony44'

create proc Person.SP_EditInstructorUserName(@oldUserName nvarchar(50) ,@NewUserName nvarchar(50))
as
begin

	declare @InstructorID int;
	set @InstructorID=(select [InstructorID] from Person.[Instructor] where [UserName]=@oldUserName);
	update Person.[Instructor]
	set [UserName]=@NewUserName
	where [InstructorID]= @InstructorID 

end

go

--exec Person.SP_EditInstructorUserName 'Sara1111','Sara11'
--exec Person.SP_EditInstructorUserName 'Sara11','Sara1111'

create proc Person.SP_EditInstructorPass(@UserName nvarchar(50),@NewPass nvarchar(50))
as
begin

	declare @InstructorID int;
	set @InstructorID=(select [InstructorID] from Person.[Instructor] where [UserName]=@UserName);
	update Person.[Instructor]
	set [Password]=@NewPass
	where [InstructorID]= @InstructorID 

end
go
-------------------------------
Create proc Person.SP_EditInstructor (@ID int =0,@Name nvarchar(50),@UserName nvarchar(50),@Password nvarchar(50),@StatementType NVARCHAR(20) = '',@SupervisorID int=NULL)  
AS  
  begin  
      if @StatementType = 'Insert'  
        begin  
            insert into  Person.[Instructor]
                        (InstructorName,UserName,Password,SupervisorID,IsDeleted)  
            values     (@Name,@UserName,@Password,@SupervisorID,0)  
        end  
     ELSE if @StatementType = 'Update'  
        begin  
            UPDATE  Person.[Instructor]
            SET    InstructorName = @Name,  
                   UserName = @UserName,  
                   Password = @Password
            WHERE  InstructorID = @ID  
        end     
  end
  go
  
  --exec Person.SP_EditInstructor 0,'Fathy','Fathy11','123','Insert',4
  --------------------------------------

  create proc Person.SP_EditStudentPassWord
@UserName nvarchar(50),@newPassword nvarchar(50)
as update Person.Students set Password=@newPassword where UserName=@UserName
go
----------------------------------------------

create proc Person.SP_EditStudentUserName
@OldUserName nvarchar(50),@newUserName nvarchar(50)
as update Person.Students set UserName=@newUserName where UserName=@OldUserName
go
------------------------------------------------
create proc CourseData.SP_InstructorCourses(@UserName nvarchar(50))
as
begin
	select [CourseName],[Description] 
from CourseData.Course
where [instructorID] in 
(
select [InstructorID] from Person.[Instructor]
where [UserName]=@UserName
)
end
go

--exec CourseData.SP_InstructorCourses 'Sara1111'
-------------------------------------------------

create proc StudentData.SP_RemoveStudentFromCourse
@UserName nvarchar(50),@Title nvarchar(50)
as
begin
	declare @courseID int;
	select @courseID=CourseID from CourseData.Course where CourseName=@Title;
	declare @studentID nvarchar(50);
	select @studentID=studentID from Person.Students where UserName=@UserName;
	Update StudentData.DIBT set IsDeleted =1 where StudentID_FK=@studentID and CourseID_FK=@courseID
end
go
--exec StudentData.SP_RemoveStudentFromCourse 'Ahmed333@gmail.com', 'ES6'
------------------------------------
create proc CourseData.SP_ShowStudentCourses
@UserName nvarchar(50)
as
begin
	select  distinct cr.CourseName as course ,i.InstructorName as instructorName,t.TrackName as track,cl.ClassName as class,b.BranchName as branch
	from CourseData.Course cr,Person.Instructor i,StudentData.Track t,CourseData.Class cl,
	StudentData.Branch b,
	CourseData.TeachingInfo cty,StudentData.DIBT ,Person.Students
	where
	cr.CourseID=cty.CourseID_FK and
	cr.IsDeleted=0 and
	cl.ClassID=cty.ClassID_FK and
	i.InstructorID=cty.InstructorID_FK and
	DIBT.CourseID_FK=cr.CourseID and
	DIBT.TrackID_FK=t.TrackID and
	DIBT.BranchID_FK=b.BranchID and
	cr.CourseID=DIBT.CourseID_FK and
	DIBT.StudentID_FK=(select studentID from Person.Students where UserName=@UserName)
end
go
--exec CourseData.SP_ShowStudentCourses 'azza123@gmail.com'

------------------------------------------
create   proc CourseData.SP_StudentsOfInstructor(@UserName nvarchar(50))
as
begin
declare @InstructorID int;
set @InstructorID=(select InstructorID from Person.[Instructor] where [UserName]=@UserName)
select stu.StudentName,crs.CourseName
from Person.Students stu,CourseData.[Course] crs ,StudentData.[DIBT] dipt
where stu.studentID =dipt.StudentID_FK and dipt.CourseID_FK=crs.CourseID and crs.CourseID in
(
select CourseID from CourseData.[Course]
where [instructorID]=@InstructorID
)

end

--exec CourseData.SP_StudentsOfInstructor 'Sally22'



go
create   proc Exam.SP_CreateExam (@CourseID int,@ExameDate date, @StartTime time ,@endTime time ,@IsCorrective bit, @ExamTotalGrade int)
as
begin
insert into Exam.ExamInfo(CourseID_FK,ExamDate ,StartTime,endTime,IsCorrective,ExamTotalGrade) 
values(@CourseID,@ExameDate ,@StartTime,@endTime,@IsCorrective,@ExamTotalGrade)
end
go

--exec Exam.SP_CreateExam 2,'2021-01-22','9:00:00','12:00:00',0,50

--exec Exam.SP_CreateExam 7,'2021-01-22','8:00:00','10:00:00',1,100

go


create   proc Exam.SP_MakeCourseExam(@CourseTitle nvarchar(50) ,@ExamID int)
as
begin
declare @sum int;
set @sum=0;
declare @courseID int;
set @courseID=(select CourseID from CourseData.[Course] where CourseName =@CourseTitle);
--print @courseID
declare @MaxDegree int;
set @MaxDegree =(select [MaxDegree] from CourseData.[Course] where CourseName =@CourseTitle);
--print @MaxDegree
create table #MCQ
(
 ID int 
)
insert into #MCQ select MCQID from Question.[MCQ] where CourseID_FK=@courseID 
--
create table #TF
(
ID int
)
insert into #TF select TrueOrFalseID from Question.TrueOrFalse where CourseID_FK=@courseID 
--
create table #TXT
(
ID int
)
insert into #TXT select TextQID from Question.TextQ where CourseID_FK=@courseID 

---

declare Cursor1 cursor
	for select ID from #MCQ
	for read only  
declare @id1 int
open Cursor1 
begin
	--print @@Fetch_status
	
	fetch Cursor1 into @id1
	While @@fetch_status=0  
	begin
		declare @QDegree int
		set @QDegree =5
		if(@QDegree is not null and @QDegree >0 and @QDegree+@sum <= @MaxDegree)
          begin
           set @sum+=@QDegree
           insert into Question.QuestionPool(Exam_FK,MCQID_FK,QType) values (@ExamID,@id1,'MCQ');
           end
		fetch Cursor1 into @id1
	end
end
close Cursor1
deallocate Cursor1
---

declare Cursor2 cursor
	for select ID from #TF
	for read only  
declare @id2 int
open Cursor2 
begin
	--print @@Fetch_status
	
	fetch Cursor2 into @id2
	While @@fetch_status=0  
	begin
		declare @QDegree2 int
		set @QDegree2 =5
		if(@QDegree2 is not null and @QDegree2 >0 and @QDegree2+@sum <= @MaxDegree)
          begin
           set @sum+=@QDegree2
           insert into Question.QuestionPool([Exam_FK],TrueOrFalse_FK,QType) values (@ExamID,@id2,'TOF');
           end
		fetch Cursor2 into @id2
	end
end
close Cursor2
deallocate Cursor2
------
declare Cursor3 cursor
	for select ID from #TF
	for read only  
declare @id3 int
open Cursor3 
begin
	--print @@Fetch_status
	
	fetch Cursor3 into @id3
	While @@fetch_status=0  
	begin
		declare @QDegree3 int
		set @QDegree3 =15
		if(@QDegree3 is not null and @QDegree3 >0 and @QDegree3+@sum <= @MaxDegree)
          begin
           set @sum+=@QDegree3
           insert into Question.QuestionPool([Exam_FK],TextQ_FK,QType) values (@ExamID,@id3,'TXT');
           end
		fetch Cursor3 into @id3
	end
end
close Cursor3
deallocate Cursor3
end
go

exec Exam.SP_MakeCourseExam 'ES6',1

go

create proc Question.CalculateQuestionResult 
(@UserName nvarchar(50),@QuestionID int,@ExamID int ,@QuestionType char(3))
as
begin
declare @studentID int;
select @studentID=studentID from Person.Students where UserName=@UserName;
		declare @studentAnswer nvarchar(400)
		declare @correctAnswer nvarchar(400)
		declare @FullDegree int
		declare @StudentAnswerResult int
		select @StudentAnswerResult=0
		if (@QuestionType='MCQ')
		begin
			declare @MCQQ int
		    select  @MCQQ = MCQID_FK from Question.QuestionPool where @QuestionID=QuestionID
			select @correctAnswer=CorrectAnswer from Question.MCQ where MCQID=@MCQQ
			
			select @FullDegree =5
			select  @studentAnswer =AnsContent from Exam.StudentAnswer  where @QuestionID=QuestionID_FK 
			if(@studentAnswer=@correctAnswer)
				select @StudentAnswerResult=@FullDegree
            update Exam.StudentAnswer set AnsGrade=@StudentAnswerResult where QuestionID_FK=@QuestionID
		end
		else if(@QuestionType='TXT')
		begin
		    select  @QuestionID = TextQ_FK from Question.QuestionPool where Exam_FK=@ExamID
			select @correctAnswer= CorrectAnswer from Question.TextQ where TextQID=@QuestionID
			select @FullDegree =15
			select  @studentAnswer =AnsContent from Exam.StudentAnswer where @QuestionID=QuestionID_FK
			if(DifFERENCE(@studentAnswer,@correctAnswer)>=2)
				select @StudentAnswerResult+=@FullDegree/2
           else if(DifFERENCE(@studentAnswer,@correctAnswer)>=3)
		        select @StudentAnswerResult+=@FullDegree
		  update Exam.StudentAnswer set AnsGrade=@StudentAnswerResult where QuestionID_FK=@QuestionID
		end
		else if(@QuestionType ='TOF')
	   begin
	        select  @QuestionID = TrueOrFalse_FK from Question.QuestionPool where Exam_FK=@ExamID
			select @correctAnswer=CorrectAnswer from Question.TrueOrFalse where TrueOrFalseID=@QuestionID
			select @FullDegree =5
			select  @studentAnswer =AnsContent from Exam.StudentAnswer where @QuestionID=QuestionID_FK
			if(@studentAnswer=@correctAnswer)
				select @StudentAnswerResult+=@FullDegree
        	update Exam.StudentAnswer set AnsGrade=@StudentAnswerResult where QuestionID_FK=@QuestionID
		end
    end
go


	exec Question.CalculateQuestionResult 'Ahmed333@gmail.com',1,1,'MCQ'
	exec Question.CalculateQuestionResult 'Ahmed333@gmail.com',2,1,'MCQ'




-------------------------------------
/*
create proc Exam.CalculateFinalResult
(@UserName nvarchar(50),@ExamID int )
as
begin
	declare @studentID int
	select @studentID = studentID from Person.Students where UserName=@UserName 
	declare @FinalResult int
	declare Cursor1 cursor
	 for select MCQID_FK,TrueOrFalse_FK,TextQ_FK ,QType from Question.QuestionPool
	 for read only  
	declare @MCQID int
	declare @TFQID int
	declare @TXQID int
	declare @QuestionType char(3)
	open Cursor1 
	begin
		 fetch Cursor1 into   @MCQID ,@TFQID ,@TXQID ,@QuestionType
		 While @@fetch_status=0  
		 begin
			  if(@QuestionType='MCQ')

			   exec CalculateQuestionResult @UserName ,@MCQID ,@ExamID ,@QuestionType 
   
			  else if(@QuestionType='TXQ')
  
			 exec   CalculateQuestionResult @UserName ,@TXQID ,@ExamID ,@QuestionType 
	
			 else if(@QuestionType='TFQ')
			  exec CalculateQuestionResult @UserName ,@TFQID ,@ExamID ,@QuestionType 
  
			 fetch Cursor1 into   @MCQID ,
								 @TFQID ,
								@TXQID ,
								@QuestionType
		end
	end
	close Cursor1
	deallocate Cursor1

	Select @FinalResult = sum(StudentAnswerResult) from Questions.ExamQuestion where ExamID=@ExamID and StudentID=@studentID
	update Exam.StudentExamResult set Result= @FinalResult where ExamID=@ExamID and StudentID=@studentID
end
go
*/
----------------------------
create proc Exam.SP_DoExam 
@UserName nvarchar(50),@ExamID int
as
begin
declare @studentID nvarchar(50);
select @studentID=studentID from Person.Students where UserName=@UserName;
  if exists(select* from Exam.StudentAnswer where ExamID_FK=@ExamID and StudentID_FK=@studentID)
  begin
    if(DATEDifF (minute,getdate(),(select endTime from Exam.ExamInfo where ExamID=@ExamID))>50)
	begin
       print 'You are Currently btmt7n '
	end
	else  print 'You are too late'
 end
 else  print 'Wrong Exam'
end
go

exec Exam.SP_DoExam 'Ahmed333@gmail.com',1
exec Exam.SP_DoExam 'azza123@gmail.com',1



-----------------------------------------
create proc Person.SP_DeleteInstructor (@UserName nvarchar(50))  
AS  
  begin 
        declare @InstructorID as int ,@CourseID as int
		set @InstructorID= (select InstructorID from Person.[Instructor] where UserName=@UserName)
		set @CourseID= (select top 1 CourseID from CourseData.[Course] where InstructorID=@InstructorID)
		 UPDATE  CourseData.TeachingInfo
            SET IsDeleted = 1
			WHERE  CourseID_FK=@CourseID 
            DELETE FROM Person.[Instructor]
            WHERE  UserName = @UserName 
 end  
 go

 --exec Person.SP_DeleteInstructor 'AHmed33'
----------------------------------------
   Create proc CourseData.SP_DeleteCourse (@Title nvarchar(50))  
AS  
  begin 
    
            DELETE  FROM  CourseData.Course
            WHERE  CourseName=@Title 
 end
 go
 --exec CourseData.SP_DeleteCourse 'JSNEXT'
-- ------------------------------------------------------
 create   proc Question.SP_CourseQuestion(@courseTitle nvarchar(50))
as
begin

declare @courseID int;
set @courseID=(select CourseID from CourseData.[Course] where CourseName =@courseTitle);
select [Content] as 'Question' ,[CorrectAnswer] as 'CorrectAnswer' from Question.TrueOrFalse
where [CourseID_FK] = @courseID
union 
select [Content] as 'Question' ,CorrectAnswer as 'CorrectAnswer' from  Question.TextQ
where [CourseID_FK] = @courseID
union
select [Content] as 'Question',CorrectAnswer as 'CorrectAnswer' from Question.MCQ
where [CourseID_FK] = @courseID

end
go
--exec Question.SP_CourseQuestion 'ES6'

----------------------------------------------------------------
create proc CourseData.SP_AddStudentToCourse
@UserName nvarchar(50),@Title nvarchar(50)
as
begin
declare @courseID int;
select @courseID=CourseID from CourseData.Course where CourseName=@Title;
declare @studentID nvarchar(50);
select @studentID=studentID from Person.Students where UserName=@UserName;
Update StudentData.DIBT set CourseID_FK =@courseID where StudentID_FK=@studentID 
end

--exec CourseData.SP_AddStudentToCourse 'azza123@gmail.com','JSNEXT'
go
------------------------------------------------------------------------
create proc StudentData.SP_AddNewTrack (@Name nvarchar(50))  
AS  
  begin  
            insert into  StudentData.Track (TrackName)
            values     (@Name)  
 end 
 
 exec StudentData.SP_AddNewTrack 'GIS'
 go
 -----------------------------------------------
 create   proc Exam.SP_StudentsResultExam (@ExamID int)
as
begin
select StudentID_FK as 'StudentName' , AnsGrade 
from Exam.StudentAnswer
where ExamID_FK=@ExamID
end
go

--exec Exam.SP_StudentsResultExam 1
--exec Exam.SP_StudentsResultExam 2



----------------------------------------------------
create   proc Exam.SP_ShowQuestionsExam(@ExamID int)
as
begin

select distinct [Content]  as 'Question' , mcq.CorrectAnswer as 'CorrectAnswer'
from Question.MCQ mcq ,Question.QuestionPool EQ
where EQ.[Exam_FK]=@ExamID and EQ.MCQID_FK is not null and EQ.MCQID_FK =mcq.MCQID
union 
select distinct [Content] as 'Question' ,TXQ.CorrectAnswer as 'CorrectAnswer'
from Question.TextQ TXQ,Question.QuestionPool EQ
where EQ.[Exam_FK]=@ExamID and EQ.TextQ_FK is not null and EQ.TextQ_FK =TXQ.TextQID
union 
select distinct [TFQ].Content as 'Question' ,TFQ.CorrectAnswer as 'CorrectAnswer'
from Question.TrueOrFalse TFQ,Question.QuestionPool EQ
where EQ.[Exam_FK]=@ExamID and EQ.TrueOrFalse_FK is not null and EQ.TrueOrFalse_FK =TFQ.TrueOrFalseID

end
go



--exec Exam.SP_ShowQuestionsExam 1

------------------------------------------
create   proc StudentData.SP_AddNewStudent (@Name nvarchar(50),@UserName nvarchar(50),@Password nvarchar(50),@IntakeNumber int,@BranchName nvarchar(50),@TrackName nvarchar(50),@DepartmentName nvarchar(50))  
AS  
  begin  
          declare @IntakeID as int ,@BranchID as int ,@TrackID as int,@DepartmentID as int,@StudentID as int 
		  set @IntakeID=(select IntakeID from StudentData.Intake where IntakeName=@IntakeNumber);
		  set @BranchID=(select BranchID from StudentData.Branch where BranchName=@BranchName);
		  set @TrackID=(select TrackID from StudentData.Track where TrackName=@TrackName);
		  set @DepartmentID=(select DeptID from StudentData.Department where DeptName=@DepartmentName);

		 insert into Person.Students
                        (StudentName,UserName,Password)  
            values     (@Name,@UserName,@Password)
            set @StudentID=(select studentID from Person.Students where UserName=@UserName);
			insert into StudentData.[DIBT]
                        (DeptID_FK,IntakeID_FK,BranchID_FK,TrackID_FK,CourseID_FK,StudentID_FK)  
            values     (@DepartmentID,@IntakeID,@BranchID,@TrackID,null,@StudentID)
  end 
  go


----------------------------------------------Create Permissions------------------------------------------------

------admin------
go
CREATE USER [Admin] WITHOUT LOGIN WITH DEFAULT_SCHEMA=[dbo]
go
-------TrainingManager-------
go
CREATE USER [TrainingManager] WITHOUT LOGIN
go
GRANT ALTER ON [Person].[SP_DeleteInstructor] TO [TrainingManager]
go
GRANT CONTROL ON [Person].[SP_DeleteInstructor] TO [TrainingManager]
go
GRANT EXECUTE ON [Person].[SP_DeleteInstructor] TO [TrainingManager]
go
GRANT TAKE OWNERSHIP ON [Person].[SP_DeleteInstructor] TO [TrainingManager]
go
GRANT VIEW DEFINITION ON [Person].[SP_DeleteInstructor] TO [TrainingManager]
go
GRANT ALTER ON [StudentData].[SP_AddNewStudent] TO [TrainingManager]
go
GRANT CONTROL ON [StudentData].[SP_AddNewStudent] TO [TrainingManager]
go
GRANT EXECUTE ON [StudentData].[SP_AddNewStudent] TO [TrainingManager]
go
GRANT TAKE OWNERSHIP ON [StudentData].[SP_AddNewStudent] TO [TrainingManager]
go
GRANT VIEW DEFINITION ON [StudentData].[SP_AddNewStudent] TO [TrainingManager]
go
GRANT ALTER ON  [StudentData].[SP_AddNewStudent] TO [TrainingManager]
go
GRANT CONTROL ON [StudentData].[SP_AddNewStudent]  TO [TrainingManager]
go
GRANT EXECUTE ON [StudentData].[SP_AddNewStudent] TO [TrainingManager]
go
GRANT TAKE OWNERSHIP ON [StudentData].[SP_AddNewStudent] TO [TrainingManager]
go
GRANT VIEW DEFINITION ON [StudentData].[SP_AddNewStudent] TO [TrainingManager]
go
GRANT ALTER ON [CourseData].[SP_AddStudentToCourse] TO [TrainingManager]
go
GRANT CONTROL ON [CourseData].[SP_AddStudentToCourse] TO [TrainingManager]
go
GRANT EXECUTE ON [CourseData].[SP_AddStudentToCourse] TO [TrainingManager]
go
GRANT TAKE OWNERSHIP ON [CourseData].[SP_AddStudentToCourse] TO [TrainingManager]
go
GRANT VIEW DEFINITION ON [CourseData].[SP_AddStudentToCourse] TO [TrainingManager]
go
GRANT ALTER ON [CourseData].[SP_EditInsructorInCourse] TO [TrainingManager]
go
GRANT CONTROL ON [CourseData].[SP_EditInsructorInCourse] TO [TrainingManager]
go
GRANT EXECUTE ON [CourseData].[SP_EditInsructorInCourse] TO [TrainingManager]
go
GRANT TAKE OWNERSHIP ON [CourseData].[SP_EditInsructorInCourse] TO [TrainingManager]
go
GRANT VIEW DEFINITION ON [CourseData].[SP_EditInsructorInCourse] TO [TrainingManager]
go
GRANT ALTER ON [CourseData].[SP_DeleteCourse] TO [TrainingManager]
go
GRANT CONTROL ON [CourseData].[SP_DeleteCourse] TO [TrainingManager]
go
GRANT EXECUTE ON [CourseData].[SP_DeleteCourse] TO [TrainingManager]
go
GRANT TAKE OWNERSHIP ON [CourseData].[SP_DeleteCourse] TO [TrainingManager]
go
GRANT VIEW DEFINITION ON [CourseData].[SP_DeleteCourse] TO [TrainingManager]
go
GRANT ALTER ON [CourseData].[SP_DeleteCourse] TO [TrainingManager]
go
GRANT CONTROL ON [StudentData].[SP_RemoveStudentFromCourse] TO [TrainingManager]
go
GRANT EXECUTE ON [StudentData].[SP_RemoveStudentFromCourse] TO [TrainingManager]
go
GRANT TAKE OWNERSHIP ON [StudentData].[SP_RemoveStudentFromCourse] TO [TrainingManager]
go
GRANT VIEW DEFINITION ON [StudentData].[SP_RemoveStudentFromCourse] TO [TrainingManager]
go
GRANT ALTER ON [StudentData].[SP_EditDepartment] TO [TrainingManager]
go
GRANT CONTROL ON [StudentData].[SP_EditDepartment] TO [TrainingManager]
go
GRANT EXECUTE ON [StudentData].[SP_EditDepartment] TO [TrainingManager]
go
GRANT TAKE OWNERSHIP ON [StudentData].[SP_EditDepartment] TO [TrainingManager]
go
GRANT VIEW DEFINITION ON [StudentData].[SP_EditDepartment] TO [TrainingManager]
go
GRANT ALTER ON [StudentData].[SP_AddNewTrack] TO [TrainingManager]
go
GRANT CONTROL ON [StudentData].[SP_AddNewTrack]TO [TrainingManager]
go
GRANT EXECUTE ON [StudentData].[SP_AddNewTrack]TO [TrainingManager]
go
GRANT TAKE OWNERSHIP ON [StudentData].[SP_AddNewTrack]TO [TrainingManager]
go
GRANT VIEW DEFINITION ON [StudentData].[SP_AddNewTrack]TO [TrainingManager]
go
-------student-------
CREATE USER [student] WITHOUT LOGIN
go
GRANT VIEW DEFINITION ON [dbo].[DetailsAboutDepartment] TO [student]
go
GRANT EXECUTE ON [Exam].[SP_DoExam] TO [student]
go
GRANT TAKE OWNERSHIP ON [Exam].[SP_DoExam] TO [student]
go
GRANT VIEW DEFINITION ON [Exam].[SP_DoExam] TO [student]
go

-------instructor-------
go
CREATE USER [Instructor] WITHOUT LOGIN
go
GRANT EXECUTE ON [Question].[CalculateQuestionResult] TO [instructor]
go
GRANT EXECUTE ON [Question].[SP_CourseQuestion] TO [instructor]
go
GRANT EXECUTE ON [Question].[SP_EditMCQ] TO [instructor]
go
GRANT EXECUTE ON [CourseData].[SP_ShowStudentCourses] TO [instructor]
go
GRANT EXECUTE ON [CourseData].[SP_AddStudentToCourse] TO [instructor]
go
GRANT EXECUTE ON [Question].[SP_EditQuestionPool] TO [instructor]
go
GRANT EXECUTE ON [Question].[SP_EditTextQ] TO [instructor]
go
GRANT EXECUTE ON [Question].[SP_EditTrueOrFalse] TO [instructor]
go
GRANT EXECUTE ON [Exam].[SP_ShowQuestionsExam] TO [instructor]
go
GRANT EXECUTE ON [Person].[SP_EditInstructorUserName] TO [instructor]
go
GRANT EXECUTE ON [Exam].[SP_MakeCourseExam] TO [instructor]
go


  	----------------------------------------------Create Daily Backup Schedule------------------------------------------------
	USE [msdb]
go

/****** Object:  Job [ExaminationSysDBBackup.Subplan_1]    Script Date: 29-Jan-22 2:54:11 AM ******/
begin TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [Database Maintenance]    Script Date: 29-Jan-22 2:54:11 AM ******/
if NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'Database Maintenance' AND category_class=1)
begin
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'Database Maintenance'
if (@@ERROR <> 0 OR @ReturnCode <> 0) goTO QuitWithRollback

end

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'ExaminationSysDBBackup.Subplan_1', 
		@enabled=1, 
		@notify_level_eventlog=2, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'No description available.', 
		@category_name=N'Database Maintenance', 
		@owner_login_name=N'DESKTOP-HEN5EV3\Fady Shafeek', @job_id = @jobId OUTPUT
if (@@ERROR <> 0 OR @ReturnCode <> 0) goTO QuitWithRollback
/****** Object:  Step [Subplan_1]    Script Date: 29-Jan-22 2:54:13 AM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Subplan_1', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'SSIS', 
		@command=N'/Server "$(ESCAPE_NONE(SRVR))" /SQL "Maintenance Plans\ExaminationSysDBBackup" /set "\Package\Subplan_1.Disable;false"', 
		@flags=0
if (@@ERROR <> 0 OR @ReturnCode <> 0) goTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
if (@@ERROR <> 0 OR @ReturnCode <> 0) goTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'DailyExaminationSysDBBackup.Subplan_1', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20220129, 
		@active_end_date=20220228, 
		@active_start_time=0, 
		@active_end_time=235959, 
		@schedule_uid=N'fb25dd58-5508-47bb-bebf-9b4793a960b2'
if (@@ERROR <> 0 OR @ReturnCode <> 0) goTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
if (@@ERROR <> 0 OR @ReturnCode <> 0) goTO QuitWithRollback
COMMIT TRANSACTION
goTO endSave
QuitWithRollback:
    if (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
endSave:
go
use Examination_System;
go

--Abanoub Harby
--Azza Dawoud
--Fady Shafek

--GG--