CREATE OR ALTER PROCEDURE [dbo].[User_SEL]
(
       @UserName VARCHAR(50)
)

AS

DECLARE @InsertToErrorLog BIT= 1,@PrintError BIT = 0, @RaiseError BIT = 1
    DECLARE @login_name VARCHAR(128)
 
    SELECT  @login_name = login_name
    FROM    sys.dm_exec_sessions
    WHERE   session_id = @@SPID
	BEGIN TRY
		SELECT U.*, D.DepartmentCode, D.Department, @login_name SQLUserName
		FROM	UserProfile U WITH(NOLOCK)
		INNER JOIN Department D WITH(NOLOCK)
		ON D.DepartmentKey = U.DepartmentKey
		WHERE U.UserName = @UserName

	END TRY

  BEGIN CATCH
           DECLARE @ErrorNumber INT,  @ErrorSeverity INT,
                   @ErrorState INT,  @ErrorProcedure VARCHAR(200),
                   @ErrorLine INT,@ErrorMessage VARCHAR(4000), @Xactstate INT
          SELECT   @ErrorNumber =ERROR_NUMBER(),
                   @ErrorSeverity =ERROR_SEVERITY(),
                   @ErrorState =ERROR_STATE(),
                   @ErrorProcedure = isnull(ERROR_PROCEDURE(),'-'),
                   @ErrorLine =ERROR_LINE(),
                   @ErrorMessage =ERROR_MESSAGE(),
                   @Xactstate=XACT_STATE()
          IF @PrintError = 1
                BEGIN
                      PRINT ' Error ' + CONVERT(VARCHAR(50), @errornumber)
                      PRINT ' Severity ' + CONVERT(VARCHAR(5), @ErrorSeverity)
                      PRINT ' State ' + CONVERT(VARCHAR(5), @ErrorState)
                      PRINT ' Line ' + CONVERT(VARCHAR(5), @ErrorLine)
                      PRINT ' Procedure ' + CONVERT(VARCHAR(5), @ErrorProcedure)
                      PRINT @Errormessage;
                END
          IF @RaiseError = 1
             SET @Errormessage  = @Errormessage + ' Severity %d, Status %d, Line %d, Procedure %s';
                  RAISERROR (@ErrorMessage, @ErrorSeverity,
                                   1,@ErrorNumber,@ErrorSeverity,@ErrorState,@ErrorProcedure,@ErrorLine);
END CATCH
GO
--new stored procedures:
CREATE OR ALTER PROCEDURE [dbo].[GetStartUpData]

AS

DECLARE @InsertToErrorLog BIT= 1,@PrintError BIT = 0, @RaiseError BIT = 1
	BEGIN TRY
		SELECT * FROM dbo.Status S WITH(NOLOCK) ORDER BY Description
		SELECT * FROM Department WITH(NOLOCK) ORDER BY Department
		SELECT U.*, D.Department, D.DepartmentCode
		FROM UserProfile U WITH(NOLOCK)
		INNER JOIN Department D WITH(NOLOCK)
		ON D.DepartmentKey = U.DepartmentKey

	END TRY

  BEGIN CATCH
           DECLARE @ErrorNumber INT,  @ErrorSeverity INT,
                   @ErrorState INT,  @ErrorProcedure VARCHAR(200),
                   @ErrorLine INT,@ErrorMessage VARCHAR(4000), @Xactstate INT
          SELECT   @ErrorNumber =ERROR_NUMBER(),
                   @ErrorSeverity =ERROR_SEVERITY(),
                   @ErrorState =ERROR_STATE(),
                   @ErrorProcedure = isnull(ERROR_PROCEDURE(),'-'),
                   @ErrorLine =ERROR_LINE(),
                   @ErrorMessage =ERROR_MESSAGE(),
                   @Xactstate=XACT_STATE()
          IF @PrintError = 1
                BEGIN
                      PRINT ' Error ' + CONVERT(VARCHAR(50), @errornumber)
                      PRINT ' Severity ' + CONVERT(VARCHAR(5), @ErrorSeverity)
                      PRINT ' State ' + CONVERT(VARCHAR(5), @ErrorState)
                      PRINT ' Line ' + CONVERT(VARCHAR(5), @ErrorLine)
                      PRINT ' Procedure ' + CONVERT(VARCHAR(5), @ErrorProcedure)
                      PRINT @Errormessage;
                END
          IF @RaiseError = 1
             SET @Errormessage  = @Errormessage + ' Severity %d, Status %d, Line %d, Procedure %s';
                  RAISERROR (@ErrorMessage, @ErrorSeverity,
                                   1,@ErrorNumber,@ErrorSeverity,@ErrorState,@ErrorProcedure,@ErrorLine);
