use ExaminationSystem;
--1 to create a login for a new student when they are inserted into the Student table
CREATE TRIGGER AddStudentLogin
ON [Members].[Student]
AFTER INSERT
AS
BEGIN
    -- Declare variables
    DECLARE @UserName NVARCHAR(50) 
    DECLARE @Password NVARCHAR(50)

    -- Retrieve the inserted student details
    SELECT @UserName = User_Name, @Password = Password
    FROM inserted

    -- Generate the SQL to create the login
    DECLARE @SQLL NVARCHAR(MAX)
    SET @SQLL = 'CREATE LOGIN ' + QUOTENAME(@UserName) +
               ' WITH PASSWORD = ' + QUOTENAME(@Password, '''');

    -- Execute the SQL to create the login
    EXEC sp_executesql @SQLL;

    -- Generate the SQL to create the user
    DECLARE @SQLU NVARCHAR(MAX)
    SET @SQLU = 'CREATE USER ' + QUOTENAME(@UserName) +
               ' FOR LOGIN ' + QUOTENAME(@UserName);

    -- Execute the SQL to create the user
    EXEC sp_executesql @SQLU;

	DECLARE @SQLG NVARCHAR(MAX)
    SET @SQLG = 'GRANT INSERT, UPDATE ON [Members].[Student_Answer] TO ' + QUOTENAME(@UserName);

    -- Execute the SQL to grant permissions to the user
    EXEC sp_executesql @SQLG;
    
    -- Adjust the permission grant to the user executing the trigger
    DECLARE @GrantPermission NVARCHAR(MAX)
    SET @GrantPermission = 'GRANT INSERT, UPDATE ON [Members].[Student_Answer] TO ' + QUOTENAME(SUSER_SNAME());

    -- Execute the permission grant statement
    EXEC sp_executesql @GrantPermission;
END


--**************************************************************************************--
--drop login if the student deleted from the table of the student 
drop trigger DropStudentLogin
CREATE TRIGGER DropStudentLogin
ON [Members].[Student]
AFTER DELETE
AS
BEGIN
    -- Declare variables
    DECLARE @UserName NVARCHAR(50)

    -- Retrieve the deleted student's username
    SELECT @UserName = d.User_Name
    FROM deleted d

    -- Generate the SQL to drop the login
    DECLARE @SQLL NVARCHAR(MAX)
    SET @SQLL = 'IF EXISTS (SELECT * FROM sys.syslogins WHERE name = ' + QUOTENAME(@UserName, '''') + ')
                DROP LOGIN ' + QUOTENAME(@UserName)

    -- Execute the SQL to drop the login
    EXEC sp_executesql @SQLL

    -- Generate the SQL to drop the user
    DECLARE @SQLU NVARCHAR(MAX)
    SET @SQLU = 'IF EXISTS (SELECT * FROM sys.sysusers WHERE name = ' + QUOTENAME(@UserName, '''') + ')
                DROP USER ' + QUOTENAME(@UserName)

    -- Execute the SQL to drop the user
    EXEC sp_executesql @SQLU
END
---*****************************************************************************************--
--update the login on updating the student 
CREATE TRIGGER UpdateStudentLogin
ON [Members].[Student]
AFTER UPDATE
AS
BEGIN
    -- Declare variables
    DECLARE @OldUserName NVARCHAR(50)
    DECLARE @NewUserName NVARCHAR(50)
    DECLARE @Password NVARCHAR(50)

    -- Retrieve the old and new student details
    SELECT @OldUserName = d.User_Name, @NewUserName = i.User_Name, @Password = i.Password
    FROM deleted d
    JOIN inserted i ON d.ID= i.ID

    -- Generate the SQL to update the login
    DECLARE @SQLL NVARCHAR(MAX)
    SET @SQLL = 'IF EXISTS (SELECT * FROM sys.syslogins WHERE name = ' + QUOTENAME(@OldUserName, '''') + ')
                BEGIN
                    ALTER LOGIN ' + QUOTENAME(@OldUserName) + '
                    WITH NAME = ' + QUOTENAME(@NewUserName) + ',
                    PASSWORD = ' + QUOTENAME(@Password, '''') + '
                END'

    -- Execute the SQL to update the login
    EXEC sp_executesql @SQLL

    -- Generate the SQL to update the user
    DECLARE @SQLU NVARCHAR(MAX)
    SET @SQLU = 'IF EXISTS (SELECT * FROM sys.sysusers WHERE name = ' + QUOTENAME(@OldUserName, '''') + ')
                BEGIN
                    ALTER USER ' + QUOTENAME(@OldUserName) + '
                    WITH NAME = ' + QUOTENAME(@NewUserName) + '
                END'

    -- Execute the SQL to update the user
    EXEC sp_executesql @SQLU
END
--****************************************************************************************---

