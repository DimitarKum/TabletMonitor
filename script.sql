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

--Added extra sample data -- leul
Insert Into Employee(Fname, Lname)
Values('Alex', 'Berry');

Insert Into Employee(Fname, Lname)
Values('Dimitar', 'Kum');

Insert Into Employee(Fname, Lname)
Values('Prince', 'Amare');

Insert Into Employee(Fname, Lname)
Values('John', 'Meany');

Insert Into Employee(Fname, Lname)
Values('Ras', 'Marley');

Insert Into Employee(Fname, Lname)
Values('Kelly', 'Johnson');


Insert Into Device(Model)
Values('IPad Air');

Insert Into Device(Model)
Values('IPad Mini');

Insert Into Device(Model)
Values('IPad Pro');

Insert Into Device(Model)
Values('IPad Air');

Insert Into Device(Model)
Values('IPad Pro');

Insert Into Device(Model)
Values('Android');

Insert Into Device(Model)
Values('Android');

Insert Into Device(Model)
Values('Android');

Insert Into Device(Model)
Values('Android');

Insert Into DeviceRecord (DeviceId, EmployeeId)
Values(1, 2);

Insert Into DeviceRecord (DeviceId, EmployeeId)
Values(2, 3);

-- Added more DeviceRecordes --
Insert Into DeviceRecord (DeviceId, EmployeeId)
Values(3, 4);

Insert Into DeviceRecord (DeviceId, EmployeeId)
Values(4, 5);

Insert Into DeviceRecord (DeviceId, EmployeeId)
Values(5, 6);

Insert Into DeviceRecord (DeviceId, EmployeeId)
Values(6, 7);

Insert Into DeviceRecord (DeviceId, EmployeeId)
Values(7, 8);

Insert Into DeviceRecord (DeviceId, EmployeeId)
Values(8, 9);

Insert Into DeviceRecord (DeviceId, EmployeeId)
Values(9, 10);

Insert Into DeviceRecord (DeviceId, EmployeeId)
Values(10, 1);

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
--Number 1 
--Computes a join of at least three tables 
--This query join three table in order to much employe info, device info and their related data
--associated with their checkout status 
  select e.Fname, e.Lname, d.make, D.Model, dr.checkouttime, dr.Returntime 
  from Device d JOIN devicerecord dr ON 
  D.ID = dr.deviceid JOIN employee e on dr.employeeid = E.ID
-- Summary:
--employee fname, lname, device make and model, device record checkout and check in time 

--Number 3
-- Nested queries with the ANY operator thta uses a GROUP BY clause.
SELECT COUNT(ID), POSITION
  FROM employee
 WHERE id = ALL 
       (SELECT employeeid
          FROM devicerecord
         WHERE deviceid >= 12)
         
         GROUP BY POSITION
         
 --Number 4
 -- The following query selcts deviceid,checkOutTime, returnTime from deviceRecord and returns those record for Kenny.


SELECT deviceid,checkOutTime, returnTime FROM deviceRecord 
where deviceid= (SELECT id
FROM employee where fname='Kenny')


--Number 5
-- The following query selcts deviceID and checkOutTime from deviceRecord table and model from device then join them using FULL JOIN.

SELECT deviceId, checkOutTime, device.model
FROM deviceRecord
FULL OUTER JOIN device ON devicerecord.deviceId = device.id;


--Number 6
--This query will check a device that has been checked out by employee by using employee number
  select e.Lname, d.id, d.make, d.model  
  from employee e, device d, devicerecord dr
  where e.id = dr.EMPLOYEEID and d.id = dr.DEVICEID
--Summary:
--display Lname, device id, device make and model of 
--the tables currently has been checked out 

--Number 7
--This query will find any device that has been checked out by using employee last name.
  select e.id, e.Lname,e.Fname, d.model, dr.checkouttime, dr.returntime
  from device d, employee e, devicerecord dr
  where e.Lname = 'Rosen' and d.id = dr.deviceid 
  and e.id = dr.employeeid
--Summery:
--employeeid, lname, fname, model of the device, checouttime and return status 

--number 8
--This query will count and return the number of device exist in the company with their model and make 
  select count(id) as "NUMBER OF DEVICE", model, make
  from device 
  group by model,make
 --Summary :
 --Number of table,Model and their make
 
 --Number 9
--This query show any device that has not been returned by employee
--This enable you to quickly check how many device has not been return and who has not returned yet
  select e.id, e.Lname, e.Fname, d.model, d.make,checkouttime, returntime
  from employee e, devicerecord, device d
  where returntime is null and devicerecord.employeeid = e.id and
  d.id = devicerecord.deviceid
--Summary:
--employeeid, lname, fname, device model, device make, checkouttime and returntime 

--Number 10
-- This query will return how many employee are registered in order to check out device
 select count(id) as "Number of Employee"
 from employee
--Summary:
--Number of employee (one single row in our case, 10)


