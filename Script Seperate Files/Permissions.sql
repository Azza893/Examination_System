----------------------------------------------Create Permissions------------------------------------------------
use Examination_System;
go
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