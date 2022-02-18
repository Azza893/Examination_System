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