END CATCH
GO
USE [ITPS]
GO
ALTER   PROCEDURE [dbo].[Front_Page_Data_SEL]
(
       @UserProfileKey INT
)

AS

DECLARE @InsertToErrorLog BIT= 1,@PrintError BIT = 0, @RaiseError BIT = 1
	BEGIN TRY
		--Is this person IT?
		DECLARE @DepartmentCode VARCHAR(5)
		DECLARE @OpenCount INT, @UnassignedCount INT,@HistoricalOpenCount INT, @HistoricalClosedCount INT
		DECLARE @PastDueCount INT, @DepartmentCount INT
		SELECT @DepartmentCode = D.DepartmentCode FROM Department D WITH(NOLOCK) 
			INNER JOIN UserProfile U WITH(NOLOCK)
			ON D.DepartmentKey = U.DepartmentKey
		WHERE U.UserProfileKey = @UserProfileKey

		SELECT @DepartmentCount = COUNT(*) 
		FROM Ticket T WITH(NOLOCK)
			INNER JOIN UserProfile U WITH(NOLOCK)
			ON U.UserProfileKey = T.UserProfileKey
			INNER JOIN Status S WITH(NOLOCK)
			ON S.StatusKey = T.StatusKey
			INNER JOIN Department D WITH(NOLOCK)
			ON D.DepartmentKey = U.DepartmentKey
		WHERE S.ClosedInd = 0
		AND D.DepartmentCode = @DepartmentCode

		--Is IT?
		IF @DepartmentCode = 'IT'
		BEGIN
			--Get my open tickets
			SELECT @OpenCount = COUNT(*) 
			FROM Ticket T WITH(NOLOCK)
				INNER JOIN UserProfile U WITH(NOLOCK)
				ON U.UserProfileKey = T.AssignedToUserProfileKey
				INNER JOIN Status S WITH(NOLOCK)
				ON S.StatusKey = T.StatusKey
			WHERE T.AssignedToUserProfileKey = @UserProfileKey
			AND S.ClosedInd = 0
			--Get my Unassigned tickets
			SELECT @UnassignedCount = COUNT(*) 
			FROM Ticket T WITH(NOLOCK)
			WHERE ISNULL(AssignedToUserProfileKey,0) = 0
			--Get historical open tickets
			SELECT @HistoricalOpenCount = COUNT(*) 
			FROM Ticket T WITH(NOLOCK)
				INNER JOIN Status S WITH(NOLOCK)
				ON S.StatusKey = T.StatusKey
			WHERE  S.ClosedInd = 0	
			--Get historical closed tickets
			SELECT @HistoricalClosedCount = COUNT(*) 
			FROM Ticket T WITH(NOLOCK)
				INNER JOIN Status S WITH(NOLOCK)
				ON S.StatusKey = T.StatusKey
			WHERE  S.ClosedInd = 1	
			--Get past due count
			SELECT @PastDueCount = COUNT(*) FROM Ticket WITH(NOLOCK) WHERE DueDate <=GETDATE()
			--Return counts
			SELECT @OpenCount OpenCount, @UnassignedCount UnassignedCount,@HistoricalOpenCount HistoricalOpenCount, @HistoricalClosedCount HistoricalClosedCount,@PastDueCount PastDueCount, @DepartmentCount DepartmentCount
			--Get my top 10 open ticket
			SELECT TOP 10 T.*, S.Description Status, S.StatusCode, U.FirstName AssignedToFirstName, U.LastName AssignedToLastName FROM Ticket T WITH(NOLOCK)
			INNER JOIN UserProfile U WITH(NOLOCK)
			ON U.UserProfileKey = T.AssignedToUserProfileKey
			INNER JOIN Status S WITH(NOLOCK)
			ON S.StatusKey = T.StatusKey
			WHERE  S.ClosedInd = 0
			ORDER BY CreatedDateTime
			--Get my paste due/coming due open ticket
			SELECT TOP 10 T.*, S.Description Status, S.StatusCode, U.FirstName AssignedToFirstName, U.LastName AssignedToLastName FROM Ticket T WITH(NOLOCK)
			INNER JOIN UserProfile U WITH(NOLOCK)
			ON U.UserProfileKey = T.AssignedToUserProfileKey
			INNER JOIN Status S WITH(NOLOCK)
			ON S.StatusKey = T.StatusKey
			WHERE  S.ClosedInd = 0
			AND T.DueDate < GETDATE()+5 --next 10 days
			ORDER BY CreatedDateTime
			--Get monthly open/closed count
			SELECT MONTH(ISNULL(LastUpdatedDateTime,GETDATE())) TheMonth, Count(*) C 
			FROM Ticket T WITH(NOLOCK)
			INNER JOIN Status S WITH(NOLOCK)
			ON S.StatusKey = T.StatusKey
			WHERE  S.ClosedInd = 0
			GROUP BY ISNULL(LastUpdatedDateTime,GETDATE())
			SELECT MONTH(CreatedDateTime) TheMonth, Count(*) C 
			FROM Ticket T WITH(NOLOCK)
			GROUP BY MONTH(CreatedDateTime)
		END
		ELSE
		BEGIN
			--Get my open tickets
			SELECT @OpenCount = COUNT(*) 
			FROM Ticket T WITH(NOLOCK)
				INNER JOIN UserProfile U WITH(NOLOCK)
				ON U.UserProfileKey = T.AssignedToUserProfileKey
				INNER JOIN Status S WITH(NOLOCK)
				ON S.StatusKey = T.StatusKey
			WHERE T.UserProfileKey = @UserProfileKey
			AND S.ClosedInd = 0
			--Get my Unassigned tickets
			SELECT @UnassignedCount = COUNT(*) 
			FROM Ticket T WITH(NOLOCK)
				INNER JOIN Status S WITH(NOLOCK)
				ON S.StatusKey = T.StatusKey
			WHERE T.UserProfileKey = @UserProfileKey
			AND	ISNULL(T.AssignedToUserProfileKey,0) = 0
			--Get historical open tickets
			SELECT @HistoricalOpenCount = COUNT(*) 
			FROM Ticket T WITH(NOLOCK)
				INNER JOIN UserProfile U WITH(NOLOCK)
				ON U.UserProfileKey = T.UserProfileKey
				INNER JOIN Status S WITH(NOLOCK)
				ON S.StatusKey = T.StatusKey
			WHERE  S.ClosedInd = 0	
			AND U.UserProfileKey = @UserProfileKey
			--Get historical closed tickets
			SELECT @HistoricalClosedCount = COUNT(*) 
			FROM Ticket T WITH(NOLOCK)
				INNER JOIN UserProfile U WITH(NOLOCK)
				ON U.UserProfileKey = T.UserProfileKey
				INNER JOIN Status S WITH(NOLOCK)
				ON S.StatusKey = T.StatusKey
			WHERE  S.ClosedInd = 1	
			AND U.UserProfileKey = @UserProfileKey
			--Get past due count
			SELECT @PastDueCount = COUNT(*) 
			FROM Ticket T WITH(NOLOCK) 
				INNER JOIN UserProfile U WITH(NOLOCK)
				ON U.UserProfileKey = T.UserProfileKey
				INNER JOIN Status S WITH(NOLOCK)
				ON S.StatusKey = T.StatusKey
			WHERE DueDate <=GETDATE()
			AND U.UserProfileKey = @UserProfileKey
			AND S.StatusCode = 'WAITU'
			--Return counts
			SELECT @OpenCount OpenCount, @UnassignedCount UnassignedCount,@HistoricalOpenCount HistoricalOpenCount, @HistoricalClosedCount HistoricalClosedCount,@PastDueCount PastDueCount, @DepartmentCount DepartmentCount
			--Get my top 10 open ticket
			SELECT TOP 10 T.*, S.Description Status, S.StatusCode, U.FirstName AssignedToFirstName, U.LastName AssignedToLastName FROM Ticket T WITH(NOLOCK)
			INNER JOIN UserProfile U WITH(NOLOCK)
			ON U.UserProfileKey = T.AssignedToUserProfileKey
			INNER JOIN Status S WITH(NOLOCK)
			ON S.StatusKey = T.StatusKey
			WHERE  S.ClosedInd = 0
			AND U.UserProfileKey = @UserProfileKey
			ORDER BY CreatedDateTime
			--Get my paste due/coming due open ticket
			SELECT TOP 10 T.*, S.Description Status, S.StatusCode, U.FirstName AssignedToFirstName, U.LastName AssignedToLastName FROM Ticket T WITH(NOLOCK)
			INNER JOIN UserProfile U WITH(NOLOCK)
			ON U.UserProfileKey = T.AssignedToUserProfileKey
			INNER JOIN Status S WITH(NOLOCK)
			ON S.StatusKey = T.StatusKey
			WHERE  S.ClosedInd = 0
			AND T.DueDate < GETDATE()+5 --next 10 days
			AND U.UserProfileKey = @UserProfileKey
			ORDER BY CreatedDateTime
		END


	END TRY

  BEGIN CATCH
           DECLARE @ErrorNumber INT,  @ErrorSeverity INT,
                   @ErrorState INT,  @ErrorProcedure VARCHAR(200),
                   @ErrorLine INT,@ErrorMessage VARCHAR(4000), @Xactstate INT
          SELECT   @ErrorNumber =ERROR_NUMBER(),
                   @ErrorSeverity =ERROR_SEVERITY(),
                   @ErrorState =ERROR_STATE(),
                   @ErrorProcedure = isnull(ERROR_PROCEDURE(),'-'),
                   @ErrorLine =ERROR_LINE(),
                   @ErrorMessage =ERROR_MESSAGE(),
                   @Xactstate=XACT_STATE()
          IF @PrintError = 1
                BEGIN
                      PRINT ' Error ' + CONVERT(VARCHAR(50), @errornumber)
                      PRINT ' Severity ' + CONVERT(VARCHAR(5), @ErrorSeverity)
                      PRINT ' State ' + CONVERT(VARCHAR(5), @ErrorState)
                      PRINT ' Line ' + CONVERT(VARCHAR(5), @ErrorLine)
                      PRINT ' Procedure ' + CONVERT(VARCHAR(5), @ErrorProcedure)
                      PRINT @Errormessage;
                END
          IF @RaiseError = 1
             SET @Errormessage  = @Errormessage + ' Severity %d, Status %d, Line %d, Procedure %s';
                  RAISERROR (@ErrorMessage, @ErrorSeverity,
                                   1,@ErrorNumber,@ErrorSeverity,@ErrorState,@ErrorProcedure,@ErrorLine);
