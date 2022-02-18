----------------------------------------------Create Functions------------------------------------------------
use Examination_System;
go	
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

