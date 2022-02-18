----------------------------------------------Create Views------------------------------------------------
use Examination_System;
go
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


Create View DetailsAboutDepartment


AS

		select d.DeptName as NameOfDepartment,t.TrackName as NameOfTrack ,b.BranchName as NameOfBranch
		from StudentData.Department d, StudentData.Track t,StudentData.Branch b ,StudentData.DIBT x
		where x.BranchID_FK=b.BranchID and x.DeptID_FK=d.DeptID and x.TrackID_FK=t.TrackID
		
		go
--select * from DetailsAboutDepartment

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