END CATCH

GO
CREATE PROCEDURE [dbo].[Ticket_SEL]
(
       @TicketKey INT
)

AS

DECLARE @InsertToErrorLog BIT= 1,@PrintError BIT = 0, @RaiseError BIT = 1
	BEGIN TRY
		--Ticket Data
			SELECT T.*
			FROM Ticket T WITH(NOLOCK)
			WHERE TicketKey= @TicketKey
		--Notes
			SELECT * FROM Note WITH(NOLOCK) WHERE TicketKey = @TicketKey AND ActiveInd = 1
		--Status History
			SELECT H.*, OS.Description OldStatus, NS.Description NewStatus FROM StatusHistory H WITH(NOLOCK) 
			INNER JOIN Status OS WITH(NOLOCK)
			ON OS.StatusKey = H.OldStatusKey
			INNER JOIN Status NS WITH(NOLOCK)
			ON NS.StatusKey = H.NewStatusKey
			WHERE TicketKey = @TicketKey
	END TRY

  BEGIN CATCH
           DECLARE @ErrorNumber INT,  @ErrorSeverity INT,
                   @ErrorState INT,  @ErrorProcedure VARCHAR(200),
                   @ErrorLine INT,@ErrorMessage VARCHAR(4000), @Xactstate INT
          SELECT   @ErrorNumber =ERROR_NUMBER(),
                   @ErrorSeverity =ERROR_SEVERITY(),
                   @ErrorState =ERROR_STATE(),
                   @ErrorProcedure = isnull(ERROR_PROCEDURE(),'-'),
                   @ErrorLine =ERROR_LINE(),
                   @ErrorMessage =ERROR_MESSAGE(),
                   @Xactstate=XACT_STATE()
          IF @PrintError = 1
                BEGIN
                      PRINT ' Error ' + CONVERT(VARCHAR(50), @errornumber)
                      PRINT ' Severity ' + CONVERT(VARCHAR(5), @ErrorSeverity)
                      PRINT ' State ' + CONVERT(VARCHAR(5), @ErrorState)
                      PRINT ' Line ' + CONVERT(VARCHAR(5), @ErrorLine)
                      PRINT ' Procedure ' + CONVERT(VARCHAR(5), @ErrorProcedure)
                      PRINT @Errormessage;
                END
          IF @RaiseError = 1
             SET @Errormessage  = @Errormessage + ' Severity %d, Status %d, Line %d, Procedure %s';
                  RAISERROR (@ErrorMessage, @ErrorSeverity,
                                   1,@ErrorNumber,@ErrorSeverity,@ErrorState,@ErrorProcedure,@ErrorLine);
