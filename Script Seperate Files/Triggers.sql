----------------------------------------------Create Triggers------------------------------------------------
use Examination_System;
go
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