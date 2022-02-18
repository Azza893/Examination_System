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