END CATCH
GO
CREATE OR ALTER PROCEDURE [dbo].[Ticket_UPTINS]
(
       @TicketKey INT, 
	   @UserProfileKey INT,
	   @AssignedToUserProfileKey INT,
	   @ShortDescription VARCHAR(50),
	   @LongDescription VARCHAR(100),
	   @Priority INT,
	   @StatusKey INT,
	   @DueDate DATETIME,
	   @UserName VARCHAR(50)
)

AS

DECLARE @InsertToErrorLog BIT= 1,@PrintError BIT = 0, @RaiseError BIT = 1
	BEGIN TRY
	IF(@TicketKey=0) --INSERT
	BEGIN
		INSERT INTO Ticket 
			(UserProfileKey, AssignedToUserProfileKey, ShortDescription, LongDescription, Priority, StatusKey, DueDate,CreatedBy, CreatedDateTime)
		VALUES
			(@UserProfileKey, @AssignedToUserProfileKey, @ShortDescription, @LongDescription, @Priority, @StatusKey, @DueDate,@UserName, GETDATE())
		SELECT @@IDENTITY
	END
	ELSE
	BEGIN
		UPDATE Ticket SET 
			UserProfileKey = @UserProfileKey, 
			AssignedToUserProfileKey = @AssignedToUserProfileKey, 
			ShortDescription = @ShortDescription, 
			LongDescription = @LongDescription, 
			Priority = @Priority, 
			StatusKey = @StatusKey, 
			DueDate = @DueDate,
			LastUpdatedBy = @UserName,
			LastUpdatedDateTime = GETDATE()
		WHERE TicketKey = @TicketKey
		SELECT @TicketKey
	END

	END TRY

  BEGIN CATCH
           DECLARE @ErrorNumber INT,  @ErrorSeverity INT,
                   @ErrorState INT,  @ErrorProcedure VARCHAR(200),
                   @ErrorLine INT,@ErrorMessage VARCHAR(4000), @Xactstate INT
          SELECT   @ErrorNumber =ERROR_NUMBER(),
                   @ErrorSeverity =ERROR_SEVERITY(),
                   @ErrorState =ERROR_STATE(),
                   @ErrorProcedure = isnull(ERROR_PROCEDURE(),'-'),
                   @ErrorLine =ERROR_LINE(),
                   @ErrorMessage =ERROR_MESSAGE(),
                   @Xactstate=XACT_STATE()
          IF @PrintError = 1
                BEGIN
                      PRINT ' Error ' + CONVERT(VARCHAR(50), @errornumber)
                      PRINT ' Severity ' + CONVERT(VARCHAR(5), @ErrorSeverity)
                      PRINT ' State ' + CONVERT(VARCHAR(5), @ErrorState)
                      PRINT ' Line ' + CONVERT(VARCHAR(5), @ErrorLine)
                      PRINT ' Procedure ' + CONVERT(VARCHAR(5), @ErrorProcedure)
                      PRINT @Errormessage;
                END
          IF @RaiseError = 1
             SET @Errormessage  = @Errormessage + ' Severity %d, Status %d, Line %d, Procedure %s';
                  RAISERROR (@ErrorMessage, @ErrorSeverity,
                                   1,@ErrorNumber,@ErrorSeverity,@ErrorState,@ErrorProcedure,@ErrorLine);
