--Start of Sample SQL Script--***************************
--Project Phase II -- Group H (TabletMonitor)
--This SQL Script was tested on
--Oracle Live SQL. To run, simply
--load this script file and run.
--***************************
--Part A
--***************************
/* Table creation: */

/*
Employee Table: Stores information about each Employee.
Employees haves the following attributes:
 - ID: unique numeric identifier. ID should not be manually
    set when adding new employees. Instead, omit ID and the table
    will automatically assign the next available ID to employee.
 - Fname: First name of employee.
 - Lname: Last name of employee.
 - Position: Employee's position in the company.
    Position be one of the following values "Team Member", "Supervisor".
    To add more positions modify the constraint CheckPositionValue.
*/
Create Sequence employee_id_sequence Start With 1;
Create Table Employee (
    ID Number(10) default employee_id_sequence.nextval Primary Key,
    Fname Varchar(30),
    Lname Varchar(30),
    Position Varchar(15) default 'Team Member'
    Constraint CheckPositionValue Check (Position = 'Team Member' OR Position = 'Supervisor') -- Position can only be TeamMember or Supervisor
);

/*
Device Table: Stores information about each physical device.
Devices haves the following attributes:
 - ID: unique numeric identifier. ID should not be manually
    set when adding new devices. Instead, omit ID and the table
    will automatically assign the next available ID to employee.
 - Make: device manufacturer. Possible values are 'Apple', 'Samsung', 'Lenovo'.
    Default make is 'Apple' as most Devices are expected to be Apple tablets.
    To add additional manufacturers modify constraint DeviceManufacturers.
 - Model: device model.
 - IsCheckedOut: whether device is currently checked out (in use) or
    is back in storage. IsCheckedOut can only be "Y" or "N".
*/
Create Sequence device_id_sequence Start With 1;
Create Table Device (
    ID Number(10) default device_id_sequence.nextval Primary Key,
    Make Varchar(30) default 'Apple'
    Constraint DeviceManufacturers Check (Make = 'Apple' OR Make = 'Samsung' OR Make = 'Lenovo'),
    Model Varchar(30),
    IsCheckedOut CHAR(1) default 'N' Check (IsCheckedOut = 'Y' OR IsCheckedOut = 'N')
);

/*
DeviceRecord Table: Stores information about each device usage.
    A DeviceRecord represent a single log or a session of use for a
    device being checked out for storage (and eventually returned).
DeviceRecords haves the following attributes:
 - DeviceId: The ID of the Device being checked out.
 - CheckOutTime: The dated time at which the device was checked out.
    CheckOutTime is in the company's local time zone.
 - ReturnTime: The dated time at which the device was returned.
    ReturnTime is null when the device is still in used (checked out).
    ReturnTime is null by default, since the device is initially checked out
    and returned later.
    ReturnTime is in the company's local time zone.
 - EmployeeId - The Employee ID of the employee that checked out the device.
*/
Create Table DeviceRecord (
    DeviceId Number(10),
    CheckOutTime Timestamp With Local Time Zone default CURRENT_TIMESTAMP,
    ReturnTime Timestamp With Local Time Zone default NULL,
    EmployeeId Number(10),
    Primary Key (DeviceId, CheckOutTime),
    Foreign Key (DeviceId) References Device(ID)
        /* Delete all records for a device, if the device is removed */
        On Delete Cascade,
        /* Following is an On Update trigger that 
            make sense for our DB but do not work in Oracle. */
        -- On Update No Action, -- Update all records to use the new device ID, if device ID is changed
    Foreign Key (EmployeeId) References Employee(ID),
        /* Following are On Delete/On Update triggers that 
            make sense for our DB but do not work in Oracle. */
        -- On Delete No Action, -- Retain records of employees even after they leave
        -- On Update Cascade -- Update all records to use the new employee ID, if the employee ID is changed
    Constraint ReturnAfterCheckOut Check (CheckOutTime < ReturnTime OR ReturnTime IS NULL)
);

--***************************
--***************************
--Part B
--***************************
/* Sample data: */

/*
We insert 10 employees into the database.
Notice we can omit ID and Position since these attributes
have appropriate default values: ID increments automatically
and the Position of all our employees is "Team Member".
*/
Insert Into Employee(Fname, Lname)
Values('Kenny', 'Burrel');

Insert Into Employee(Fname, Lname)
Values('Gordon', 'Smith');

Insert Into Employee(Fname, Lname)
Values('Jenny', 'Rosen');

Insert Into Employee(Fname, Lname, Position)
Values('David', 'Guetta', 'Supervisor');

Insert Into Employee(Fname, Lname, Position)
Values('Alex', 'Berry', 'Supervisor');

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


/*
We insert 9 devices into the database.
Notice we can omit Make for Apple devices since this is the default value.
*/
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

Insert Into Device(Make, Model)
Values('Samsung', 'Galaxy Tab S2');

Insert Into Device(Make, Model)
Values('Samsung', 'Galaxy Tab S2');

