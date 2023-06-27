INSERT INTO Department (DepartmentCode, Department) VALUES ('IT', 'IT Support')
INSERT INTO Department (DepartmentCode, Department) VALUES ('SALES', 'Sales')
INSERT INTO Department (DepartmentCode, Department) VALUES ('HR', 'Human Resources')
INSERT INTO Department (DepartmentCode, Department) VALUES ('MARKT', 'Marketing')
INSERT INTO Department (DepartmentCode, Department) VALUES ('LEGAL', 'Legal')
INSERT INTO Department (DepartmentCode, Department) VALUES ('MAINT', 'Maintenance')
GO
INSERT INTO UserProfile (FirstName, LastName,  EmailAddress, PhoneNumber, ActiveInd, DepartmentKey, UserName, Password) VALUES
	('Joshua', 'Serwatien', 'josh@email.com','0584005114',1,1, 'joshs', 'joshs'),
	('Avigayil', 'Sperka', 'avigayil@email.com','3256874102',1,1,'avigayils','avigayils'),
	('Michali', 'Zakutinsky', 'michali@email.com','3154697782',1,1,'michaliz','michaliz'),
	('Sales', 'User', 'sales@email.com','3214569870',1,2,'salesu','salesu'),
	('HR', 'User', 'michali@email.com','3265987410',1,3,'hru','hru'),
	('Marketing', 'User', 'michali@email.com','3256985200',1,4,'marketingu','marketingu')
GO
INSERT INTO Status (Description, ClosedInd, StatusCode)
VALUES
    ('Open', 0, 'OPEN'),
    ('In Progress', 0, 'INPRG'),
    ('Cancelled', 1, 'CANCL'),
    ('On Hold', 1, 'ONHLD'),
    ('Waiting For User', 1, 'WAITU'),
	('Completed',1, 'CMPLT');
GO
