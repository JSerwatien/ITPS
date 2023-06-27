CREATE OR ALTER PROCEDURE [dbo].[User_SEL]
(
       @UserName VARCHAR(50)
)

AS

DECLARE @InsertToErrorLog BIT= 1,@PrintError BIT = 0, @RaiseError BIT = 1
	BEGIN TRY
		SELECT U.*, D.DepartmentCode, D.Department
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
CREATE OR ALTER PROCEDURE [dbo].[Status_SEL]
(
       @StatusCode int
)

AS

DECLARE @InsertToErrorLog BIT= 1,@PrintError BIT = 0, @RaiseError BIT = 1
	BEGIN TRY
		SELECT S.*, T.TicketKey 
		FROM dbo.Status S WITH(NOLOCK)
		INNER JOIN dbo.Ticket WITH (NOLOCK)
		ON S.StatusCode = T.StatusKey
		WHERE S.StatusCode = @StatusCode
		ORDER BY StatusCodeKey

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

--INCOMPLETE STORED PROCEDURE

CREATE OR ALTER PROCEDURE [dbo].[Front_Page_Data_SEL]
(
       @UserName VARCHAR(50)
)

AS

DECLARE @InsertToErrorLog BIT= 1,@PrintError BIT = 0, @RaiseError BIT = 1
	BEGIN TRY
		SELECT U.UserName, Count(S.ClosedInd) 'Closed Tickets', COUNT(T.TicketKey) - COUNT (S.ClosedIND) 'Open Tickets'  
		FROM	UserProfile U WITH(NOLOCK)
		INNER JOIN Ticket T WITH(NOLOCK)
		ON T.UserProfilekey = U.UserProfileKey
		INNER JOIN Status S WITH (NOLOCK)
		ON S.TicketKey = T.TicketKey   -- needs ticket key in ticket table??
		WHERE U.UserName = @UserName
		Group by S.TicketKey

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