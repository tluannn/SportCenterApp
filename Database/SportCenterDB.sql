/*******************************************************************************
 * SPORT CENTER DATABASE SCRIPT (SCHEMA + SEED DATA)
 * Target: Microsoft SQL Server 2019 / 2022 / Express / LocalDB
 *******************************************************************************/
USE [master];
GO

IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'SportCenterDB')
BEGIN
    CREATE DATABASE [SportCenterDB];
END
GO

USE [SportCenterDB];
GO

/****** Object:  Table [dbo].[attendance]    Script Date: 10/22/2026 3:48:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[attendance](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[class_session_id] [int] NOT NULL,
	[member_id] [int] NOT NULL,
	[status] [varchar](30) NOT NULL,
	[marked_by] [int] NOT NULL,
	[marked_at] [datetime2](7) NOT NULL,
	[note] [nvarchar](500) NULL,
 CONSTRAINT [pk_attendance] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [uq_attendance_session_member] UNIQUE NONCLUSTERED 
(
	[class_session_id] ASC,
	[member_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[attendance_history]    Script Date: 10/22/2026 3:48:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[attendance_history](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[attendance_id] [int] NOT NULL,
	[old_status] [varchar](30) NULL,
	[new_status] [varchar](30) NOT NULL,
	[changed_by] [int] NOT NULL,
	[changed_at] [datetime2](7) NOT NULL,
	[reason] [nvarchar](500) NULL,
 CONSTRAINT [pk_attendance_history] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[class]    Script Date: 10/22/2026 3:48:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[class](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[capacity] [int] NOT NULL,
	[name] [nvarchar](100) NOT NULL,
	[status] [varchar](30) NOT NULL,
	[coach_id] [int] NOT NULL,
	[course_offering_id] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[class_session]    Script Date: 10/22/2026 3:48:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[class_session](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[class_id] [int] NOT NULL,
	[facility_id] [int] NULL,
	[start_time] [datetime] NOT NULL,
	[end_time] [datetime] NOT NULL,
	[status] [varchar](30) NOT NULL,
 CONSTRAINT [pk_class_session] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[coach]    Script Date: 10/22/2026 3:48:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[coach](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[status] [varchar](30) NOT NULL,
	[user_id] [int] NOT NULL,
	[image_url] [nvarchar](500) NULL,
	[bio] [nvarchar](1000) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UKbf8qggp2dw21lvbe4tskf1k20] UNIQUE NONCLUSTERED 
(
	[user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[coach_sport]    Script Date: 10/22/2026 3:48:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[coach_sport](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[certification] [nvarchar](255) NULL,
	[experience_years] [int] NOT NULL,
	[coach_id] [int] NOT NULL,
	[sport_id] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UK4wptcqqec8tbf2t6gxtbbw9sc] UNIQUE NONCLUSTERED 
(
	[coach_id] ASC,
	[sport_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[consultation_request]    Script Date: 10/22/2026 3:48:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[consultation_request](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[member_id] [int] NULL,
	[name] [nvarchar](100) NOT NULL,
	[phone] [nvarchar](20) NOT NULL,
	[email] [nvarchar](150) NULL,
	[sport_id] [int] NOT NULL,
	[age] [int] NULL,
	[experience] [nvarchar](max) NULL,
	[note] [nvarchar](max) NULL,
	[status] [varchar](20) NOT NULL,
	[created_at] [datetime2](6) NOT NULL,
	[handled_by] [int] NULL,
	[handled_at] [datetime2](6) NULL,
	[resolution_note] [nvarchar](1000) NULL,
	[completed_at] [datetime2](6) NULL,
	[cancelled_at] [datetime2](6) NULL,
 CONSTRAINT [pk_consultation_request] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[course]    Script Date: 10/22/2026 3:48:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[course](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[description] [nvarchar](max) NULL,
	[learning_outcome] [nvarchar](max) NULL,
	[level] [varchar](50) NULL,
	[name] [nvarchar](255) NOT NULL,
	[status] [varchar](50) NOT NULL,
	[target_age_max] [int] NULL,
	[target_age_min] [int] NULL,
	[sport_id] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[course_offering]    Script Date: 10/22/2026 3:48:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[course_offering](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[cancellation_deadline] [datetime2](7) NOT NULL,
	[end_date] [date] NOT NULL,
	[name] [nvarchar](150) NOT NULL,
	[planned_sessions] [int] NULL,
	[price] [numeric](12, 2) NOT NULL,
	[registration_deadline] [datetime2](7) NOT NULL,
	[session_duration] [int] NOT NULL,
	[start_date] [date] NOT NULL,
	[status] [varchar](30) NOT NULL,
	[course_id] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[course_registration]    Script Date: 10/22/2026 3:48:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[course_registration](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[member_id] [int] NOT NULL,
	[class_id] [int] NOT NULL,
	[status] [varchar](20) NOT NULL,
	[registered_at] [datetime2](7) NOT NULL,
	[cancelled_at] [datetime2](7) NULL,
	[original_price] [decimal](12, 2) NOT NULL,
	[membership_discount] [decimal](12, 2) NOT NULL,
	[final_price] [decimal](12, 2) NOT NULL,
 CONSTRAINT [pk_course_registration] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[facility]    Script Date: 10/22/2026 3:48:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[facility](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](100) NOT NULL,
	[status] [varchar](30) NOT NULL,
	[type] [nvarchar](50) NOT NULL,
	[sport_id] [int] NOT NULL,
	[image_url] [nvarchar](500) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[member_profile]    Script Date: 10/22/2026 3:48:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[member_profile](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[goal] [nvarchar](max) NULL,
	[height] [numeric](5, 2) NULL,
	[updated_at] [datetime2](7) NOT NULL,
	[weight] [numeric](5, 2) NULL,
	[member_id] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UKc87j55l2co10d3t5m5xmbutu1] UNIQUE NONCLUSTERED 
(
	[member_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[member_sport_level]    Script Date: 10/22/2026 3:48:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[member_sport_level](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[member_id] [int] NOT NULL,
	[sport_id] [int] NOT NULL,
	[level] [varchar](20) NOT NULL,
	[verified_by_coach_id] [int] NULL,
	[verified_at] [datetime2](6) NULL,
	[updated_at] [datetime2](6) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[membership]    Script Date: 10/22/2026 3:48:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[membership](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[auto_renew] [bit] NOT NULL,
	[end_date] [date] NOT NULL,
	[start_date] [date] NOT NULL,
	[status] [varchar](30) NOT NULL,
	[member_id] [int] NOT NULL,
	[plan_id] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[membership_plan]    Script Date: 10/22/2026 3:48:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[membership_plan](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[allow_one_on_one_coaching] [bit] NOT NULL,
	[allow_personal_training_plan] [bit] NOT NULL,
	[course_discount_percent] [numeric](5, 2) NOT NULL,
	[description] [nvarchar](max) NULL,
	[duration_months] [int] NOT NULL,
	[name] [nvarchar](100) NOT NULL,
	[personal_training_discount_percent] [numeric](5, 2) NOT NULL,
	[price] [numeric](12, 2) NOT NULL,
	[status] [varchar](30) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[payment]    Script Date: 10/22/2026 3:48:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[payment](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[member_id] [int] NOT NULL,
	[amount] [decimal](12, 2) NOT NULL,
	[method] [varchar](20) NOT NULL,
	[purpose] [varchar](30) NOT NULL,
	[reference_id] [int] NOT NULL,
	[auto_renew] [bit] NULL,
	[status] [varchar](20) NOT NULL,
	[transaction_code] [varchar](40) NOT NULL,
	[processed_by] [int] NULL,
	[note] [nvarchar](500) NULL,
	[created_at] [datetime2](6) NOT NULL,
	[paid_at] [datetime2](6) NULL,
 CONSTRAINT [pk_payment] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [uq_payment_txn] UNIQUE NONCLUSTERED 
(
	[transaction_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[personal_training_booking]    Script Date: 10/22/2026 3:48:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[personal_training_booking](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[member_id] [int] NOT NULL,
	[coach_id] [int] NOT NULL,
	[sport_id] [int] NOT NULL,
	[start_time] [datetime] NOT NULL,
	[end_time] [datetime] NOT NULL,
	[original_price] [decimal](12, 2) NOT NULL,
	[discount] [decimal](12, 2) NOT NULL,
	[final_price] [decimal](12, 2) NOT NULL,
	[status] [varchar](30) NOT NULL,
	[created_at] [datetime] NOT NULL,
	[payment_expires_at] [datetime] NULL,
 CONSTRAINT [pk_personal_training_booking] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[skill_assessment]    Script Date: 10/22/2026 3:48:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[skill_assessment](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[member_id] [int] NOT NULL,
	[sport_id] [int] NOT NULL,
	[assigned_coach_id] [int] NOT NULL,
	[requested_by_user_id] [int] NOT NULL,
	[status] [varchar](20) NOT NULL,
	[assessed_level] [varchar](20) NULL,
	[notes] [nvarchar](1000) NULL,
	[created_at] [datetime2](6) NOT NULL,
	[assessed_at] [datetime2](6) NULL,
	[cancelled_at] [datetime2](6) NULL,
	[consultation_request_id] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[sport]    Script Date: 10/22/2026 3:48:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[sport](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[description] [nvarchar](max) NULL,
	[name] [nvarchar](100) NOT NULL,
	[status] [varchar](30) NOT NULL,
	[image_url] [nvarchar](500) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UK63em0e8bcxm3pqjooy08wquan] UNIQUE NONCLUSTERED 
(
	[name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[users]    Script Date: 10/22/2026 3:48:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[users](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[ages] [int] NULL,
	[created_at] [datetime2](7) NOT NULL,
	[date_of_birth] [date] NULL,
	[email] [varchar](150) NOT NULL,
	[gender] [varchar](1) NULL,
	[name] [nvarchar](100) NOT NULL,
	[password_hash] [varchar](255) NOT NULL,
	[phone] [varchar](20) NULL,
	[role] [varchar](30) NOT NULL,
	[status] [varchar](30) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UK6dotkott2kjsp8vw4d0m25fb7] UNIQUE NONCLUSTERED 
(
	[email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [ix_consultation_handler_status]    Script Date: 10/22/2026 3:48:01 PM ******/