--2 trigger to create a login for a new student when they are inserted into the instructor table
CREATE TRIGGER AddInstructorLogin
ON [Members].[Instructor]
AFTER INSERT
AS
BEGIN
    -- Declare variables
    DECLARE @UserName NVARCHAR(50) 
    DECLARE @Password NVARCHAR(50)

    -- Retrieve the inserted Instructor details
    SELECT @UserName = User_Name, @Password = Password
    FROM inserted

    -- Generate the SQL to create the login
    DECLARE @SQLL NVARCHAR(MAX)
    SET @SQLL = 'CREATE LOGIN ' + QUOTENAME(@UserName) +
               ' WITH PASSWORD = ' + QUOTENAME(@Password, '''');

    -- Execute the SQL to create the login
    EXEC sp_executesql @SQLL;

    -- Generate the SQL to create the user
    DECLARE @SQLU NVARCHAR(MAX)
    SET @SQLU = 'CREATE USER ' + QUOTENAME(@UserName) +
               ' FOR LOGIN ' + QUOTENAME(@UserName);

    -- Execute the SQL to create the user
    EXEC sp_executesql @SQLU;

	DECLARE @SQLG NVARCHAR(MAX)
    SET @SQLG = 'GRANT Select,INSERT, UPDATE, DELETE ON  [Courses].[Question_Pool]TO ' + QUOTENAME(@UserName);

    -- Execute the SQL to grant permissions to the user
    EXEC sp_executesql @SQLG;
    
    -- Adjust the permission grant to the user executing the trigger
    DECLARE @GrantPermission NVARCHAR(MAX)
    SET @GrantPermission = 'GRANT Select,INSERT, UPDATE, DELETE ON [Courses].[Question_Pool] TO ' + QUOTENAME(SUSER_SNAME());

    -- Execute the permission grant statement
    EXEC sp_executesql @GrantPermission;
END
--*************************************************************************************--
--drop login if the student deleted from the table of the student 

CREATE TRIGGER DropInstructorLogin
ON [Members].[Instructor]
AFTER DELETE
AS
BEGIN
    -- Declare variables
    DECLARE @UserName NVARCHAR(50)

    -- Retrieve the deleted student's username
    SELECT @UserName = d.User_Name
    FROM deleted d

    -- Generate the SQL to drop the login
    DECLARE @SQLL NVARCHAR(MAX)
    SET @SQLL = 'IF EXISTS (SELECT * FROM sys.syslogins WHERE name = ' + QUOTENAME(@UserName, '''') + ')
                DROP LOGIN ' + QUOTENAME(@UserName)

    -- Execute the SQL to drop the login
    EXEC sp_executesql @SQLL

    -- Generate the SQL to drop the user
    DECLARE @SQLU NVARCHAR(MAX)
    SET @SQLU = 'IF EXISTS (SELECT * FROM sys.sysusers WHERE name = ' + QUOTENAME(@UserName, '''') + ')
                DROP USER ' + QUOTENAME(@UserName)

    -- Execute the SQL to drop the user
    EXEC sp_executesql @SQLU
END
--*****************************************************************************************--
--update the login on updating the instructor 
CREATE TRIGGER UpdateInstructorLogin
ON [Members].[Instructor]
AFTER UPDATE
AS
BEGIN
    -- Declare variables
    DECLARE @OldUserName NVARCHAR(50)
    DECLARE @NewUserName NVARCHAR(50)
    DECLARE @Password NVARCHAR(50)

    -- Retrieve the old and new student details
    SELECT @OldUserName = d.User_Name, @NewUserName = i.User_Name, @Password = i.Password
    FROM deleted d
    JOIN inserted i ON d.ID= i.ID

    -- Generate the SQL to update the login
    DECLARE @SQLL NVARCHAR(MAX)
    SET @SQLL = 'IF EXISTS (SELECT * FROM sys.syslogins WHERE name = ' + QUOTENAME(@OldUserName, '''') + ')
                BEGIN
                    ALTER LOGIN ' + QUOTENAME(@OldUserName) + '
                    WITH NAME = ' + QUOTENAME(@NewUserName) + ',
                    PASSWORD = ' + QUOTENAME(@Password, '''') + '
                END'

    -- Execute the SQL to update the login
    EXEC sp_executesql @SQLL

    -- Generate the SQL to update the user
    DECLARE @SQLU NVARCHAR(MAX)
    SET @SQLU = 'IF EXISTS (SELECT * FROM sys.sysusers WHERE name = ' + QUOTENAME(@OldUserName, '''') + ')
                BEGIN
                    ALTER USER ' + QUOTENAME(@OldUserName) + '
                    WITH NAME = ' + QUOTENAME(@NewUserName) + '
                END'

    -- Execute the SQL to update the user
    EXEC sp_executesql @SQLU
END