END CATCH
GO
CREATE PROCEDURE [dbo].[TicketNote_INS]
(
       @Note VARCHAR(100),
	   @UserName VARCHAR(50),
	   @TicketKey INT
)

AS

DECLARE @InsertToErrorLog BIT= 1,@PrintError BIT = 0, @RaiseError BIT = 1
	BEGIN TRY
		INSERT Note (TicketKey, Note, CreatedDateTime, CreatedBy) VALUES (@TicketKey, @Note, GETDATE(), @UserName)
		SELECT @@IDENTITY
	END TRY

  BEGIN CATCH
           DECLARE @ErrorNumber INT,  @ErrorSeverity INT,
                   @ErrorState INT,  @ErrorProcedure VARCHAR(200),
                   @ErrorLine INT,@ErrorMessage VARCHAR(4000), @Xactstate INT
          SELECT   @ErrorNumber =ERROR_NUMBER(),
                   @ErrorSeverity =ERROR_SEVERITY(),
                   @ErrorState =ERROR_STATE(),
                   @ErrorProcedure = isnull(ERROR_PROCEDURE(),'-'),
                   @ErrorLine =ERROR_LINE(),
                   @ErrorMessage =ERROR_MESSAGE(),
                   @Xactstate=XACT_STATE()
          IF @PrintError = 1
                BEGIN
                      PRINT ' Error ' + CONVERT(VARCHAR(50), @errornumber)
                      PRINT ' Severity ' + CONVERT(VARCHAR(5), @ErrorSeverity)
                      PRINT ' State ' + CONVERT(VARCHAR(5), @ErrorState)
                      PRINT ' Line ' + CONVERT(VARCHAR(5), @ErrorLine)
                      PRINT ' Procedure ' + CONVERT(VARCHAR(5), @ErrorProcedure)
                      PRINT @Errormessage;
                END
          IF @RaiseError = 1
             SET @Errormessage  = @Errormessage + ' Severity %d, Status %d, Line %d, Procedure %s';
                  RAISERROR (@ErrorMessage, @ErrorSeverity,
                                   1,@ErrorNumber,@ErrorSeverity,@ErrorState,@ErrorProcedure,@ErrorLine);