Insert Into Device(Make, Model)
Values('Lenovo', 'Tab 7 Essential');

Insert Into Device(Make, Model)
Values('Lenovo', 'Tab 7 Essential');

/*
We insert 6 DeviceRecords into the database.
These will indicate that some of our devices are currently checked out
by some of our employees.
*/
Insert Into DeviceRecord (DeviceId, EmployeeId)
Values(1, 2);

Insert Into DeviceRecord (DeviceId, EmployeeId)
Values(2, 3);

Insert Into DeviceRecord (DeviceId, EmployeeId)
Values(3, 4);

Insert Into DeviceRecord (DeviceId, EmployeeId)
Values(4, 6);

Insert Into DeviceRecord (DeviceId, EmployeeId)
Values(6, 8);

Insert Into DeviceRecord (DeviceId, EmployeeId)
Values(7, 9);


/* Make sure all devices currently checked out
(their DeviceRecord has no return time) are marked as checked out.*/
Update Device
Set Device.IsCheckedOut = 'Y'
Where Device.ID In (Select DeviceRecord.DeviceId as ID
                    From DeviceRecord
                    Where ReturnTime IS NULL);

/* To display all our tables run the following: */
-- Select *
-- From Employee;
-- Select *
-- From Device;
-- Select *
-- From DeviceRecord;

--***************************
--***************************
--Part C
--***************************
/* Useful queries: */

-- Number 1 
-- Computes a join of at least three tables 
-- This query join three table in order to much employe info, device info and their related data
-- associated with their checkout status 
  select e.Fname, e.Lname, d.make, D.Model, dr.checkouttime, dr.Returntime 
  from Device d JOIN devicerecord dr ON 
  D.ID = dr.deviceid JOIN employee e on dr.employeeid = E.ID;
-- Summary:
-- employee fname, lname, device make and model, device record checkout and check in time 

-- Number 2
-- Nested queries with the ANY operator thta uses a GROUP BY clause.
SELECT COUNT(ID), POSITION
FROM employee
WHERE id = ALL 
    (SELECT employeeid
    FROM devicerecord
    WHERE deviceid >= 12)
GROUP BY POSITION;

 --Number 3
 -- The following query selcts deviceid,checkOutTime, returnTime from deviceRecord and returns those record for Kenny.
SELECT deviceid,checkOutTime, returnTime FROM deviceRecord 
where deviceid= (SELECT id
FROM employee where fname='Kenny');

--Number 4
-- The following query selcts deviceID and checkOutTime from deviceRecord table and model from device then join them using FULL JOIN.
SELECT deviceId, checkOutTime, device.model
FROM deviceRecord
FULL OUTER JOIN device ON devicerecord.deviceId = device.id;

-- Number 5: Uses nested queries with any of the set operations UNION, EXCEPT, or INTERSECT.
-- Select all employees who have currently checked out a device, but do not have Supervisor position.
Select Employee.ID as EmployeeID, Employee.Fname as FirstName, Employee.Lname as LastName
From Employee, DeviceRecord, Device
Where Employee.ID = DeviceRecord.DeviceId AND Device.ID = DeviceRecord.DeviceId AND Device.IsCheckedOut = 'Y'
Intersect 
Select Employee.ID as EmployeeID, Employee.Fname as FirstName, Employee.Lname as LastName
From Employee
Where Employee.Position <> 'Supervisor';

--Number 6
--This query will check a device that has been checked out by employee by using employee number
  select e.Lname, d.id, d.make, d.model  
  from employee e, device d, devicerecord dr
  where e.id = dr.EMPLOYEEID and d.id = dr.DEVICEID;
--Summary:
--display Lname, device id, device make and model of 
--the tables currently has been checked out 

--Number 7
--This query will find any device that has been checked out by using employee last name.
  select e.id, e.Lname,e.Fname, d.model, dr.checkouttime, dr.returntime
  from device d, employee e, devicerecord dr
  where e.Lname = 'Rosen' and d.id = dr.deviceid 
  and e.id = dr.employeeid;
--Summery:
--employeeid, lname, fname, model of the device, checouttime and return status 

--number 8
--This query will count and return the number of device exist in the company with their model and make 
  select count(id) as "NUMBER OF DEVICE", model, make
  from device 
  group by model,make;
 --Summary :
 --Number of table,Model and their make
 
 --Number 9
--This query show any device that has not been returned by employee
--This enable you to quickly check how many device has not been return and who has not returned yet
  select e.id, e.Lname, e.Fname, d.model, d.make,checkouttime, returntime
  from employee e, devicerecord, device d
  where returntime is null and devicerecord.employeeid = e.id and
  d.id = devicerecord.deviceid;
--Summary:
--employeeid, lname, fname, device model, device make, checkouttime and returntime 

--Number 10
-- This query will return how many employee are registered in order to check out device
 select count(id) as "Number of Employees"
 from employee;
--Summary:
--Number of employee (one single row in our case, 10)
