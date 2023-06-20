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
	[EmailAddress] [varchar](50) NOT NULL,
	[PhoneNumber] [varchar](50) NULL,
	[ActiveInd] [tinyint] NULL,
	[DepartmentKey] [int] NOT NULL,
	[CreateDateTime] [datetime] NULL,
 CONSTRAINT [PK_UserProfile] PRIMARY KEY CLUSTERED 
(
	[UserProfileKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [IX_UserProfile]    Script Date: 6/20/2023 8:17:07 AM ******/
CREATE NONCLUSTERED INDEX [IX_UserProfile] ON [dbo].[UserProfile]
(
	[DepartmentKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Department] ADD  CONSTRAINT [DF_Department_ActiveInd]  DEFAULT ((1)) FOR [ActiveInd]
GO
ALTER TABLE [dbo].[UserProfile] ADD  CONSTRAINT [DF_UserProfile_ActiveInd]  DEFAULT ((1)) FOR [ActiveInd]
GO
ALTER TABLE [dbo].[UserProfile] ADD  CONSTRAINT [DF_UserProfile_CreateDateTime]  DEFAULT (getdate()) FOR [CreateDateTime]
GO
ALTER TABLE [dbo].[UserProfile]  WITH CHECK ADD  CONSTRAINT [FK_UserProfile_Department] FOREIGN KEY([DepartmentKey])
REFERENCES [dbo].[Department] ([DepartmentKey])
GO
ALTER TABLE [dbo].[UserProfile] CHECK CONSTRAINT [FK_UserProfile_Department]
GO