END CATCH
GO
CREATE PROCEDURE [dbo].[GetReportingData]

AS

DECLARE @InsertToErrorLog BIT= 1,@PrintError BIT = 0, @RaiseError BIT = 1
	BEGIN TRY
		SELECT T.* , S.Description Status, U.FirstName + ' '+ U.LastName TicketOwnerDisplayName, S.ClosedInd, 
			CASE  
			WHEN ISNULL(A.FirstName,'') = '' THEN 'UNASSIGNED'
			ELSE A.FirstName + ' '+ A.LastName 
			END AssignedToDisplayName
		FROM Ticket T WITH(NOLOCK)
			INNER JOIN Status S WITH(NOLOCK)
			ON S.StatusKey = T.StatusKey
			INNER JOIN UserProfile U WITH(NOLOCK)
			ON U.UserProfileKey = T.UserProfileKey
			LEFT OUTER JOIN UserProfile A WITH(NOLOCK)
			ON T.AssignedToUserProfileKey = A.UserProfileKey


	END TRY

  BEGIN CATCH
           DECLARE @ErrorNumber INT,  @ErrorSeverity INT,
                   @ErrorState INT,  @ErrorProcedure VARCHAR(200),
                   @ErrorLine INT,@ErrorMessage VARCHAR(4000), @Xactstate INT
          SELECT   @ErrorNumber =ERROR_NUMBER(),
                   @ErrorSeverity =ERROR_SEVERITY(),
                   @ErrorState =ERROR_STATE(),
                   @ErrorProcedure = isnull(ERROR_PROCEDURE(),'-'),
                   @ErrorLine =ERROR_LINE(),
                   @ErrorMessage =ERROR_MESSAGE(),
                   @Xactstate=XACT_STATE()
          IF @PrintError = 1
                BEGIN
                      PRINT ' Error ' + CONVERT(VARCHAR(50), @errornumber)
                      PRINT ' Severity ' + CONVERT(VARCHAR(5), @ErrorSeverity)
                      PRINT ' State ' + CONVERT(VARCHAR(5), @ErrorState)
                      PRINT ' Line ' + CONVERT(VARCHAR(5), @ErrorLine)
                      PRINT ' Procedure ' + CONVERT(VARCHAR(5), @ErrorProcedure)
                      PRINT @Errormessage;
                END
          IF @RaiseError = 1
             SET @Errormessage  = @Errormessage + ' Severity %d, Status %d, Line %d, Procedure %s';
                  RAISERROR (@ErrorMessage, @ErrorSeverity,
                                   1,@ErrorNumber,@ErrorSeverity,@ErrorState,@ErrorProcedure,@ErrorLine);
