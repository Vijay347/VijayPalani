USE [master]
GO
/****** Object:  Database [TaskManager]    Script Date: 9/28/2018 9:44:33 PM ******/
CREATE DATABASE [TaskManager]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'TaskManager', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.SQLEXPRESS\MSSQL\DATA\TaskManager.mdf' , SIZE = 3136KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'TaskManager_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.SQLEXPRESS\MSSQL\DATA\TaskManager_log.ldf' , SIZE = 832KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [TaskManager] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [TaskManager].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [TaskManager] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [TaskManager] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [TaskManager] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [TaskManager] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [TaskManager] SET ARITHABORT OFF 
GO
ALTER DATABASE [TaskManager] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [TaskManager] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [TaskManager] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [TaskManager] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [TaskManager] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [TaskManager] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [TaskManager] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [TaskManager] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [TaskManager] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [TaskManager] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [TaskManager] SET  ENABLE_BROKER 
GO
ALTER DATABASE [TaskManager] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [TaskManager] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [TaskManager] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [TaskManager] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [TaskManager] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [TaskManager] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [TaskManager] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [TaskManager] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [TaskManager] SET  MULTI_USER 
GO
ALTER DATABASE [TaskManager] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [TaskManager] SET DB_CHAINING OFF 
GO
ALTER DATABASE [TaskManager] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [TaskManager] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
USE [TaskManager]
GO
/****** Object:  StoredProcedure [dbo].[GET_PARENT_TASK]    Script Date: 9/28/2018 9:44:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GET_PARENT_TASK]

AS

BEGIN

	SELECT * FROM Parent_Task;

END
GO
/****** Object:  StoredProcedure [dbo].[GET_PROJECT_DETAILS]    Script Date: 9/28/2018 9:44:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GET_PROJECT_DETAILS]

AS

BEGIN

	SELECT Project_ID,Project,CONVERT(date, Start_Date) AS Start_Date ,CONVERT(date, End_Date) AS End_Date,Priority FROM Project;

END
GO
/****** Object:  StoredProcedure [dbo].[GET_TASK_DETAILS]    Script Date: 9/28/2018 9:44:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GET_TASK_DETAILS]

AS

BEGIN

	SELECT Task_ID,Parent_ID,Task,CONVERT(date, Start_Date) AS Start_Date ,CONVERT(date, End_Date) AS End_Date,Priority,Project_ID,Status FROM Task;

END
GO
/****** Object:  StoredProcedure [dbo].[GET_USER_DETAILS]    Script Date: 9/28/2018 9:44:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GET_USER_DETAILS]

AS

BEGIN

	SELECT User_ID,First_Name,Last_Name,Employee_ID,Project_ID,Task_ID FROM Users;

END
GO
/****** Object:  StoredProcedure [dbo].[INSERT_PROJECT_DETAILS]    Script Date: 9/28/2018 9:44:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[INSERT_PROJECT_DETAILS]
(

@Project_ID INT,
@Project VARCHAR(500),
@Start_Date DATETIME,
@End_Date DATETIME,
@Priority INT
)

AS

BEGIN

	IF(@Project_ID=0)
		BEGIN

			INSERT INTO Project(Project_ID,Project,Start_Date,End_Date,Priority)VALUES ((select COUNT(*)+1 from Project),@Project,@Start_Date,@End_Date,@Priority);
			
		END

	ELSE 
		BEGIN
			
		  UPDATE Project SET Project=@Project,Start_Date=@Start_Date,End_Date=@End_Date,Priority=@Priority
		  WHERE Project_ID = @Project_ID;

		END
END
GO
/****** Object:  StoredProcedure [dbo].[INSERT_TASK_DETAILS]    Script Date: 9/28/2018 9:44:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[INSERT_TASK_DETAILS]
(

@Task_ID INT,
@Parent_ID INT,
@Task VARCHAR(500),
@Start_Date DATETIME,
@End_Date DATETIME,
@Priority INT,
@Project_ID INT
)

AS

BEGIN

	IF(@Task_ID=0)
		BEGIN

			INSERT INTO Task(Task_ID,Parent_ID,Task,Start_Date,End_Date,Priority,Project_ID,Status)VALUES ((select COUNT(*)+1 from Task),@Parent_ID,@Task,@Start_Date,@End_Date,@Priority,@Project_ID,1);
			
		END

	ELSE 
		BEGIN
			
		  UPDATE Task SET Parent_ID=@Parent_ID,Task=@Task,Start_Date=@Start_Date,End_Date=@End_Date,Priority=@Priority,Project_ID=@Project_ID
		  WHERE Task_ID = @Task_ID;


		END
END
GO
/****** Object:  StoredProcedure [dbo].[INSERT_USER_DETAILS]    Script Date: 9/28/2018 9:44:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[INSERT_USER_DETAILS]
(

@User_ID INT,
@First_Name VARCHAR(100),
@Last_Name VARCHAR(100),
@Employee_ID INT,
@Project_ID INT,
@Task_ID INT,
@Action Varchar(50)
)

AS

BEGIN

IF(@Action='delete')
	BEGIN

		Delete from Users where User_ID = @User_ID;

	END

ELSE

	BEGIN
		IF(@User_ID=0)
		BEGIN

			INSERT INTO Users(User_ID,First_Name,Last_Name,Employee_ID,Project_ID,Task_ID)VALUES ((select COUNT(*)+1 from Users),@First_Name,@Last_Name,@Employee_ID,@Project_ID,@Task_ID);
			
		END

	ELSE 
		BEGIN
			
		  UPDATE Users SET First_Name=@First_Name,Last_Name=@Last_Name,Employee_ID=@Employee_ID,Project_ID=@Project_ID,Task_ID=@Task_ID
		  WHERE User_ID = @User_ID;

		END
	END
END
GO
/****** Object:  StoredProcedure [dbo].[UPDATE_END_TASK]    Script Date: 9/28/2018 9:44:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UPDATE_END_TASK]
(
@Task_ID INT,
@End_Date DATETIME
)

AS

BEGIN

	UPDATE Task SET End_Date=@End_Date,Status=0 WHERE Task_ID = @Task_ID;

END
GO
/****** Object:  Table [dbo].[Parent_Task]    Script Date: 9/28/2018 9:44:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Parent_Task](
	[Parent_ID] [int] NULL,
	[Parent_Task] [varchar](500) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Project]    Script Date: 9/28/2018 9:44:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Project](
	[Project_ID] [int] NULL,
	[Project] [varchar](500) NULL,
	[Start_Date] [date] NULL,
	[End_Date] [date] NULL,
	[Priority] [int] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Task]    Script Date: 9/28/2018 9:44:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Task](
	[Task_ID] [int] NULL,
	[Parent_ID] [int] NULL,
	[Task] [varchar](500) NULL,
	[Start_Date] [date] NULL,
	[End_Date] [date] NULL,
	[Priority] [int] NULL,
	[Project_ID] [int] NULL,
	[Status] [int] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Users]    Script Date: 9/28/2018 9:44:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Users](
	[User_ID] [int] NULL,
	[First_Name] [varchar](100) NULL,
	[Last_Name] [varchar](100) NULL,
	[Employee_ID] [int] NULL,
	[Project_ID] [int] NULL,
	[Task_ID] [int] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
USE [master]
GO
ALTER DATABASE [TaskManager] SET  READ_WRITE 
GO
