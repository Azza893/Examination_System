	----------------------------------------------Create Stored proc------------------------------------------------
	
create proc Question.SP_EditMCQ (@MCQID int = 0 ,@MCQContent nvarchar(max), @MCQCorrectAnswer char(1),@MCQOption1 nvarchar(max),@MCQOption2 nvarchar(max),@MCQOption3 nvarchar(max),@MCQCourseID_FK int, @Action nvarchar(6),@MCQIsDeleted bit = 0)
as
begin
begin TRY  
    if @Action = 'Insert'
	begin
		insert into Question.MCQ (Content, CorrectAnswer, Option1, Option2, Option3,CourseID_FK  )
		values (@MCQContent,@MCQCorrectAnswer,@MCQOption1,@MCQOption2,@MCQOption3,@MCQCourseID_FK)
		--insert into Question.QuestionPool (MCQID_FK,QType)
		--values ((select MCQID from Question.MCQ where Content=@MCQContent) , 'MCQ');
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



create proc Question.SP_EditTrueOrFalse (@TOFID int = 0 ,@TOFContent nvarchar(max), @TOFCorrectAnswer nvarchar(max),@TOFCourseID_FK int, @Action nvarchar(6),@TOFIsDeleted bit = 0)
as
begin
begin TRY
	if @Action = 'Insert'
	begin
		insert into Question.TrueOrFalse (Content, CorrectAnswer,CourseID_FK)
		values (@TOFContent,@TOFCorrectAnswer,@TOFCourseID_FK)
		--insert into Question.QuestionPool (TrueOrFalse_FK,QType)
		--values ((select TrueOrFalseID from Question.TrueOrFalse where Content=@TOFContent) , 'TOF');
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


create proc Question.SP_EditTextQ (@TXTID int = 0 ,@TXTContent nvarchar(max), @TXTCorrectAnswer nvarchar(max),@TXTCourseID_FK int, @Action nvarchar(6),@TXTIsDeleted bit = 0)
as
begin
begin TRY  
	if @Action = 'Insert'
	begin
		insert into Question.TextQ (Content, CorrectAnswer,CourseID_FK)
		values (@TXTContent,@TXTCorrectAnswer,@TXTCourseID_FK)
		--insert into Question.QuestionPool (TextQ_FK,QType)
		--values ((select TextQID from Question.TextQ where Content=@TXTContent) , 'TXT');
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

create  proc Question.SP_QuestionOfCourse(@courseTitle nvarchar(50))
as
begin

declare @courseID int;
set @courseID=(select [CourseID] from CourseData.[Course] where CourseName =@courseTitle);
select [Content] as 'Question' ,[CorrectAnswer] as 'CorrectAnswer' from Question.[TrueOrFalse] 
where [CourseID_FK] = @courseID
union 
select [Content] as 'Question' ,[CorrectAnswer] as 'CorrectAnswer' from  Question.[TextQ]
where [CourseID_FK] = @courseID
union
select [Content] as 'Question',CorrectAnswer as 'CorrectAnswer' from Question.[MCQ]
where [CourseID_FK] = @courseID

end
go

--exec Question.SP_QuestionOfCourse 'ES6'
-------------------
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
go
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

--exec Exam.SP_MakeCourseExam 'ES6',1



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

	--exec Question.CalculateQuestionResult 'Ahmed333@gmail.com',7,1,'MCQ'



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

--exec Exam.SP_DoExam 'Ahmed333@gmail.com',1
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