END CATCH
GO
CREATE PROCEDURE [dbo].[Ticket_SELKeyByDescription]
(
       @SearchString VARCHAR(50)
)

AS

DECLARE @InsertToErrorLog BIT= 1,@PrintError BIT = 0, @RaiseError BIT = 1
	BEGIN TRY
		SELECT TicketKey FROM Ticket WITH(NOLOCK)
		WHERE ShortDescription LIKE '%' + @SearchString + '%'
		OR LongDescription LIKE '%' + @SearchString + '%'
	END TRY

  BEGIN CATCH
           DECLARE @ErrorNumber INT,  @ErrorSeverity INT,
                   @ErrorState INT,  @ErrorProcedure VARCHAR(200),
                   @ErrorLine INT,@ErrorMessage VARCHAR(4000), @Xactstate INT
          SELECT   @ErrorNumber =ERROR_NUMBER(),
                   @ErrorSeverity =ERROR_SEVERITY(),
                   @ErrorState =ERROR_STATE(),
                   @ErrorProcedure = isnull(ERROR_PROCEDURE(),'-'),
                   @ErrorLine =ERROR_LINE(),
                   @ErrorMessage =ERROR_MESSAGE(),
                   @Xactstate=XACT_STATE()
          IF @PrintError = 1
                BEGIN
                      PRINT ' Error ' + CONVERT(VARCHAR(50), @errornumber)
                      PRINT ' Severity ' + CONVERT(VARCHAR(5), @ErrorSeverity)
                      PRINT ' State ' + CONVERT(VARCHAR(5), @ErrorState)
                      PRINT ' Line ' + CONVERT(VARCHAR(5), @ErrorLine)
                      PRINT ' Procedure ' + CONVERT(VARCHAR(5), @ErrorProcedure)
                      PRINT @Errormessage;
                END
          IF @RaiseError = 1
             SET @Errormessage  = @Errormessage + ' Severity %d, Status %d, Line %d, Procedure %s';
                  RAISERROR (@ErrorMessage, @ErrorSeverity,
                                   1,@ErrorNumber,@ErrorSeverity,@ErrorState,@ErrorProcedure,@ErrorLine);
END CATCH
GO