CREATE NONCLUSTERED INDEX [ix_consultation_handler_status] ON [dbo].[consultation_request]
(
	[handled_by] ASC,
	[status] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [ix_consultation_member_created]    Script Date: 10/22/2026 3:48:01 PM ******/
CREATE NONCLUSTERED INDEX [ix_consultation_member_created] ON [dbo].[consultation_request]
(
	[member_id] ASC,
	[created_at] DESC,
	[id] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [ix_consultation_status_created]    Script Date: 10/22/2026 3:48:01 PM ******/
CREATE NONCLUSTERED INDEX [ix_consultation_status_created] ON [dbo].[consultation_request]
(
	[status] ASC,
	[created_at] DESC,
	[id] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [ix_course_registration_class_status]    Script Date: 10/22/2026 3:48:01 PM ******/
CREATE NONCLUSTERED INDEX [ix_course_registration_class_status] ON [dbo].[course_registration]
(
	[class_id] ASC,
	[status] ASC,
	[registered_at] DESC,
	[id] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [ix_course_registration_member_status]    Script Date: 10/22/2026 3:48:01 PM ******/
CREATE NONCLUSTERED INDEX [ix_course_registration_member_status] ON [dbo].[course_registration]
(
	[member_id] ASC,
	[status] ASC,
	[registered_at] DESC,
	[id] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [ux_course_registration_confirmed]    Script Date: 10/22/2026 3:48:01 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [ux_course_registration_confirmed] ON [dbo].[course_registration]
(
	[member_id] ASC,
	[class_id] ASC
)
WHERE ([status]='CONFIRMED')
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [uk_member_sport_level]    Script Date: 10/22/2026 3:48:01 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [uk_member_sport_level] ON [dbo].[member_sport_level]
(
	[member_id] ASC,
	[sport_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [ix_payment_member]    Script Date: 10/22/2026 3:48:01 PM ******/
CREATE NONCLUSTERED INDEX [ix_payment_member] ON [dbo].[payment]
(
	[member_id] ASC,
	[created_at] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [ix_payment_paid_at]    Script Date: 10/22/2026 3:48:01 PM ******/
CREATE NONCLUSTERED INDEX [ix_payment_paid_at] ON [dbo].[payment]
(
	[status] ASC,
	[paid_at] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [ix_payment_reference]    Script Date: 10/22/2026 3:48:01 PM ******/
CREATE NONCLUSTERED INDEX [ix_payment_reference] ON [dbo].[payment]
(
	[purpose] ASC,
	[reference_id] ASC,
	[status] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [ix_pt_booking_coach_time]    Script Date: 10/22/2026 3:48:01 PM ******/
CREATE NONCLUSTERED INDEX [ix_pt_booking_coach_time] ON [dbo].[personal_training_booking]
(
	[coach_id] ASC,
	[start_time] ASC,
	[end_time] ASC,
	[status] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [ix_pt_booking_member_time]    Script Date: 10/22/2026 3:48:01 PM ******/
CREATE NONCLUSTERED INDEX [ix_pt_booking_member_time] ON [dbo].[personal_training_booking]
(
	[member_id] ASC,
	[start_time] ASC,
	[end_time] ASC,
	[status] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [ix_assessment_consultation]    Script Date: 10/22/2026 3:48:01 PM ******/
CREATE NONCLUSTERED INDEX [ix_assessment_consultation] ON [dbo].[skill_assessment]
(
	[consultation_request_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [uk_skill_assessment_pending]    Script Date: 10/22/2026 3:48:01 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [uk_skill_assessment_pending] ON [dbo].[skill_assessment]
(
	[member_id] ASC,
	[sport_id] ASC
)
WHERE ([status]='PENDING')
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[consultation_request] ADD  CONSTRAINT [df_consultation_request_status]  DEFAULT ('PENDING') FOR [status]
GO
ALTER TABLE [dbo].[consultation_request] ADD  CONSTRAINT [df_consultation_request_created]  DEFAULT (sysdatetime()) FOR [created_at]
GO
ALTER TABLE [dbo].[course_registration] ADD  CONSTRAINT [df_course_registration_status]  DEFAULT ('CONFIRMED') FOR [status]
GO
ALTER TABLE [dbo].[course_registration] ADD  CONSTRAINT [df_course_registration_registered_at]  DEFAULT (sysdatetime()) FOR [registered_at]
GO
ALTER TABLE [dbo].[personal_training_booking] ADD  CONSTRAINT [df_personal_training_booking_created_at]  DEFAULT (getdate()) FOR [created_at]
GO
ALTER TABLE [dbo].[attendance]  WITH CHECK ADD  CONSTRAINT [fk_attendance_marked_by] FOREIGN KEY([marked_by])
REFERENCES [dbo].[users] ([id])
GO
ALTER TABLE [dbo].[attendance] CHECK CONSTRAINT [fk_attendance_marked_by]
GO
ALTER TABLE [dbo].[attendance]  WITH CHECK ADD  CONSTRAINT [fk_attendance_member] FOREIGN KEY([member_id])
REFERENCES [dbo].[users] ([id])
GO
ALTER TABLE [dbo].[attendance] CHECK CONSTRAINT [fk_attendance_member]
GO
ALTER TABLE [dbo].[attendance]  WITH CHECK ADD  CONSTRAINT [fk_attendance_session] FOREIGN KEY([class_session_id])
REFERENCES [dbo].[class_session] ([id])
GO
ALTER TABLE [dbo].[attendance] CHECK CONSTRAINT [fk_attendance_session]
GO
ALTER TABLE [dbo].[attendance_history]  WITH CHECK ADD  CONSTRAINT [fk_attendance_history_attendance] FOREIGN KEY([attendance_id])
REFERENCES [dbo].[attendance] ([id])
GO
ALTER TABLE [dbo].[attendance_history] CHECK CONSTRAINT [fk_attendance_history_attendance]
GO
ALTER TABLE [dbo].[attendance_history]  WITH CHECK ADD  CONSTRAINT [fk_attendance_history_changed_by] FOREIGN KEY([changed_by])
REFERENCES [dbo].[users] ([id])
GO
ALTER TABLE [dbo].[attendance_history] CHECK CONSTRAINT [fk_attendance_history_changed_by]
GO
ALTER TABLE [dbo].[class]  WITH CHECK ADD  CONSTRAINT [FKb33tj9hgv0ttg1qqokby27361] FOREIGN KEY([coach_id])
REFERENCES [dbo].[coach] ([id])
GO
ALTER TABLE [dbo].[class] CHECK CONSTRAINT [FKb33tj9hgv0ttg1qqokby27361]
GO
ALTER TABLE [dbo].[class]  WITH CHECK ADD  CONSTRAINT [FKs42soxb8xaru6c6r2v143i02g] FOREIGN KEY([course_offering_id])
REFERENCES [dbo].[course_offering] ([id])
GO
ALTER TABLE [dbo].[class] CHECK CONSTRAINT [FKs42soxb8xaru6c6r2v143i02g]
GO
ALTER TABLE [dbo].[class_session]  WITH CHECK ADD  CONSTRAINT [fk_class_session_class] FOREIGN KEY([class_id])
REFERENCES [dbo].[class] ([id])
GO
ALTER TABLE [dbo].[class_session] CHECK CONSTRAINT [fk_class_session_class]
GO
ALTER TABLE [dbo].[class_session]  WITH CHECK ADD  CONSTRAINT [fk_class_session_facility] FOREIGN KEY([facility_id])
REFERENCES [dbo].[facility] ([id])
GO
ALTER TABLE [dbo].[class_session] CHECK CONSTRAINT [fk_class_session_facility]
GO
ALTER TABLE [dbo].[coach]  WITH CHECK ADD  CONSTRAINT [FKggj3lbwo8fwqcicu4fdbr0t49] FOREIGN KEY([user_id])
REFERENCES [dbo].[users] ([id])
GO
ALTER TABLE [dbo].[coach] CHECK CONSTRAINT [FKggj3lbwo8fwqcicu4fdbr0t49]
GO
ALTER TABLE [dbo].[coach_sport]  WITH CHECK ADD  CONSTRAINT [FKngo3k5p9ny85atg4fonp5r8oa] FOREIGN KEY([coach_id])
REFERENCES [dbo].[coach] ([id])
GO
ALTER TABLE [dbo].[coach_sport] CHECK CONSTRAINT [FKngo3k5p9ny85atg4fonp5r8oa]
GO
ALTER TABLE [dbo].[coach_sport]  WITH CHECK ADD  CONSTRAINT [FKt6e035rvau40269qq23nrcr0d] FOREIGN KEY([sport_id])
REFERENCES [dbo].[sport] ([id])
GO
ALTER TABLE [dbo].[coach_sport] CHECK CONSTRAINT [FKt6e035rvau40269qq23nrcr0d]
GO
ALTER TABLE [dbo].[consultation_request]  WITH CHECK ADD  CONSTRAINT [fk_consultation_handler] FOREIGN KEY([handled_by])
REFERENCES [dbo].[users] ([id])
GO
ALTER TABLE [dbo].[consultation_request] CHECK CONSTRAINT [fk_consultation_handler]
GO
ALTER TABLE [dbo].[consultation_request]  WITH CHECK ADD  CONSTRAINT [fk_consultation_member] FOREIGN KEY([member_id])
REFERENCES [dbo].[users] ([id])
GO
ALTER TABLE [dbo].[consultation_request] CHECK CONSTRAINT [fk_consultation_member]
GO
ALTER TABLE [dbo].[consultation_request]  WITH CHECK ADD  CONSTRAINT [fk_consultation_sport] FOREIGN KEY([sport_id])
REFERENCES [dbo].[sport] ([id])
GO
ALTER TABLE [dbo].[consultation_request] CHECK CONSTRAINT [fk_consultation_sport]
GO
ALTER TABLE [dbo].[course]  WITH CHECK ADD  CONSTRAINT [FK5a8vlob7d3rigskp5tekqsfdw] FOREIGN KEY([sport_id])
REFERENCES [dbo].[sport] ([id])
GO
ALTER TABLE [dbo].[course] CHECK CONSTRAINT [FK5a8vlob7d3rigskp5tekqsfdw]
GO
ALTER TABLE [dbo].[course_offering]  WITH CHECK ADD  CONSTRAINT [FKoodk5pyofbxvbxlupvw86p507] FOREIGN KEY([course_id])
REFERENCES [dbo].[course] ([id])
GO
ALTER TABLE [dbo].[course_offering] CHECK CONSTRAINT [FKoodk5pyofbxvbxlupvw86p507]
GO
ALTER TABLE [dbo].[course_registration]  WITH CHECK ADD  CONSTRAINT [fk_course_registration_class] FOREIGN KEY([class_id])
REFERENCES [dbo].[class] ([id])
GO
ALTER TABLE [dbo].[course_registration] CHECK CONSTRAINT [fk_course_registration_class]
GO
ALTER TABLE [dbo].[course_registration]  WITH CHECK ADD  CONSTRAINT [fk_course_registration_member] FOREIGN KEY([member_id])
REFERENCES [dbo].[users] ([id])
GO
ALTER TABLE [dbo].[course_registration] CHECK CONSTRAINT [fk_course_registration_member]
GO
ALTER TABLE [dbo].[facility]  WITH CHECK ADD  CONSTRAINT [FKgytfjta74c6hyqasd7nieygpt] FOREIGN KEY([sport_id])
REFERENCES [dbo].[sport] ([id])
GO
ALTER TABLE [dbo].[facility] CHECK CONSTRAINT [FKgytfjta74c6hyqasd7nieygpt]
GO
ALTER TABLE [dbo].[member_profile]  WITH CHECK ADD  CONSTRAINT [FKd073r846xc6obxrhmokrxwand] FOREIGN KEY([member_id])
REFERENCES [dbo].[users] ([id])
GO
ALTER TABLE [dbo].[member_profile] CHECK CONSTRAINT [FKd073r846xc6obxrhmokrxwand]
GO
ALTER TABLE [dbo].[member_sport_level]  WITH CHECK ADD  CONSTRAINT [fk_msl_coach] FOREIGN KEY([verified_by_coach_id])
REFERENCES [dbo].[coach] ([id])
GO
ALTER TABLE [dbo].[member_sport_level] CHECK CONSTRAINT [fk_msl_coach]
GO
ALTER TABLE [dbo].[member_sport_level]  WITH CHECK ADD  CONSTRAINT [fk_msl_member] FOREIGN KEY([member_id])
REFERENCES [dbo].[users] ([id])
GO
ALTER TABLE [dbo].[member_sport_level] CHECK CONSTRAINT [fk_msl_member]
GO
ALTER TABLE [dbo].[member_sport_level]  WITH CHECK ADD  CONSTRAINT [fk_msl_sport] FOREIGN KEY([sport_id])
REFERENCES [dbo].[sport] ([id])
GO
ALTER TABLE [dbo].[member_sport_level] CHECK CONSTRAINT [fk_msl_sport]
GO
ALTER TABLE [dbo].[membership]  WITH CHECK ADD  CONSTRAINT [FKf2tecaeulos65nfnphbbh8bfa] FOREIGN KEY([plan_id])
REFERENCES [dbo].[membership_plan] ([id])
GO
ALTER TABLE [dbo].[membership] CHECK CONSTRAINT [FKf2tecaeulos65nfnphbbh8bfa]
GO
ALTER TABLE [dbo].[membership]  WITH CHECK ADD  CONSTRAINT [FKp7fqidolu7rib6emjarsvno6s] FOREIGN KEY([member_id])
REFERENCES [dbo].[users] ([id])
GO
ALTER TABLE [dbo].[membership] CHECK CONSTRAINT [FKp7fqidolu7rib6emjarsvno6s]
GO
ALTER TABLE [dbo].[payment]  WITH CHECK ADD  CONSTRAINT [fk_payment_member] FOREIGN KEY([member_id])
REFERENCES [dbo].[users] ([id])
GO
ALTER TABLE [dbo].[payment] CHECK CONSTRAINT [fk_payment_member]
GO
ALTER TABLE [dbo].[payment]  WITH CHECK ADD  CONSTRAINT [fk_payment_processed_by] FOREIGN KEY([processed_by])
REFERENCES [dbo].[users] ([id])
GO
ALTER TABLE [dbo].[payment] CHECK CONSTRAINT [fk_payment_processed_by]
GO
ALTER TABLE [dbo].[personal_training_booking]  WITH CHECK ADD  CONSTRAINT [fk_pt_booking_coach] FOREIGN KEY([coach_id])
REFERENCES [dbo].[coach] ([id])
GO
ALTER TABLE [dbo].[personal_training_booking] CHECK CONSTRAINT [fk_pt_booking_coach]
GO
ALTER TABLE [dbo].[personal_training_booking]  WITH CHECK ADD  CONSTRAINT [fk_pt_booking_member] FOREIGN KEY([member_id])
REFERENCES [dbo].[users] ([id])
GO
ALTER TABLE [dbo].[personal_training_booking] CHECK CONSTRAINT [fk_pt_booking_member]
GO
ALTER TABLE [dbo].[personal_training_booking]  WITH CHECK ADD  CONSTRAINT [fk_pt_booking_sport] FOREIGN KEY([sport_id])
REFERENCES [dbo].[sport] ([id])
GO
ALTER TABLE [dbo].[personal_training_booking] CHECK CONSTRAINT [fk_pt_booking_sport]
GO
ALTER TABLE [dbo].[skill_assessment]  WITH CHECK ADD  CONSTRAINT [fk_assessment_consultation] FOREIGN KEY([consultation_request_id])
REFERENCES [dbo].[consultation_request] ([id])
GO
ALTER TABLE [dbo].[skill_assessment] CHECK CONSTRAINT [fk_assessment_consultation]
GO
ALTER TABLE [dbo].[skill_assessment]  WITH CHECK ADD  CONSTRAINT [fk_sa_coach] FOREIGN KEY([assigned_coach_id])
REFERENCES [dbo].[coach] ([id])
GO
ALTER TABLE [dbo].[skill_assessment] CHECK CONSTRAINT [fk_sa_coach]
GO
ALTER TABLE [dbo].[skill_assessment]  WITH CHECK ADD  CONSTRAINT [fk_sa_member] FOREIGN KEY([member_id])
REFERENCES [dbo].[users] ([id])
GO
ALTER TABLE [dbo].[skill_assessment] CHECK CONSTRAINT [fk_sa_member]
GO
ALTER TABLE [dbo].[skill_assessment]  WITH CHECK ADD  CONSTRAINT [fk_sa_requester] FOREIGN KEY([requested_by_user_id])
REFERENCES [dbo].[users] ([id])
GO
ALTER TABLE [dbo].[skill_assessment] CHECK CONSTRAINT [fk_sa_requester]
GO
ALTER TABLE [dbo].[skill_assessment]  WITH CHECK ADD  CONSTRAINT [fk_sa_sport] FOREIGN KEY([sport_id])
REFERENCES [dbo].[sport] ([id])
GO
ALTER TABLE [dbo].[skill_assessment] CHECK CONSTRAINT [fk_sa_sport]
GO
ALTER TABLE [dbo].[attendance]  WITH CHECK ADD  CONSTRAINT [ck_attendance_status] CHECK  (([status]='EXCUSED' OR [status]='ABSENT' OR [status]='PRESENT'))
GO
ALTER TABLE [dbo].[attendance] CHECK CONSTRAINT [ck_attendance_status]
GO
ALTER TABLE [dbo].[attendance_history]  WITH CHECK ADD  CONSTRAINT [ck_attendance_history_new_status] CHECK  (([new_status]='EXCUSED' OR [new_status]='ABSENT' OR [new_status]='PRESENT'))
GO
ALTER TABLE [dbo].[attendance_history] CHECK CONSTRAINT [ck_attendance_history_new_status]
GO
ALTER TABLE [dbo].[attendance_history]  WITH CHECK ADD  CONSTRAINT [ck_attendance_history_old_status] CHECK  (([old_status] IS NULL OR ([old_status]='EXCUSED' OR [old_status]='ABSENT' OR [old_status]='PRESENT')))
GO
ALTER TABLE [dbo].[attendance_history] CHECK CONSTRAINT [ck_attendance_history_old_status]
GO
ALTER TABLE [dbo].[consultation_request]  WITH CHECK ADD  CONSTRAINT [ck_consultation_request_age] CHECK  (([age] IS NULL OR [age]>=(1) AND [age]<=(120)))
GO
ALTER TABLE [dbo].[consultation_request] CHECK CONSTRAINT [ck_consultation_request_age]
GO
ALTER TABLE [dbo].[consultation_request]  WITH CHECK ADD  CONSTRAINT [ck_consultation_request_name] CHECK  ((len(ltrim(rtrim([name])))>(0)))
GO
ALTER TABLE [dbo].[consultation_request] CHECK CONSTRAINT [ck_consultation_request_name]
GO
ALTER TABLE [dbo].[consultation_request]  WITH CHECK ADD  CONSTRAINT [ck_consultation_request_phone] CHECK  ((len(ltrim(rtrim([phone])))>(0)))
GO
ALTER TABLE [dbo].[consultation_request] CHECK CONSTRAINT [ck_consultation_request_phone]
GO
ALTER TABLE [dbo].[consultation_request]  WITH CHECK ADD  CONSTRAINT [ck_consultation_request_status] CHECK  (([status]='CANCELLED' OR [status]='COMPLETED' OR [status]='IN_PROGRESS' OR [status]='PENDING'))
GO
ALTER TABLE [dbo].[consultation_request] CHECK CONSTRAINT [ck_consultation_request_status]
GO
ALTER TABLE [dbo].[course_registration]  WITH CHECK ADD  CONSTRAINT [ck_course_registration_status] CHECK  (([status]='CANCELLED' OR [status]='CONFIRMED'))
GO
ALTER TABLE [dbo].[course_registration] CHECK CONSTRAINT [ck_course_registration_status]
GO
ALTER TABLE [dbo].[member_sport_level]  WITH CHECK ADD  CONSTRAINT [ck_msl_level] CHECK  (([level]='ADVANCED' OR [level]='INTERMEDIATE' OR [level]='BEGINNER'))
GO
ALTER TABLE [dbo].[member_sport_level] CHECK CONSTRAINT [ck_msl_level]
GO
ALTER TABLE [dbo].[payment]  WITH CHECK ADD  CONSTRAINT [ck_payment_amount] CHECK  (([amount]>=(0)))
GO
ALTER TABLE [dbo].[payment] CHECK CONSTRAINT [ck_payment_amount]
GO
ALTER TABLE [dbo].[payment]  WITH CHECK ADD  CONSTRAINT [ck_payment_method] CHECK  (([method]='COUNTER' OR [method]='ONLINE'))
GO
ALTER TABLE [dbo].[payment] CHECK CONSTRAINT [ck_payment_method]
GO
ALTER TABLE [dbo].[payment]  WITH CHECK ADD  CONSTRAINT [ck_payment_purpose] CHECK  (([purpose]='PT_BOOKING' OR [purpose]='COURSE_REGISTRATION' OR [purpose]='MEMBERSHIP'))
GO
ALTER TABLE [dbo].[payment] CHECK CONSTRAINT [ck_payment_purpose]
GO
ALTER TABLE [dbo].[payment]  WITH CHECK ADD  CONSTRAINT [ck_payment_status] CHECK  (([status]='REFUND_REQUIRED' OR [status]='CANCELLED' OR [status]='SUCCESS' OR [status]='PENDING'))
GO
ALTER TABLE [dbo].[payment] CHECK CONSTRAINT [ck_payment_status]
GO
ALTER TABLE [dbo].[personal_training_booking]  WITH CHECK ADD  CONSTRAINT [ck_personal_training_booking_payment_expiry] CHECK  (([status]<>'PENDING_PAYMENT' OR [payment_expires_at] IS NOT NULL))
GO
ALTER TABLE [dbo].[personal_training_booking] CHECK CONSTRAINT [ck_personal_training_booking_payment_expiry]
GO
ALTER TABLE [dbo].[personal_training_booking]  WITH CHECK ADD  CONSTRAINT [ck_personal_training_booking_prices] CHECK  (([original_price]>=(0) AND [discount]>=(0) AND [final_price]>=(0)))
GO
ALTER TABLE [dbo].[personal_training_booking] CHECK CONSTRAINT [ck_personal_training_booking_prices]
GO
ALTER TABLE [dbo].[personal_training_booking]  WITH CHECK ADD  CONSTRAINT [ck_personal_training_booking_status] CHECK  (([status]='EXPIRED' OR [status]='CANCELLED' OR [status]='CONFIRMED' OR [status]='PENDING_PAYMENT'))
GO
ALTER TABLE [dbo].[personal_training_booking] CHECK CONSTRAINT [ck_personal_training_booking_status]
GO
ALTER TABLE [dbo].[personal_training_booking]  WITH CHECK ADD  CONSTRAINT [ck_personal_training_booking_times] CHECK  (([end_time]>[start_time]))
GO
ALTER TABLE [dbo].[personal_training_booking] CHECK CONSTRAINT [ck_personal_training_booking_times]
GO
ALTER TABLE [dbo].[skill_assessment]  WITH CHECK ADD  CONSTRAINT [ck_sa_level] CHECK  (([assessed_level] IS NULL OR ([assessed_level]='ADVANCED' OR [assessed_level]='INTERMEDIATE' OR [assessed_level]='BEGINNER')))
GO
ALTER TABLE [dbo].[skill_assessment] CHECK CONSTRAINT [ck_sa_level]
GO
ALTER TABLE [dbo].[skill_assessment]  WITH CHECK ADD  CONSTRAINT [ck_sa_status] CHECK  (([status]='CANCELLED' OR [status]='COMPLETED' OR [status]='PENDING'))
GO
ALTER TABLE [dbo].[skill_assessment] CHECK CONSTRAINT [ck_sa_status]
GO
USE [master]
GO
ALTER DATABASE [SportCenterDB] SET  READ_WRITE 
GO

/****** SEED DATA FOR SPORTCENTER APP ******/
USE [SportCenterDB];
GO

-- Data for table [users] (9 rows)
SET IDENTITY_INSERT [dbo].[users] ON;
INSERT INTO [dbo].[users] ([id], [created_at], [date_of_birth], [email], [gender], [name], [password_hash], [phone], [role], [status]) VALUES (1, '2026-10-25 13:00:54.735', '1985-03-14 00:00:00.000', N'demo.admin@sportcenter.test', NULL, N'Demo Administrator', N'$2a$10$PIxW2W5q2XSnyv7QQHU6uOhA04cfV23doIIcA5rcFjUsFefPB0G/a', NULL, N'ADMIN', N'ACTIVE');
INSERT INTO [dbo].[users] ([id], [created_at], [date_of_birth], [email], [gender], [name], [password_hash], [phone], [role], [status]) VALUES (2, '2026-10-25 20:12:02.316', '1992-04-12 00:00:00.000', N'demo.receptionist@sportcenter.test', N'F', N'Riley Morgan', N'$2a$10$qCbeEp5u/FCO5XbrRTQ4SOIj.L9KG7prsaI.0LVsiwjIw6sow4JRO', N'0900000101', N'RECEPTIONIST', N'ACTIVE');
INSERT INTO [dbo].[users] ([id], [created_at], [date_of_birth], [email], [gender], [name], [password_hash], [phone], [role], [status]) VALUES (3, '2026-10-25 20:12:02.731', NULL, N'demo.coach1@sportcenter.test', N'M', N'Jordan Lee', N'$2a$10$bB3Anc9qj4od6/zrVOMTfOyC439pLMNjCIdMiqkc/9ZIKVPqDqTKm', N'0900000201', N'COACH', N'ACTIVE');
INSERT INTO [dbo].[users] ([id], [created_at], [date_of_birth], [email], [gender], [name], [password_hash], [phone], [role], [status]) VALUES (4, '2026-10-25 20:12:02.878', NULL, N'demo.coach2@sportcenter.test', N'F', N'Casey Nguyen', N'$2a$10$j.wwksmJT1hcXIs9F46EDOuMY1O6Zj/yCYCF8055OQauJHjhANNWC', N'0900000202', N'COACH', N'ACTIVE');
INSERT INTO [dbo].[users] ([id], [created_at], [date_of_birth], [email], [gender], [name], [password_hash], [phone], [role], [status]) VALUES (5, '2026-10-25 20:12:02.981', '2001-03-12 00:00:00.000', N'demo.member1@sportcenter.test', N'F', N'Avery Chen', N'$2a$10$PQJbXc3C6Xjyzq.MLyY/1Ouqfcd1mcgMBajYqBOJjl9fz/fismEVC', N'0900000301', N'MEMBER', N'ACTIVE');
INSERT INTO [dbo].[users] ([id], [created_at], [date_of_birth], [email], [gender], [name], [password_hash], [phone], [role], [status]) VALUES (6, '2026-10-25 20:12:03.063', '1998-11-04 00:00:00.000', N'demo.member2@sportcenter.test', N'M', N'Noah Tran', N'$2a$10$fQYFAHRdcXu0Ir2tfbNDCeoNVtCKaCP39wmHd2.Shn0WvOlOTReNi', N'0900000302', N'MEMBER', N'ACTIVE');
INSERT INTO [dbo].[users] ([id], [created_at], [date_of_birth], [email], [gender], [name], [password_hash], [phone], [role], [status]) VALUES (7, '2026-10-25 20:12:03.145', '2003-06-28 00:00:00.000', N'demo.member3@sportcenter.test', N'F', N'Mia Pham', N'$2a$10$gQOiocDi9P0H5HB.6Sz1hO1nc0FqNYaHA.0BOIaSGEiIaaIUcETJu', N'0900000303', N'MEMBER', N'ACTIVE');
INSERT INTO [dbo].[users] ([id], [created_at], [date_of_birth], [email], [gender], [name], [password_hash], [phone], [role], [status]) VALUES (8, '2026-10-25 20:12:03.221', '1995-01-19 00:00:00.000', N'demo.member4@sportcenter.test', N'M', N'Ethan Vo', N'$2a$10$5bXEqSY9YImKH622Q/rVQupXjW8i/Ck5SSGuXpJjnS0uoQ6/BEC9S', N'0900000304', N'MEMBER', N'ACTIVE');
INSERT INTO [dbo].[users] ([id], [created_at], [date_of_birth], [email], [gender], [name], [password_hash], [phone], [role], [status]) VALUES (9, '2026-11-02 12:51:01.180', '1992-01-26 00:00:00.000', N'flowyoga@pembee.online', NULL, N'William', N'$2a$10$N24.x8d6XEu5aATPUo9nsOJOluK3tptqt/iG9qrbkqrRpYjE.tkey', N'1234567890', N'MEMBER', N'ACTIVE');
SET IDENTITY_INSERT [dbo].[users] OFF;
GO

-- Data for table [coach] (2 rows)
SET IDENTITY_INSERT [dbo].[coach] ON;
INSERT INTO [dbo].[coach] ([id], [status], [user_id], [image_url], [bio]) VALUES (1, N'ACTIVE', 3, N'/api/public/images/bb3ee9ec-3ec6-4938-92c7-afa44029932d.jpg', N'Fictional demo coach for racket sports.');
INSERT INTO [dbo].[coach] ([id], [status], [user_id], [image_url], [bio]) VALUES (2, N'ACTIVE', 4, N'/api/public/images/eb43cc8b-b4d9-472b-abb1-f7b2dbff1f6d.jpg', N'Fictional demo coach for court and pool sports.');
SET IDENTITY_INSERT [dbo].[coach] OFF;
GO

-- Data for table [sport] (6 rows)
SET IDENTITY_INSERT [dbo].[sport] ON;
INSERT INTO [dbo].[sport] ([id], [description], [name], [status], [image_url]) VALUES (1, N'Indoor racket sport training.', N'Badminton', N'ACTIVE', N'/api/public/images/bb3de32c-2bee-466d-9148-2290cbce6f05.jpg');
INSERT INTO [dbo].[sport] ([id], [description], [name], [status], [image_url]) VALUES (2, N'Team basketball training.', N'Basketball', N'ACTIVE', N'/api/public/images/ea834768-8ee1-4f8c-bae1-65884daa2529.jpg');
INSERT INTO [dbo].[sport] ([id], [description], [name], [status], [image_url]) VALUES (3, N'Pool swimming instruction.', N'Swimming', N'ACTIVE', N'/api/public/images/9ff097c3-7eb8-4804-a4c8-9b23ab386a05.jpg');
INSERT INTO [dbo].[sport] ([id], [description], [name], [status], [image_url]) VALUES (4, N'Tennis fundamentals and practice.', N'Tennis', N'ACTIVE', N'/api/public/images/768b5e19-125d-45b4-9630-c5de604b6523.jpg');
INSERT INTO [dbo].[sport] ([id], [description], [name], [status], [image_url]) VALUES (5, N'Mobility and balance sessions.', N'Yoga', N'ACTIVE', N'/api/public/images/6c3bac71-5bca-4bc2-9419-7bee6f7d4526.jpg');
INSERT INTO [dbo].[sport] ([id], [description], [name], [status], [image_url]) VALUES (6, N'General fitness and conditioning.', N'Fitness', N'ACTIVE', N'/api/public/images/28f6f7a2-569e-4877-b284-e4ac30ec5895.jpg');
SET IDENTITY_INSERT [dbo].[sport] OFF;
GO

-- Data for table [coach_sport] (6 rows)
SET IDENTITY_INSERT [dbo].[coach_sport] ON;
INSERT INTO [dbo].[coach_sport] ([id], [certification], [experience_years], [coach_id], [sport_id]) VALUES (1, N'Demo coaching certification', 5, 1, 1);
INSERT INTO [dbo].[coach_sport] ([id], [certification], [experience_years], [coach_id], [sport_id]) VALUES (2, N'Demo coaching certification', 4, 1, 4);
INSERT INTO [dbo].[coach_sport] ([id], [certification], [experience_years], [coach_id], [sport_id]) VALUES (3, N'Demo coaching certification', 6, 2, 2);
INSERT INTO [dbo].[coach_sport] ([id], [certification], [experience_years], [coach_id], [sport_id]) VALUES (4, N'Demo coaching certification', 5, 2, 3);
INSERT INTO [dbo].[coach_sport] ([id], [certification], [experience_years], [coach_id], [sport_id]) VALUES (5, N'Demo coaching certification', 3, 2, 5);
INSERT INTO [dbo].[coach_sport] ([id], [certification], [experience_years], [coach_id], [sport_id]) VALUES (1002, N'Demo coaching certification', 1, 2, 6);
SET IDENTITY_INSERT [dbo].[coach_sport] OFF;
GO

-- Data for table [facility] (3 rows)
SET IDENTITY_INSERT [dbo].[facility] ON;
INSERT INTO [dbo].[facility] ([id], [name], [status], [type], [sport_id], [image_url]) VALUES (1, N'Demo Court One', N'ACTIVE', N'Indoor Court', 1, NULL);
INSERT INTO [dbo].[facility] ([id], [name], [status], [type], [sport_id], [image_url]) VALUES (2, N'Demo Basketball Hall', N'ACTIVE', N'Basketball Court', 2, NULL);
INSERT INTO [dbo].[facility] ([id], [name], [status], [type], [sport_id], [image_url]) VALUES (3, N'Demo Aquatics Pool', N'ACTIVE', N'Swimming Pool', 3, NULL);
SET IDENTITY_INSERT [dbo].[facility] OFF;
GO

-- Data for table [facility_sport] (4 rows)
INSERT INTO [dbo].[facility_sport] ([facility_id], [sport_id]) VALUES (1, 1);
INSERT INTO [dbo].[facility_sport] ([facility_id], [sport_id]) VALUES (2, 2);
INSERT INTO [dbo].[facility_sport] ([facility_id], [sport_id]) VALUES (3, 3);
INSERT INTO [dbo].[facility_sport] ([facility_id], [sport_id]) VALUES (1, 4);
GO

-- Data for table [course] (9 rows)
SET IDENTITY_INSERT [dbo].[course] ON;
INSERT INTO [dbo].[course] ([id], [description], [learning_outcome], [level], [name], [status], [target_age_max], [target_age_min], [sport_id], [age_policy]) VALUES (1, N'Fictional beginner badminton course.', N'Learn safe movement, grip, and rally basics.', N'BEGINNER', N'Badminton Foundations', N'ACTIVE', 65, 16, 1, N'RECOMMENDED');
INSERT INTO [dbo].[course] ([id], [description], [learning_outcome], [level], [name], [status], [target_age_max], [target_age_min], [sport_id], [age_policy]) VALUES (2, N'Fictional beginner basketball course.', N'Practice dribbling, passing, and shooting.', N'BEGINNER', N'Basketball Fundamentals', N'ACTIVE', 65, 16, 2, N'RECOMMENDED');
INSERT INTO [dbo].[course] ([id], [description], [learning_outcome], [level], [name], [status], [target_age_max], [target_age_min], [sport_id], [age_policy]) VALUES (3, N'Fictional beginner swimming course.', N'Build water confidence and basic strokes.', N'BEGINNER', N'Learn to Swim', N'ACTIVE', 65, 16, 3, N'RECOMMENDED');
INSERT INTO [dbo].[course] ([id], [description], [learning_outcome], [level], [name], [status], [target_age_max], [target_age_min], [sport_id], [age_policy]) VALUES (4, N'Fictional beginner tennis course.', N'Practice ready position and basic groundstrokes.', N'BEGINNER', N'Tennis Foundations', N'ACTIVE', 65, 16, 4, N'RECOMMENDED');
INSERT INTO [dbo].[course] ([id], [description], [learning_outcome], [level], [name], [status], [target_age_max], [target_age_min], [sport_id], [age_policy]) VALUES (5, N'Fictional beginner yoga course.', N'Practice balance, breathing, and mobility.', N'BEGINNER', N'Yoga Mobility', N'ACTIVE', 65, 16, 5, N'RECOMMENDED');
INSERT INTO [dbo].[course] ([id], [description], [learning_outcome], [level], [name], [status], [target_age_max], [target_age_min], [sport_id], [age_policy]) VALUES (6, N'Fictional beginner fitness course.', N'Learn safe bodyweight conditioning.', N'BEGINNER', N'Fitness Conditioning', N'ACTIVE', 65, 16, 6, N'RECOMMENDED');
INSERT INTO [dbo].[course] ([id], [description], [learning_outcome], [level], [name], [status], [target_age_max], [target_age_min], [sport_id], [age_policy]) VALUES (7, N'', N'', N'BEGINNER', N'Basketball U21', N'ACTIVE', 20, 16, 2, N'RECOMMENDED');
INSERT INTO [dbo].[course] ([id], [description], [learning_outcome], [level], [name], [status], [target_age_max], [target_age_min], [sport_id], [age_policy]) VALUES (1002, N'', N'trong 1 tháng là có khả năng đánh tốt', N'INTERMEDIATE', N'Cầu lông nâng cao cấp tốc', N'ACTIVE', 30, 16, 1, N'RECOMMENDED');
INSERT INTO [dbo].[course] ([id], [description], [learning_outcome], [level], [name], [status], [target_age_max], [target_age_min], [sport_id], [age_policy]) VALUES (2002, N'', N'', N'BEGINNER', N'Badminton cơ bản', N'ACTIVE', 25, 10, 1, N'RECOMMENDED');
SET IDENTITY_INSERT [dbo].[course] OFF;
GO

-- Data for table [course_offering] (4 rows)
SET IDENTITY_INSERT [dbo].[course_offering] ON;
INSERT INTO [dbo].[course_offering] ([id], [cancellation_deadline], [end_date], [name], [planned_sessions], [price], [registration_deadline], [session_duration], [start_date], [status], [course_id]) VALUES (1, '2026-11-10 18:00:00.000', '2026-12-15 00:00:00.000', N'Badminton Foundations Nov 2026', 2, 250000.00, '2026-11-05 18:00:00.000', 60, '2026-11-15 00:00:00.000', N'OPEN', 1);
INSERT INTO [dbo].[course_offering] ([id], [cancellation_deadline], [end_date], [name], [planned_sessions], [price], [registration_deadline], [session_duration], [start_date], [status], [course_id]) VALUES (2, '2026-11-10 18:00:00.000', '2026-12-15 00:00:00.000', N'Basketball Fundamentals Nov 2026', 2, 275000.00, '2026-11-05 18:00:00.000', 60, '2026-11-15 00:00:00.000', N'OPEN', 2);
INSERT INTO [dbo].[course_offering] ([id], [cancellation_deadline], [end_date], [name], [planned_sessions], [price], [registration_deadline], [session_duration], [start_date], [status], [course_id]) VALUES (3, '2026-11-10 18:00:00.000', '2026-12-15 00:00:00.000', N'Learn to Swim Nov 2026', 2, 300000.00, '2026-11-05 18:00:00.000', 60, '2026-11-15 00:00:00.000', N'OPEN', 3);
INSERT INTO [dbo].[course_offering] ([id], [cancellation_deadline], [end_date], [name], [planned_sessions], [price], [registration_deadline], [session_duration], [start_date], [status], [course_id]) VALUES (1002, '2026-11-08 22:43:00.000', '2027-01-31 00:00:00.000', N'Spring-2027', 20, 2000000.00, '2026-11-04 22:43:00.000', 90, '2027-01-01 00:00:00.000', N'OPEN', 1002);
SET IDENTITY_INSERT [dbo].[course_offering] OFF;
GO

-- Data for table [class] (6 rows)
SET IDENTITY_INSERT [dbo].[class] ON;
INSERT INTO [dbo].[class] ([id], [capacity], [name], [status], [coach_id], [course_offering_id]) VALUES (1, 12, N'Demo Badminton Class', N'ACTIVE', 1, 1);
INSERT INTO [dbo].[class] ([id], [capacity], [name], [status], [coach_id], [course_offering_id]) VALUES (2, 14, N'Demo Basketball Class', N'ACTIVE', 2, 2);
INSERT INTO [dbo].[class] ([id], [capacity], [name], [status], [coach_id], [course_offering_id]) VALUES (3, 10, N'Demo Swimming Class', N'ACTIVE', 2, 3);
INSERT INTO [dbo].[class] ([id], [capacity], [name], [status], [coach_id], [course_offering_id]) VALUES (4, 8, N'BA01', N'ACTIVE', 1, 1002);
INSERT INTO [dbo].[class] ([id], [capacity], [name], [status], [coach_id], [course_offering_id]) VALUES (1004, 12, N'Demo Badminton Class 2', N'ACTIVE', 1, 1);
INSERT INTO [dbo].[class] ([id], [capacity], [name], [status], [coach_id], [course_offering_id]) VALUES (2004, 20, N'Lớp Yoga Thể Thao Pro 154954', N'ACTIVE', 1, 1);
SET IDENTITY_INSERT [dbo].[class] OFF;
GO

-- Data for table [class_session] (30 rows)
SET IDENTITY_INSERT [dbo].[class_session] ON;
INSERT INTO [dbo].[class_session] ([id], [class_id], [facility_id], [start_time], [end_time], [status]) VALUES (1, 1, 1, '2026-11-17 09:00:00.000', '2026-11-17 10:00:00.000', N'SCHEDULED');
INSERT INTO [dbo].[class_session] ([id], [class_id], [facility_id], [start_time], [end_time], [status]) VALUES (2, 1, 1, '2026-11-24 09:00:00.000', '2026-11-24 10:00:00.000', N'SCHEDULED');
INSERT INTO [dbo].[class_session] ([id], [class_id], [facility_id], [start_time], [end_time], [status]) VALUES (3, 2, 2, '2026-11-18 11:00:00.000', '2026-11-18 12:00:00.000', N'SCHEDULED');
INSERT INTO [dbo].[class_session] ([id], [class_id], [facility_id], [start_time], [end_time], [status]) VALUES (4, 2, 2, '2026-11-25 11:00:00.000', '2026-11-25 12:00:00.000', N'SCHEDULED');
INSERT INTO [dbo].[class_session] ([id], [class_id], [facility_id], [start_time], [end_time], [status]) VALUES (5, 3, 3, '2026-11-19 13:00:00.000', '2026-11-19 14:00:00.000', N'SCHEDULED');
INSERT INTO [dbo].[class_session] ([id], [class_id], [facility_id], [start_time], [end_time], [status]) VALUES (6, 3, 3, '2026-11-26 13:00:00.000', '2026-11-26 14:00:00.000', N'SCHEDULED');
INSERT INTO [dbo].[class_session] ([id], [class_id], [facility_id], [start_time], [end_time], [status]) VALUES (7, 4, 1, '2027-01-01 05:00:00.000', '2027-01-01 06:30:00.000', N'SCHEDULED');
INSERT INTO [dbo].[class_session] ([id], [class_id], [facility_id], [start_time], [end_time], [status]) VALUES (8, 4, 1, '2027-01-02 05:00:00.000', '2027-01-02 06:30:00.000', N'SCHEDULED');
INSERT INTO [dbo].[class_session] ([id], [class_id], [facility_id], [start_time], [end_time], [status]) VALUES (9, 4, 1, '2027-01-04 05:00:00.000', '2027-01-04 06:30:00.000', N'SCHEDULED');
INSERT INTO [dbo].[class_session] ([id], [class_id], [facility_id], [start_time], [end_time], [status]) VALUES (10, 4, 1, '2027-01-05 05:00:00.000', '2027-01-05 06:30:00.000', N'SCHEDULED');
INSERT INTO [dbo].[class_session] ([id], [class_id], [facility_id], [start_time], [end_time], [status]) VALUES (11, 4, 1, '2027-01-06 05:00:00.000', '2027-01-06 06:30:00.000', N'SCHEDULED');
INSERT INTO [dbo].[class_session] ([id], [class_id], [facility_id], [start_time], [end_time], [status]) VALUES (12, 4, 1, '2027-01-07 05:00:00.000', '2027-01-07 06:30:00.000', N'SCHEDULED');
INSERT INTO [dbo].[class_session] ([id], [class_id], [facility_id], [start_time], [end_time], [status]) VALUES (13, 4, 1, '2027-01-08 05:00:00.000', '2027-01-08 06:30:00.000', N'SCHEDULED');
INSERT INTO [dbo].[class_session] ([id], [class_id], [facility_id], [start_time], [end_time], [status]) VALUES (14, 4, 1, '2027-01-09 05:00:00.000', '2027-01-09 06:30:00.000', N'SCHEDULED');
INSERT INTO [dbo].[class_session] ([id], [class_id], [facility_id], [start_time], [end_time], [status]) VALUES (15, 4, 1, '2027-01-11 05:00:00.000', '2027-01-11 06:30:00.000', N'SCHEDULED');
INSERT INTO [dbo].[class_session] ([id], [class_id], [facility_id], [start_time], [end_time], [status]) VALUES (16, 4, 1, '2027-01-12 05:00:00.000', '2027-01-12 06:30:00.000', N'SCHEDULED');
INSERT INTO [dbo].[class_session] ([id], [class_id], [facility_id], [start_time], [end_time], [status]) VALUES (17, 4, 1, '2027-01-13 05:00:00.000', '2027-01-13 06:30:00.000', N'SCHEDULED');
INSERT INTO [dbo].[class_session] ([id], [class_id], [facility_id], [start_time], [end_time], [status]) VALUES (18, 4, 1, '2027-01-14 05:00:00.000', '2027-01-14 06:30:00.000', N'SCHEDULED');
INSERT INTO [dbo].[class_session] ([id], [class_id], [facility_id], [start_time], [end_time], [status]) VALUES (19, 4, 1, '2027-01-15 05:00:00.000', '2027-01-15 06:30:00.000', N'SCHEDULED');
INSERT INTO [dbo].[class_session] ([id], [class_id], [facility_id], [start_time], [end_time], [status]) VALUES (20, 4, 1, '2027-01-16 05:00:00.000', '2027-01-16 06:30:00.000', N'SCHEDULED');
INSERT INTO [dbo].[class_session] ([id], [class_id], [facility_id], [start_time], [end_time], [status]) VALUES (21, 4, 1, '2027-01-18 05:00:00.000', '2027-01-18 06:30:00.000', N'SCHEDULED');
INSERT INTO [dbo].[class_session] ([id], [class_id], [facility_id], [start_time], [end_time], [status]) VALUES (22, 4, 1, '2027-01-19 05:00:00.000', '2027-01-19 06:30:00.000', N'SCHEDULED');
INSERT INTO [dbo].[class_session] ([id], [class_id], [facility_id], [start_time], [end_time], [status]) VALUES (23, 4, 1, '2027-01-20 05:00:00.000', '2027-01-20 06:30:00.000', N'SCHEDULED');
INSERT INTO [dbo].[class_session] ([id], [class_id], [facility_id], [start_time], [end_time], [status]) VALUES (24, 4, 1, '2027-01-21 05:00:00.000', '2027-01-21 06:30:00.000', N'SCHEDULED');
INSERT INTO [dbo].[class_session] ([id], [class_id], [facility_id], [start_time], [end_time], [status]) VALUES (25, 4, 1, '2027-01-22 05:00:00.000', '2027-01-22 06:30:00.000', N'SCHEDULED');
INSERT INTO [dbo].[class_session] ([id], [class_id], [facility_id], [start_time], [end_time], [status]) VALUES (26, 4, 1, '2027-01-23 05:00:00.000', '2027-01-23 06:30:00.000', N'SCHEDULED');
INSERT INTO [dbo].[class_session] ([id], [class_id], [facility_id], [start_time], [end_time], [status]) VALUES (1007, 1004, 1, '2026-11-18 01:21:00.000', '2026-11-18 02:21:00.000', N'SCHEDULED');
INSERT INTO [dbo].[class_session] ([id], [class_id], [facility_id], [start_time], [end_time], [status]) VALUES (1008, 1004, 1, '2026-11-20 01:21:00.000', '2026-11-20 02:21:00.000', N'SCHEDULED');
INSERT INTO [dbo].[class_session] ([id], [class_id], [facility_id], [start_time], [end_time], [status]) VALUES (2007, 2004, 1, '2026-11-15 09:00:00.000', '2026-11-15 10:00:00.000', N'COMPLETED');
INSERT INTO [dbo].[class_session] ([id], [class_id], [facility_id], [start_time], [end_time], [status]) VALUES (2008, 2004, 1, '2026-11-18 09:00:00.000', '2026-11-18 10:00:00.000', N'COMPLETED');
SET IDENTITY_INSERT [dbo].[class_session] OFF;
GO

-- Data for table [course_registration] (11 rows)
SET IDENTITY_INSERT [dbo].[course_registration] ON;
INSERT INTO [dbo].[course_registration] ([id], [member_id], [class_id], [status], [registered_at], [cancelled_at], [original_price], [membership_discount], [final_price], [payment_deadline]) VALUES (1, 5, 1, N'EXPIRED', '2026-10-25 20:16:38.486', NULL, 250000.00, 0.00, 250000.00, '2026-10-26 20:16:38.486');
INSERT INTO [dbo].[course_registration] ([id], [member_id], [class_id], [status], [registered_at], [cancelled_at], [original_price], [membership_discount], [final_price], [payment_deadline]) VALUES (2, 5, 2, N'CONFIRMED', '2026-10-26 09:59:21.538', NULL, 275000.00, 13750.00, 261250.00, '2026-10-27 09:59:21.538');
INSERT INTO [dbo].[course_registration] ([id], [member_id], [class_id], [status], [registered_at], [cancelled_at], [original_price], [membership_discount], [final_price], [payment_deadline]) VALUES (1002, 5, 3, N'EXPIRED', '2026-10-28 09:09:48.148', NULL, 300000.00, 60000.00, 240000.00, '2026-10-29 09:09:48.148');
INSERT INTO [dbo].[course_registration] ([id], [member_id], [class_id], [status], [registered_at], [cancelled_at], [original_price], [membership_discount], [final_price], [payment_deadline]) VALUES (2002, 6, 2, N'CONFIRMED', '2026-10-29 21:19:10.909', NULL, 275000.00, 0.00, 275000.00, '2026-10-30 21:19:10.909');
INSERT INTO [dbo].[course_registration] ([id], [member_id], [class_id], [status], [registered_at], [cancelled_at], [original_price], [membership_discount], [final_price], [payment_deadline]) VALUES (3002, 7, 1, N'CONFIRMED', '2026-11-01 15:13:50.637', NULL, 250000.00, 0.00, 250000.00, '2026-11-02 15:13:50.637');
INSERT INTO [dbo].[course_registration] ([id], [member_id], [class_id], [status], [registered_at], [cancelled_at], [original_price], [membership_discount], [final_price], [payment_deadline]) VALUES (3003, 7, 2, N'EXPIRED', '2026-11-01 15:14:50.297', NULL, 275000.00, 0.00, 275000.00, '2026-11-02 15:14:50.297');
INSERT INTO [dbo].[course_registration] ([id], [member_id], [class_id], [status], [registered_at], [cancelled_at], [original_price], [membership_discount], [final_price], [payment_deadline]) VALUES (4002, 5, 1, N'CONFIRMED', '2026-11-02 10:16:30.688', NULL, 250000.00, 50000.00, 200000.00, '2026-11-03 10:16:30.688');
INSERT INTO [dbo].[course_registration] ([id], [member_id], [class_id], [status], [registered_at], [cancelled_at], [original_price], [membership_discount], [final_price], [payment_deadline]) VALUES (5002, 9, 1, N'CONFIRMED', '2026-11-02 13:03:40.281', NULL, 250000.00, 0.00, 250000.00, '2026-11-03 13:03:40.281');
INSERT INTO [dbo].[course_registration] ([id], [member_id], [class_id], [status], [registered_at], [cancelled_at], [original_price], [membership_discount], [final_price], [payment_deadline]) VALUES (6002, 5, 3, N'EXPIRED', '2026-11-05 13:27:38.110', NULL, 300000.00, 60000.00, 240000.00, '2026-11-05 18:00:00.000');
INSERT INTO [dbo].[course_registration] ([id], [member_id], [class_id], [status], [registered_at], [cancelled_at], [original_price], [membership_discount], [final_price], [payment_deadline]) VALUES (6003, 5, 2004, N'CONFIRMED', '2026-11-09 15:49:55.098', NULL, 250000.00, 0.00, 250000.00, '2026-11-12 15:49:55.098');
INSERT INTO [dbo].[course_registration] ([id], [member_id], [class_id], [status], [registered_at], [cancelled_at], [original_price], [membership_discount], [final_price], [payment_deadline]) VALUES (6004, 5, 1004, N'CONFIRMED', '2026-11-09 16:33:04.770', NULL, 250000.00, 0.00, 250000.00, '2026-11-12 16:33:04.770');
SET IDENTITY_INSERT [dbo].[course_registration] OFF;
GO

-- Data for table [payment] (57 rows)
SET IDENTITY_INSERT [dbo].[payment] ON;
INSERT INTO [dbo].[payment] ([id], [member_id], [amount], [method], [purpose], [reference_id], [auto_renew], [status], [transaction_code], [processed_by], [note], [created_at], [paid_at], [refunded_at], [refunded_by]) VALUES (1, 8, 299000.00, N'COUNTER', N'MEMBERSHIP', 1, 0, N'SUCCESS', N'TXN-F820963CB2954A96', 2, N'Front desk payment confirmed', '2026-10-25 20:17:23.585', '2026-10-26 10:33:37.498', NULL, NULL);
INSERT INTO [dbo].[payment] ([id], [member_id], [amount], [method], [purpose], [reference_id], [auto_renew], [status], [transaction_code], [processed_by], [note], [created_at], [paid_at], [refunded_at], [refunded_by]) VALUES (2, 5, 299000.00, N'ONLINE', N'MEMBERSHIP', 1, 0, N'SUCCESS', N'TXN-DEB4E4AAEB594990', NULL, NULL, '2026-10-25 20:26:22.101', '2026-10-25 20:27:12.988', NULL, NULL);
INSERT INTO [dbo].[payment] ([id], [member_id], [amount], [method], [purpose], [reference_id], [auto_renew], [status], [transaction_code], [processed_by], [note], [created_at], [paid_at], [refunded_at], [refunded_by]) VALUES (3, 7, 299000.00, N'ONLINE', N'MEMBERSHIP', 1, 0, N'CANCELLED', N'TXN-F13D302DFEB34B9A', NULL, N'Cancelled by MEMBER', '2026-10-25 20:33:29.771', NULL, NULL, NULL);
INSERT INTO [dbo].[payment] ([id], [member_id], [amount], [method], [purpose], [reference_id], [auto_renew], [status], [transaction_code], [processed_by], [note], [created_at], [paid_at], [refunded_at], [refunded_by]) VALUES (4, 5, 250000.00, N'ONLINE', N'COURSE_REGISTRATION', 1, NULL, N'PENDING', N'TXN-DFC96A3B037B40F5', NULL, NULL, '2026-10-25 20:35:24.669', NULL, NULL, NULL);
INSERT INTO [dbo].[payment] ([id], [member_id], [amount], [method], [purpose], [reference_id], [auto_renew], [status], [transaction_code], [processed_by], [note], [created_at], [paid_at], [refunded_at], [refunded_by]) VALUES (1002, 5, 1499000.00, N'ONLINE', N'MEMBERSHIP', 3, 0, N'CANCELLED', N'TXN-B2776450B7884ABC', NULL, N'VNPay payment failed (response code 24, status 02)', '2026-10-26 09:58:48.800', NULL, NULL, NULL);
INSERT INTO [dbo].[payment] ([id], [member_id], [amount], [method], [purpose], [reference_id], [auto_renew], [status], [transaction_code], [processed_by], [note], [created_at], [paid_at], [refunded_at], [refunded_by]) VALUES (1003, 5, 261250.00, N'ONLINE', N'COURSE_REGISTRATION', 2, NULL, N'SUCCESS', N'TXN-25DD5886B06D4769', NULL, NULL, '2026-10-26 09:59:45.078', '2026-10-26 10:00:35.425', NULL, NULL);
INSERT INTO [dbo].[payment] ([id], [member_id], [amount], [method], [purpose], [reference_id], [auto_renew], [status], [transaction_code], [processed_by], [note], [created_at], [paid_at], [refunded_at], [refunded_by]) VALUES (1004, 5, 1499000.00, N'ONLINE', N'MEMBERSHIP', 3, 0, N'SUCCESS', N'TXN-0629D06921154F05', NULL, NULL, '2026-10-26 10:01:14.958', '2026-10-26 10:01:42.142', NULL, NULL);
INSERT INTO [dbo].[payment] ([id], [member_id], [amount], [method], [purpose], [reference_id], [auto_renew], [status], [transaction_code], [processed_by], [note], [created_at], [paid_at], [refunded_at], [refunded_by]) VALUES (1005, 5, 1499000.00, N'ONLINE', N'MEMBERSHIP', 3, 0, N'SUCCESS', N'TXN-66CF1C942D1B4736', NULL, NULL, '2026-10-26 10:02:05.962', '2026-10-26 10:02:26.422', NULL, NULL);
INSERT INTO [dbo].[payment] ([id], [member_id], [amount], [method], [purpose], [reference_id], [auto_renew], [status], [transaction_code], [processed_by], [note], [created_at], [paid_at], [refunded_at], [refunded_by]) VALUES (2002, 5, 475000.00, N'COUNTER', N'PT_BOOKING', 2, NULL, N'SUCCESS', N'TXN-8A538726D8C74B3C', 2, N'Simulated PT COUNTER E2E settlement in isolated SportCenterPtE2E', '2026-10-26 20:46:32.570', '2026-10-26 20:46:32.728', NULL, NULL);
INSERT INTO [dbo].[payment] ([id], [member_id], [amount], [method], [purpose], [reference_id], [auto_renew], [status], [transaction_code], [processed_by], [note], [created_at], [paid_at], [refunded_at], [refunded_by]) VALUES (2003, 5, 475000.00, N'COUNTER', N'PT_BOOKING', 3, NULL, N'SUCCESS', N'TXN-1F4BF152DE4247D6', 2, N'PT booking counter payment received', '2026-10-26 21:20:55.124', '2026-10-26 21:21:01.460', NULL, NULL);
INSERT INTO [dbo].[payment] ([id], [member_id], [amount], [method], [purpose], [reference_id], [auto_renew], [status], [transaction_code], [processed_by], [note], [created_at], [paid_at], [refunded_at], [refunded_by]) VALUES (2012, 5, 475000.00, N'COUNTER', N'PT_BOOKING', 4, NULL, N'CANCELLED', N'TXN-C49DD61B37DB4E04', NULL, N'Cancelled by MEMBER', '2026-10-26 21:21:19.930', NULL, NULL, NULL);
INSERT INTO [dbo].[payment] ([id], [member_id], [amount], [method], [purpose], [reference_id], [auto_renew], [status], [transaction_code], [processed_by], [note], [created_at], [paid_at], [refunded_at], [refunded_by]) VALUES (2013, 5, 475000.00, N'COUNTER', N'PT_BOOKING', 4, NULL, N'SUCCESS', N'TXN-648F0C9C239E4652', 2, N'PT booking counter payment received', '2026-10-26 21:21:30.509', '2026-10-26 21:21:33.966', NULL, NULL);
INSERT INTO [dbo].[payment] ([id], [member_id], [amount], [method], [purpose], [reference_id], [auto_renew], [status], [transaction_code], [processed_by], [note], [created_at], [paid_at], [refunded_at], [refunded_by]) VALUES (2015, 5, 475000.00, N'COUNTER', N'PT_BOOKING', 5, NULL, N'CANCELLED', N'TXN-A124690031034F87', NULL, N'Cancelled by MEMBER', '2026-10-26 21:33:41.593', NULL, NULL, NULL);
INSERT INTO [dbo].[payment] ([id], [member_id], [amount], [method], [purpose], [reference_id], [auto_renew], [status], [transaction_code], [processed_by], [note], [created_at], [paid_at], [refunded_at], [refunded_by]) VALUES (2016, 5, 475000.00, N'COUNTER', N'PT_BOOKING', 5, NULL, N'CANCELLED', N'TXN-E8621757E5BC453C', NULL, N'Cancelled by MEMBER', '2026-10-26 21:33:49.350', NULL, NULL, NULL);
INSERT INTO [dbo].[payment] ([id], [member_id], [amount], [method], [purpose], [reference_id], [auto_renew], [status], [transaction_code], [processed_by], [note], [created_at], [paid_at], [refunded_at], [refunded_by]) VALUES (2017, 5, 475000.00, N'COUNTER', N'PT_BOOKING', 5, NULL, N'SUCCESS', N'TXN-EBA986ED9BDB4297', 2, N'PT booking counter payment received', '2026-10-26 21:35:32.789', '2026-10-26 21:35:39.524', NULL, NULL);
INSERT INTO [dbo].[payment] ([id], [member_id], [amount], [method], [purpose], [reference_id], [auto_renew], [status], [transaction_code], [processed_by], [note], [created_at], [paid_at], [refunded_at], [refunded_by]) VALUES (2019, 5, 475000.00, N'COUNTER', N'PT_BOOKING', 6, NULL, N'SUCCESS', N'TXN-9694A751D06443E1', 2, N'PT booking counter payment received', '2026-10-26 21:47:44.726', '2026-10-26 21:47:58.835', NULL, NULL);
INSERT INTO [dbo].[payment] ([id], [member_id], [amount], [method], [purpose], [reference_id], [auto_renew], [status], [transaction_code], [processed_by], [note], [created_at], [paid_at], [refunded_at], [refunded_by]) VALUES (2021, 5, 475000.00, N'COUNTER', N'PT_BOOKING', 7, NULL, N'SUCCESS', N'TXN-E7EEC5CD8F8D4B51', 2, N'PT booking counter payment received', '2026-10-26 21:48:06.021', '2026-10-26 21:48:08.913', NULL, NULL);
INSERT INTO [dbo].[payment] ([id], [member_id], [amount], [method], [purpose], [reference_id], [auto_renew], [status], [transaction_code], [processed_by], [note], [created_at], [paid_at], [refunded_at], [refunded_by]) VALUES (2022, 5, 475000.00, N'COUNTER', N'PT_BOOKING', 8, NULL, N'SUCCESS', N'TXN-1EFFA07D57354AA6', 2, N'PT booking counter payment received', '2026-10-26 21:58:56.564', '2026-10-26 21:59:02.341', NULL, NULL);
INSERT INTO [dbo].[payment] ([id], [member_id], [amount], [method], [purpose], [reference_id], [auto_renew], [status], [transaction_code], [processed_by], [note], [created_at], [paid_at], [refunded_at], [refunded_by]) VALUES (3002, 5, 475000.00, N'ONLINE', N'PT_BOOKING', 1002, NULL, N'SUCCESS', N'TXN-10E3E4AD999642D8', NULL, NULL, '2026-10-27 09:50:34.326', '2026-10-27 09:51:05.738', NULL, NULL);
INSERT INTO [dbo].[payment] ([id], [member_id], [amount], [method], [purpose], [reference_id], [auto_renew], [status], [transaction_code], [processed_by], [note], [created_at], [paid_at], [refunded_at], [refunded_by]) VALUES (3003, 5, 475000.00, N'ONLINE', N'PT_BOOKING', 1003, NULL, N'SUCCESS', N'TXN-DEF9350077704966', NULL, NULL, '2026-10-27 10:05:15.481', '2026-10-27 10:10:02.610', NULL, NULL);
INSERT INTO [dbo].[payment] ([id], [member_id], [amount], [method], [purpose], [reference_id], [auto_renew], [status], [transaction_code], [processed_by], [note], [created_at], [paid_at], [refunded_at], [refunded_by]) VALUES (4002, 5, 1499000.00, N'ONLINE', N'MEMBERSHIP', 3, 0, N'CANCELLED', N'TXN-E35EF1D27AC6462A', NULL, N'Cancelled by MEMBER', '2026-10-27 21:51:39.000', NULL, NULL, NULL);
INSERT INTO [dbo].[payment] ([id], [member_id], [amount], [method], [purpose], [reference_id], [auto_renew], [status], [transaction_code], [processed_by], [note], [created_at], [paid_at], [refunded_at], [refunded_by]) VALUES (4003, 5, 1499000.00, N'ONLINE', N'MEMBERSHIP', 3, 0, N'CANCELLED', N'TXN-B48C92BB96D44D9C', NULL, N'Cancelled by MEMBER', '2026-10-27 21:51:57.716', NULL, NULL, NULL);
INSERT INTO [dbo].[payment] ([id], [member_id], [amount], [method], [purpose], [reference_id], [auto_renew], [status], [transaction_code], [processed_by], [note], [created_at], [paid_at], [refunded_at], [refunded_by]) VALUES (4004, 5, 130000.00, N'COUNTER', N'UPGRADE', 2, NULL, N'SUCCESS', N'TXN-7709DB38793C45D3', 1, N'Front desk payment confirmed', '2026-10-27 22:04:48.144', '2026-10-27 22:05:22.056', NULL, NULL);
INSERT INTO [dbo].[payment] ([id], [member_id], [amount], [method], [purpose], [reference_id], [auto_renew], [status], [transaction_code], [processed_by], [note], [created_at], [paid_at], [refunded_at], [refunded_by]) VALUES (4005, 5, 1000.00, N'COUNTER', N'UPGRADE', 3, NULL, N'SUCCESS', N'TXN-755FFFF160384F4B', 1, N'Front desk payment confirmed', '2026-10-27 23:14:27.711', '2026-10-27 23:14:43.564', NULL, NULL);
INSERT INTO [dbo].[payment] ([id], [member_id], [amount], [method], [purpose], [reference_id], [auto_renew], [status], [transaction_code], [processed_by], [note], [created_at], [paid_at], [refunded_at], [refunded_by]) VALUES (4006, 5, 450000.00, N'ONLINE', N'PT_BOOKING', 2002, NULL, N'CANCELLED', N'TXN-0449B14F9EE242AE', NULL, N'Cancelled by MEMBER', '2026-10-27 23:26:31.962', NULL, NULL, NULL);
INSERT INTO [dbo].[payment] ([id], [member_id], [amount], [method], [purpose], [reference_id], [auto_renew], [status], [transaction_code], [processed_by], [note], [created_at], [paid_at], [refunded_at], [refunded_by]) VALUES (4007, 5, 450000.00, N'COUNTER', N'PT_BOOKING', 2002, NULL, N'SUCCESS', N'TXN-94DA9A6D9B0E41E3', 1, N'PT booking counter payment received', '2026-10-27 23:26:40.870', '2026-10-27 23:26:55.004', NULL, NULL);
INSERT INTO [dbo].[payment] ([id], [member_id], [amount], [method], [purpose], [reference_id], [auto_renew], [status], [transaction_code], [processed_by], [note], [created_at], [paid_at], [refunded_at], [refunded_by]) VALUES (4008, 5, 450000.00, N'COUNTER', N'PT_BOOKING', 2003, NULL, N'SUCCESS', N'TXN-A7B2A6669E7147F7', 1, N'PT booking counter payment received', '2026-10-27 23:27:56.706', '2026-10-27 23:28:00.064', NULL, NULL);
INSERT INTO [dbo].[payment] ([id], [member_id], [amount], [method], [purpose], [reference_id], [auto_renew], [status], [transaction_code], [processed_by], [note], [created_at], [paid_at], [refunded_at], [refunded_by]) VALUES (5002, 5, 299000.00, N'COUNTER', N'MEMBERSHIP', 1, 0, N'CANCELLED', N'TXN-43D61200FB0B40FB', NULL, N'Cancelled by MEMBER', '2026-10-28 09:10:57.221', NULL, NULL, NULL);
INSERT INTO [dbo].[payment] ([id], [member_id], [amount], [method], [purpose], [reference_id], [auto_renew], [status], [transaction_code], [processed_by], [note], [created_at], [paid_at], [refunded_at], [refunded_by]) VALUES (5003, 5, 450000.00, N'COUNTER', N'PT_BOOKING', 3002, NULL, N'CANCELLED', N'TXN-29C0878B2FCF4A8A', NULL, N'Cancelled by MEMBER', '2026-10-28 09:11:40.784', NULL, NULL, NULL);
INSERT INTO [dbo].[payment] ([id], [member_id], [amount], [method], [purpose], [reference_id], [auto_renew], [status], [transaction_code], [processed_by], [note], [created_at], [paid_at], [refunded_at], [refunded_by]) VALUES (5004, 5, 299000.00, N'COUNTER', N'MEMBERSHIP', 1, 0, N'CANCELLED', N'TXN-8BDD97170C984500', NULL, N'Cancelled by MEMBER', '2026-10-28 09:11:56.357', NULL, NULL, NULL);
INSERT INTO [dbo].[payment] ([id], [member_id], [amount], [method], [purpose], [reference_id], [auto_renew], [status], [transaction_code], [processed_by], [note], [created_at], [paid_at], [refunded_at], [refunded_by]) VALUES (5005, 5, 240000.00, N'COUNTER', N'COURSE_REGISTRATION', 1002, NULL, N'CANCELLED', N'TXN-CFE6C696687F49DB', NULL, N'Cancelled by MEMBER', '2026-10-28 09:12:03.589', NULL, NULL, NULL);
INSERT INTO [dbo].[payment] ([id], [member_id], [amount], [method], [purpose], [reference_id], [auto_renew], [status], [transaction_code], [processed_by], [note], [created_at], [paid_at], [refunded_at], [refunded_by]) VALUES (5006, 5, 450000.00, N'ONLINE', N'PT_BOOKING', 3002, NULL, N'CANCELLED', N'TXN-36791E3B70F949A8', NULL, N'Cancelled by MEMBER', '2026-10-28 09:16:29.086', NULL, NULL, NULL);
INSERT INTO [dbo].[payment] ([id], [member_id], [amount], [method], [purpose], [reference_id], [auto_renew], [status], [transaction_code], [processed_by], [note], [created_at], [paid_at], [refunded_at], [refunded_by]) VALUES (5007, 5, 450000.00, N'ONLINE', N'PT_BOOKING', 3002, NULL, N'PENDING', N'TXN-ECCA96AC7DA54AF0', NULL, NULL, '2026-10-28 09:17:25.308', NULL, NULL, NULL);
INSERT INTO [dbo].[payment] ([id], [member_id], [amount], [method], [purpose], [reference_id], [auto_renew], [status], [transaction_code], [processed_by], [note], [created_at], [paid_at], [refunded_at], [refunded_by]) VALUES (5008, 5, 299000.00, N'ONLINE', N'MEMBERSHIP', 1, 0, N'CANCELLED', N'TXN-60BCA1CB3FAF4325', NULL, N'Cancelled by MEMBER', '2026-10-28 09:18:20.656', NULL, NULL, NULL);
INSERT INTO [dbo].[payment] ([id], [member_id], [amount], [method], [purpose], [reference_id], [auto_renew], [status], [transaction_code], [processed_by], [note], [created_at], [paid_at], [refunded_at], [refunded_by]) VALUES (5009, 5, 1299000.00, N'ONLINE', N'MEMBERSHIP', 2, 0, N'CANCELLED', N'TXN-91D16C2D55B74122', NULL, N'VNPay payment failed (response code 24, status 02)', '2026-10-28 10:03:23.834', NULL, NULL, NULL);
INSERT INTO [dbo].[payment] ([id], [member_id], [amount], [method], [purpose], [reference_id], [auto_renew], [status], [transaction_code], [processed_by], [note], [created_at], [paid_at], [refunded_at], [refunded_by]) VALUES (6002, 6, 275000.00, N'ONLINE', N'COURSE_REGISTRATION', 2002, NULL, N'PENDING', N'TXN-048CABB629424AAC', NULL, NULL, '2026-10-29 21:19:28.834', NULL, NULL, NULL);
INSERT INTO [dbo].[payment] ([id], [member_id], [amount], [method], [purpose], [reference_id], [auto_renew], [status], [transaction_code], [processed_by], [note], [created_at], [paid_at], [refunded_at], [refunded_by]) VALUES (6003, 6, 275000.00, N'COUNTER', N'COURSE_REGISTRATION', 2002, NULL, N'SUCCESS', N'TXN-9541C0C2FC3B4983', 1, N'Course payment received at reception', '2026-10-29 21:20:40.872', '2026-10-29 21:20:49.478', NULL, NULL);
INSERT INTO [dbo].[payment] ([id], [member_id], [amount], [method], [purpose], [reference_id], [auto_renew], [status], [transaction_code], [processed_by], [note], [created_at], [paid_at], [refunded_at], [refunded_by]) VALUES (6004, 6, 1299000.00, N'COUNTER', N'MEMBERSHIP', 2, 0, N'SUCCESS', N'TXN-E6F46F5C09D345E8', 1, N'Front desk payment confirmed', '2026-10-29 21:21:51.831', '2026-10-29 21:22:07.790', NULL, NULL);
INSERT INTO [dbo].[payment] ([id], [member_id], [amount], [method], [purpose], [reference_id], [auto_renew], [status], [transaction_code], [processed_by], [note], [created_at], [paid_at], [refunded_at], [refunded_by]) VALUES (7014, 7, 250000.00, N'COUNTER', N'COURSE_REGISTRATION', 3002, NULL, N'SUCCESS', N'TXN-7FD1909CEAFA4668', 1, N'Course payment received at reception', '2026-11-01 15:14:20.124', '2026-11-01 15:14:30.218', NULL, NULL);
INSERT INTO [dbo].[payment] ([id], [member_id], [amount], [method], [purpose], [reference_id], [auto_renew], [status], [transaction_code], [processed_by], [note], [created_at], [paid_at], [refunded_at], [refunded_by]) VALUES (7022, 7, 2599000.00, N'ONLINE', N'MEMBERSHIP', 3, 0, N'SUCCESS', N'TXN-2D43C33F6DC84551', NULL, NULL, '2026-11-01 15:34:48.508', '2026-11-01 15:36:03.202', NULL, NULL);
INSERT INTO [dbo].[payment] ([id], [member_id], [amount], [method], [purpose], [reference_id], [auto_renew], [status], [transaction_code], [processed_by], [note], [created_at], [paid_at], [refunded_at], [refunded_by]) VALUES (7023, 7, 450000.00, N'ONLINE', N'PT_BOOKING', 4002, NULL, N'SUCCESS', N'TXN-704447AED3B3497A', NULL, NULL, '2026-11-01 22:09:27.871', '2026-11-01 22:09:59.848', NULL, NULL);
INSERT INTO [dbo].[payment] ([id], [member_id], [amount], [method], [purpose], [reference_id], [auto_renew], [status], [transaction_code], [processed_by], [note], [created_at], [paid_at], [refunded_at], [refunded_by]) VALUES (8002, 5, 200000.00, N'ONLINE', N'COURSE_REGISTRATION', 4002, NULL, N'SUCCESS', N'TXN-80D54F189AF54A2B', NULL, NULL, '2026-11-02 10:16:55.709', '2026-11-02 10:17:30.353', NULL, NULL);
INSERT INTO [dbo].[payment] ([id], [member_id], [amount], [method], [purpose], [reference_id], [auto_renew], [status], [transaction_code], [processed_by], [note], [created_at], [paid_at], [refunded_at], [refunded_by]) VALUES (9002, 8, 240000.00, N'ONLINE', N'UPGRADE', 2, NULL, N'SUCCESS', N'TXN-3634D667A3F44D6E', NULL, NULL, '2026-11-02 12:45:27.068', '2026-11-02 12:45:57.800', NULL, NULL);
INSERT INTO [dbo].[payment] ([id], [member_id], [amount], [method], [purpose], [reference_id], [auto_renew], [status], [transaction_code], [processed_by], [note], [created_at], [paid_at], [refunded_at], [refunded_by]) VALUES (9003, 8, 299000.00, N'ONLINE', N'MEMBERSHIP', 1, 0, N'CANCELLED', N'TXN-F89D2BB148384601', NULL, N'VNPay payment failed (response code 24, status 02)', '2026-11-02 12:46:20.301', NULL, NULL, NULL);
INSERT INTO [dbo].[payment] ([id], [member_id], [amount], [method], [purpose], [reference_id], [auto_renew], [status], [transaction_code], [processed_by], [note], [created_at], [paid_at], [refunded_at], [refunded_by]) VALUES (9004, 7, 599000.00, N'ONLINE', N'MEMBERSHIP', 2, 0, N'SUCCESS', N'TXN-4AEA6CBADA544879', NULL, NULL, '2026-11-02 12:46:44.746', '2026-11-02 12:47:13.736', NULL, NULL);
INSERT INTO [dbo].[payment] ([id], [member_id], [amount], [method], [purpose], [reference_id], [auto_renew], [status], [transaction_code], [processed_by], [note], [created_at], [paid_at], [refunded_at], [refunded_by]) VALUES (9005, 9, 250000.00, N'ONLINE', N'COURSE_REGISTRATION', 5002, NULL, N'SUCCESS', N'TXN-01FFD094C8324C39', NULL, NULL, '2026-11-02 13:03:43.697', '2026-11-02 13:04:06.439', NULL, NULL);
INSERT INTO [dbo].[payment] ([id], [member_id], [amount], [method], [purpose], [reference_id], [auto_renew], [status], [transaction_code], [processed_by], [note], [created_at], [paid_at], [refunded_at], [refunded_by]) VALUES (9006, 8, 560000.00, N'ONLINE', N'UPGRADE', 3, NULL, N'CANCELLED', N'TXN-E6E9F7CCA6304AA2', NULL, N'VNPay payment failed (response code 24, status 02)', '2026-11-02 13:04:49.240', NULL, NULL, NULL);
INSERT INTO [dbo].[payment] ([id], [member_id], [amount], [method], [purpose], [reference_id], [auto_renew], [status], [transaction_code], [processed_by], [note], [created_at], [paid_at], [refunded_at], [refunded_by]) VALUES (9007, 8, 560000.00, N'ONLINE', N'UPGRADE', 3, NULL, N'SUCCESS', N'TXN-2875ACD4129A442E', NULL, NULL, '2026-11-02 13:05:17.320', '2026-11-02 13:05:39.094', NULL, NULL);
INSERT INTO [dbo].[payment] ([id], [member_id], [amount], [method], [purpose], [reference_id], [auto_renew], [status], [transaction_code], [processed_by], [note], [created_at], [paid_at], [refunded_at], [refunded_by]) VALUES (9008, 8, 450000.00, N'ONLINE', N'PT_BOOKING', 5002, NULL, N'SUCCESS', N'TXN-A6B5E49214B94350', NULL, NULL, '2026-11-02 13:05:56.977', '2026-11-02 13:06:20.053', NULL, NULL);
INSERT INTO [dbo].[payment] ([id], [member_id], [amount], [method], [purpose], [reference_id], [auto_renew], [status], [transaction_code], [processed_by], [note], [created_at], [paid_at], [refunded_at], [refunded_by]) VALUES (9009, 9, 299000.00, N'COUNTER', N'MEMBERSHIP', 1, 0, N'SUCCESS', N'TXN-7AF7E9ED40C94431', 1, N'Front desk payment confirmed', '2026-11-02 13:13:09.943', '2026-11-02 13:13:23.541', NULL, NULL);
INSERT INTO [dbo].[payment] ([id], [member_id], [amount], [method], [purpose], [reference_id], [auto_renew], [status], [transaction_code], [processed_by], [note], [created_at], [paid_at], [refunded_at], [refunded_by]) VALUES (9010, 9, 300000.00, N'COUNTER', N'UPGRADE', 2, NULL, N'SUCCESS', N'TXN-25B9D27555204E78', 1, N'Front desk payment confirmed', '2026-11-02 13:14:26.443', '2026-11-02 13:14:41.688', NULL, NULL);
INSERT INTO [dbo].[payment] ([id], [member_id], [amount], [method], [purpose], [reference_id], [auto_renew], [status], [transaction_code], [processed_by], [note], [created_at], [paid_at], [refunded_at], [refunded_by]) VALUES (9011, 9, 299000.00, N'COUNTER', N'MEMBERSHIP', 1, 0, N'REFUND_REQUIRED', N'TXN-FB14046015F84216', 1, N'Refund 100%: membership #4007 was cancelled before it started', '2026-11-02 13:15:04.855', '2026-11-02 13:15:16.006', NULL, NULL);
INSERT INTO [dbo].[payment] ([id], [member_id], [amount], [method], [purpose], [reference_id], [auto_renew], [status], [transaction_code], [processed_by], [note], [created_at], [paid_at], [refunded_at], [refunded_by]) VALUES (10002, 5, 240000.00, N'COUNTER', N'COURSE_REGISTRATION', 6002, NULL, N'PENDING', N'TXN-1AF3B3C22893412B', NULL, NULL, '2026-11-05 13:27:50.656', NULL, NULL, NULL);
INSERT INTO [dbo].[payment] ([id], [member_id], [amount], [method], [purpose], [reference_id], [auto_renew], [status], [transaction_code], [processed_by], [note], [created_at], [paid_at], [refunded_at], [refunded_by]) VALUES (10003, 5, 450000.00, N'COUNTER', N'PT_BOOKING', 6002, NULL, N'PENDING', N'TXN-A1EF32AD2CE34F57', NULL, NULL, '2026-11-05 13:28:22.139', NULL, NULL, NULL);
INSERT INTO [dbo].[payment] ([id], [member_id], [amount], [method], [purpose], [reference_id], [auto_renew], [status], [transaction_code], [processed_by], [note], [created_at], [paid_at], [refunded_at], [refunded_by]) VALUES (10004, 5, 450000.00, N'COUNTER', N'PT_BOOKING', 6003, NULL, N'PENDING', N'TXN-EB98B7A189A04A5C', NULL, NULL, '2026-11-05 13:56:34.222', NULL, NULL, NULL);
INSERT INTO [dbo].[payment] ([id], [member_id], [amount], [method], [purpose], [reference_id], [auto_renew], [status], [transaction_code], [processed_by], [note], [created_at], [paid_at], [refunded_at], [refunded_by]) VALUES (10005, 5, 250000.00, N'ONLINE', N'COURSE_REGISTRATION', 6003, 0, N'SUCCESS', N'TXN-20261109154955-9690', NULL, N'Thanh toán test tự động', '2026-11-09 15:49:55.163', '2026-11-09 15:49:55.163', NULL, NULL);
INSERT INTO [dbo].[payment] ([id], [member_id], [amount], [method], [purpose], [reference_id], [auto_renew], [status], [transaction_code], [processed_by], [note], [created_at], [paid_at], [refunded_at], [refunded_by]) VALUES (10006, 5, 250000.00, N'ONLINE', N'COURSE_REGISTRATION', 6004, 0, N'SUCCESS', N'TXN-20261109163304-9088', NULL, N'', '2026-11-09 16:33:04.998', '2026-11-09 16:33:04.998', NULL, NULL);
SET IDENTITY_INSERT [dbo].[payment] OFF;
GO

-- Data for table [attendance] (2 rows)
SET IDENTITY_INSERT [dbo].[attendance] ON;
INSERT INTO [dbo].[attendance] ([id], [class_session_id], [member_id], [status], [marked_by], [marked_at], [note]) VALUES (1, 2008, 5, N'PRESENT', 3, '2026-11-09 15:49:55.311', N'Đến lớp đúng giờ, thể lực rất tốt');
INSERT INTO [dbo].[attendance] ([id], [class_session_id], [member_id], [status], [marked_by], [marked_at], [note]) VALUES (2, 2007, 5, N'PRESENT', 3, '2026-11-09 16:34:38.064', NULL);
SET IDENTITY_INSERT [dbo].[attendance] OFF;
GO

-- Data for table [feedback] (1 rows)
SET IDENTITY_INSERT [dbo].[feedback] ON;
INSERT INTO [dbo].[feedback] ([id], [class_id], [member_id], [rating], [comment], [created_at]) VALUES (1, 2004, 5, 5, N'Khóa học tuyệt vời, HLV hướng dẫn rất nhiệt tình và chuyên nghiệp!', '2026-11-09 15:49:55.369');
SET IDENTITY_INSERT [dbo].[feedback] OFF;
GO


