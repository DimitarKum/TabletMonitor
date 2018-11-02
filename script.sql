--Start of Sample SQL Script--***************************
--Project Phase II -- Group H (TabletMonitor)
--This SQL Script was tested on
--Oracle Live SQL. To run, simply
--load this script file and run.
--***************************
--Part A
--***************************

-- Drop tables if already existing to recreate schema
-- Drop Table Device;
-- Drop Table DeviceRecord;
-- Drop Table Employee;

-- Create Employee Table
Create Sequence employee_id_sequence Start With 1;
Create Table Employee (
    ID Number(10) default employee_id_sequence.nextval Primary Key,
    Fname Varchar(30),
    Lname Varchar(30),
    Position Varchar(15) default 'Team Member'
    Check (Position = 'Team Member' OR Position = 'Supervisor') -- Position can only be TeamMember or Supervisor
);

-- Create Device table
Create Sequence device_id_sequence Start With 1;
Create Table Device (
    ID Number(10) default device_id_sequence.nextval Primary Key,
    Make Varchar(30) default 'Apple' Check (Make = 'Apple' OR Make = 'Android'),
    Model Varchar(30),
    IsCheckedOut CHAR(1) default 'N' Check (IsCheckedOut = 'Y' OR IsCheckedOut = 'N')
);

-- Create DeviceRecord table that keeps track of when a device is checked out and returned
Create Table DeviceRecord (
    DeviceId Number(10),
    CheckOutTime Timestamp With Local Time Zone default CURRENT_TIMESTAMP,
    ReturnTime Timestamp With Local Time Zone default NULL,
    EmployeeId Number(10),
    Primary Key (DeviceId, CheckOutTime),
    Foreign Key (DeviceId) References Device(ID)
        On Delete Cascade, -- Delete all records for a device, if the device is removed
        -- On Update No Action, -- Update all records to use the new device ID, if device ID is changed
    Foreign Key (EmployeeId) References Employee(ID),
        -- On Delete No Action, -- Retain records of employees even after they leave
        -- On Update Cascade -- Update all records to use the new employee ID, if the employee ID is changed
    Constraint ReturnAfterCheckOut Check (CheckOutTime < ReturnTime OR ReturnTime IS NULL)
);

--***************************
--***************************
--Part B
--***************************

-- Some sample insert statements to populate data so we can see what our tables look like:
Insert Into Employee(Fname, Lname)
Values('Kenny', 'Burrel');

Insert Into Employee(Fname, Lname)
Values('Gordon', 'Smith');

Insert Into Employee(Fname, Lname)
Values('Jenny', 'Rosen');

Insert Into Employee(Fname, Lname)
Values('David', 'Guetta');


Insert Into Device(Model)
Values('IPad Air');
Insert Into Device(Model)
Values('IPad Air');
Insert Into Device(Model)
Values('IPad Air');
Insert Into Device(Model)
Values('IPad Pro');
Insert Into Device(Model)
Values('IPad Pro');

Insert Into DeviceRecord (DeviceId, EmployeeId)
Values(1, 2);
Insert Into DeviceRecord (DeviceId, EmployeeId)
Values(2, 3);

-- Show all our tables:
Select *
From Employee;
Select *
From Device;
Select *
From DeviceRecord;


--***************************
--***************************
--Part C
--***************************