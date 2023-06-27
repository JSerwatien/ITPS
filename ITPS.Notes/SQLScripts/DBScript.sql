CREATE DATABASE [ITPS]
GO
USE [ITPS]
GO
/****** Object:  Table [dbo].[Department]    Script Date: 6/20/2023 8:17:07 AM ******/
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
/****** Object:  Table [dbo].[UserProfile]    Script Date: 6/20/2023 8:17:07 AM ******/
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

ALTER TABLE [dbo].[UserProfile] ADD  CONSTRAINT [DF_UserProfile_ActiveInd]  DEFAULT ((1)) FOR [ActiveInd]
GO

ALTER TABLE [dbo].[UserProfile] ADD  CONSTRAINT [DF_UserProfile_CreateDateTime]  DEFAULT (getdate()) FOR [CreatedDateTime]
GO

ALTER TABLE [dbo].[UserProfile]  WITH CHECK ADD  CONSTRAINT [FK_UserProfile_Department] FOREIGN KEY([DepartmentKey])
REFERENCES [dbo].[Department] ([DepartmentKey])
GO

ALTER TABLE [dbo].[UserProfile] CHECK CONSTRAINT [FK_UserProfile_Department]
GO


CREATE TABLE [dbo].[Ticket](
	[UserProfileKey] [int] IDENTITY(1,1) NOT NULL,
	[AssignedToUserProfileKey] [int] NULL,
	[ShortDescription] [varchar](50) NULL,
	[LongDescription] [varchar](100) NULL,
	[Priority][int] NULL,
	[StatusKey][int] NULL,
	[DueDate][datetime] NULL,
	CreatedDateTime datetime NULL,
	CreatedByUserProfileKey int NULL,
	LastUpdatedDateTime datetime NULL,
	LastUpdatedByUserProfileKey int NULL
)


CREATE TABLE [dbo].[Status](
	[StatusCode][int]IDENTITY(1,1)NOT NULL,
	[Description][varchar](50)NOT NULL,
	[ClosedInd][int]NULL
)

CREATE TABLE [dbo].[Notes](
	[NoteKey][int]IDENTITY(1,1)NOT NULL,
	[TicketKey][int]NOT NULL,
	[Note][varchar](100)NULL,
	CreatedDateTime datetime NULL,
	CreatedByUserProfileKey int NULL,
	LastUpdatedDateTime datetime NULL,
	LastUpdatedByUserProfileKey int NULL
)
CREATE TABLE [dbo].[StatusHistory](
	StatusHistoryKey int IDENTITY (1,1) NOT NULL,
	TicketKey int NOT NULL,
	OldStatusKey int NULL,
	NewStatusKey int NULL,
	UpdatedBy varchar (30) NOT NULL,
	DateOfChange datetime NOT NULL
)