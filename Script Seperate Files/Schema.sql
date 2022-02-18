----------------------------------------------Create Schema------------------------------------------------
use Examination_System;
go
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