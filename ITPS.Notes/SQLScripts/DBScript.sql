USE [ITPS]
GO
CREATE TABLE [dbo].[Department](
	[DepartmentKey] [int] IDENTITY(1,1) NOT NULL,
	[DepartmentCode] [varchar](5) NOT NULL,
	[Department] [varchar](50) NOT NULL,
	[ActiveInd] [tinyint] NULL,
 CONSTRAINT [PK_Department] PRIMARY KEY CLUSTERED 
(
	[DepartmentKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE TABLE [dbo].[Note](
	[NoteKey] [int] IDENTITY(1,1) NOT NULL,
	[TicketKey] [int] NOT NULL,
	[Note] [varchar](100) NULL,
	[CreatedDateTime] [datetime] NULL,
	[CreatedBy] [varchar](50) NULL,
	[LastUpdatedDateTime] [datetime] NULL,
	[LastUpdatedBy] [varchar](50) NULL,
 CONSTRAINT [PK_Note] PRIMARY KEY CLUSTERED 
(
	[NoteKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE TABLE [dbo].[Status](
	[StatusKey] [int] IDENTITY(1,1) NOT NULL,
	[StatusCode] [varchar](5) NOT NULL,
	[Description] [varchar](50) NOT NULL,
	[ClosedInd] [int] NULL,
 CONSTRAINT [PK_Status] PRIMARY KEY CLUSTERED 
(
	[StatusKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE TABLE [dbo].[StatusHistory](
	[StatusHistoryKey] [int] IDENTITY(1,1) NOT NULL,
	[TicketKey] [int] NOT NULL,
	[OldStatusKey] [int] NULL,
	[NewStatusKey] [int] NULL,
	[UpdatedBy] [varchar](30) NULL,
	[DateOfChange] [datetime] NOT NULL,
 CONSTRAINT [PK_StatusHistory] PRIMARY KEY CLUSTERED 
(
	[StatusHistoryKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE TABLE [dbo].[Ticket](
	[TicketKey] [int] IDENTITY(1,1) NOT NULL,
	[UserProfileKey] [int] NULL,
	[AssignedToUserProfileKey] [int] NULL,
	[ShortDescription] [varchar](50) NULL,
	[LongDescription] [varchar](100) NULL,
	[Priority] [int] NULL,
	[StatusKey] [int] NULL,
	[DueDate] [datetime] NULL,
	[CreatedDateTime] [datetime] NULL,
	[CreatedBy] [varchar](50) NULL,
	[LastUpdatedDateTime] [datetime] NULL,
	[LastUpdatedBy] [varchar](50) NULL,
 CONSTRAINT [PK_Ticket] PRIMARY KEY CLUSTERED 
(
	[TicketKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE TABLE [dbo].[UserProfile](
	[UserProfileKey] [int] IDENTITY(1,1) NOT NULL,
	[FirstName] [varchar](50) NOT NULL,
	[LastName] [varchar](50) NOT NULL,
	[UserName] [varchar](50) NOT NULL,
	[Password] [varchar](50) NOT NULL,
	[EmailAddress] [varchar](50) NOT NULL,
	[PhoneNumber] [varchar](50) NULL,
	[ActiveInd] [tinyint] NULL,
	[DepartmentKey] [int] NOT NULL,
	[CreatedDateTime] [datetime] NULL,
 CONSTRAINT [PK_UserProfile] PRIMARY KEY CLUSTERED 
(
	[UserProfileKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Department] ADD  CONSTRAINT [DF_Department_ActiveInd]  DEFAULT ((1)) FOR [ActiveInd]
GO
ALTER TABLE [dbo].[UserProfile] ADD  CONSTRAINT [DF_UserProfile_ActiveInd]  DEFAULT ((1)) FOR [ActiveInd]
GO
ALTER TABLE [dbo].[UserProfile] ADD  CONSTRAINT [DF_UserProfile_CreateDateTime]  DEFAULT (getdate()) FOR [CreatedDateTime]
GO
ALTER TABLE [dbo].[Note]  WITH CHECK ADD  CONSTRAINT [FK_Note_Ticket] FOREIGN KEY([TicketKey])
REFERENCES [dbo].[Ticket] ([TicketKey])
GO
ALTER TABLE [dbo].[Note] CHECK CONSTRAINT [FK_Note_Ticket]
GO
ALTER TABLE [dbo].[StatusHistory]  WITH CHECK ADD  CONSTRAINT [FK_StatusHistory_Ticket] FOREIGN KEY([TicketKey])
REFERENCES [dbo].[Ticket] ([TicketKey])
GO
ALTER TABLE [dbo].[StatusHistory] CHECK CONSTRAINT [FK_StatusHistory_Ticket]
GO
ALTER TABLE [dbo].[UserProfile]  WITH CHECK ADD  CONSTRAINT [FK_UserProfile_Department] FOREIGN KEY([DepartmentKey])
REFERENCES [dbo].[Department] ([DepartmentKey])
GO
ALTER TABLE [dbo].[UserProfile] CHECK CONSTRAINT [FK_UserProfile_Department]
GO
CREATE   PROCEDURE [dbo].[User_SEL]
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
CREATE TRIGGER [dbo].[TR_Ticket_UPT] ON [dbo].[Ticket]
    FOR INSERT, UPDATE
AS
    DECLARE @login_name VARCHAR(128)
 
    SELECT  @login_name = login_name
    FROM    sys.dm_exec_sessions
    WHERE   session_id = @@SPID

    IF EXISTS ( SELECT * FROM Inserted ) AND EXISTS (SELECT * FROM Deleted)
        BEGIN
			DECLARE @OldStatusKey INT
			SELECT @OldStatusKey = StatusKey FROM Deleted

			UPDATE dbo.Ticket
			SET LastUpdatedBy = @login_name, LastUpdatedDateTime = GETDATE()
			WHERE TicketKey IN (SELECT TicketKey FROM Inserted)

			INSERT INTO StatusHistory 
				(TicketKey, OldStatusKey, NewStatusKey, UpdatedBy, DateOfChange)
				(SELECT TicketKey, @OldStatusKey, StatusKey, @login_name, GETDATE() FROM Inserted)
        END
    ELSE
        BEGIN
			UPDATE dbo.Ticket 
			SET CreatedBy = @login_name, CreatedDateTime = GETDATE()
			WHERE TicketKey IN (SELECT TicketKey FROM Inserted)
        END
GO
ALTER TRIGGER [dbo].[TR_Note_Upt] ON [dbo].[Note]
    FOR INSERT, UPDATE
AS
    DECLARE @login_name VARCHAR(128)
 
    SELECT  @login_name = login_name
    FROM    sys.dm_exec_sessions
    WHERE   session_id = @@SPID

    IF EXISTS ( SELECT * FROM Inserted ) AND EXISTS (SELECT * FROM Deleted)
        BEGIN
			UPDATE dbo.Note
			SET LastUpdatedBy = @login_name, LastUpdatedDateTime = GETDATE()
			WHERE TicketKey IN (SELECT TicketKey FROM Inserted)
        END
    ELSE
        BEGIN
			UPDATE dbo.Note 
			SET CreatedBy = @login_name, CreatedDateTime = GETDATE()
			WHERE TicketKey IN (SELECT TicketKey FROM Inserted)
        END
GO