CREATE PROCEDURE [dbo].[Ticket_SELDueDate]

AS

DECLARE @InsertToErrorLog BIT= 1,@PrintError BIT = 0, @RaiseError BIT = 1
	BEGIN TRY
		SELECT TicketKey,DueDate, ShortDescription FROM Ticket WITH(NOLOCK)
	END TRY

  BEGIN CATCH
           DECLARE @ErrorNumber INT,  @ErrorSeverity INT,
                   @ErrorState INT,  @ErrorProcedure VARCHAR(200),
                   @ErrorLine INT,@ErrorMessage VARCHAR(4000), @Xactstate INT
          SELECT   @ErrorNumber =ERROR_NUMBER(),
                   @ErrorSeverity =ERROR_SEVERITY(),
                   @ErrorState =ERROR_STATE(),
                   @ErrorProcedure = isnull(ERROR_PROCEDURE(),'-'),
                   @ErrorLine =ERROR_LINE(),
                   @ErrorMessage =ERROR_MESSAGE(),
                   @Xactstate=XACT_STATE()
          IF @PrintError = 1
                BEGIN
                      PRINT ' Error ' + CONVERT(VARCHAR(50), @errornumber)
                      PRINT ' Severity ' + CONVERT(VARCHAR(5), @ErrorSeverity)
                      PRINT ' State ' + CONVERT(VARCHAR(5), @ErrorState)
                      PRINT ' Line ' + CONVERT(VARCHAR(5), @ErrorLine)
                      PRINT ' Procedure ' + CONVERT(VARCHAR(5), @ErrorProcedure)
                      PRINT @Errormessage;
                END
          IF @RaiseError = 1
             SET @Errormessage  = @Errormessage + ' Severity %d, Status %d, Line %d, Procedure %s';
                  RAISERROR (@ErrorMessage, @ErrorSeverity,
                                   1,@ErrorNumber,@ErrorSeverity,@ErrorState,@ErrorProcedure,@ErrorLine);
END CATCH
GO
CREATE OR ALTER PROCEDURE [dbo].[Note_UPTActiveInd]
(
       @NoteKey INT,
	   @ActiveInd TINYINT
)

AS

DECLARE @InsertToErrorLog BIT= 1,@PrintError BIT = 0, @RaiseError BIT = 1
	BEGIN TRY
		UPDATE Note SET ActiveInd = @ActiveInd WHERE NoteKey = @NoteKey
	END TRY

  BEGIN CATCH
           DECLARE @ErrorNumber INT,  @ErrorSeverity INT,
                   @ErrorState INT,  @ErrorProcedure VARCHAR(200),
                   @ErrorLine INT,@ErrorMessage VARCHAR(4000), @Xactstate INT
          SELECT   @ErrorNumber =ERROR_NUMBER(),
                   @ErrorSeverity =ERROR_SEVERITY(),
                   @ErrorState =ERROR_STATE(),
                   @ErrorProcedure = isnull(ERROR_PROCEDURE(),'-'),
                   @ErrorLine =ERROR_LINE(),
                   @ErrorMessage =ERROR_MESSAGE(),
                   @Xactstate=XACT_STATE()
          IF @PrintError = 1
                BEGIN
                      PRINT ' Error ' + CONVERT(VARCHAR(50), @errornumber)
                      PRINT ' Severity ' + CONVERT(VARCHAR(5), @ErrorSeverity)
                      PRINT ' State ' + CONVERT(VARCHAR(5), @ErrorState)
                      PRINT ' Line ' + CONVERT(VARCHAR(5), @ErrorLine)
                      PRINT ' Procedure ' + CONVERT(VARCHAR(5), @ErrorProcedure)
                      PRINT @Errormessage;
                END
          IF @RaiseError = 1
             SET @Errormessage  = @Errormessage + ' Severity %d, Status %d, Line %d, Procedure %s';
                  RAISERROR (@ErrorMessage, @ErrorSeverity,
                                   1,@ErrorNumber,@ErrorSeverity,@ErrorState,@ErrorProcedure,@ErrorLine);
END CATCH
GO
