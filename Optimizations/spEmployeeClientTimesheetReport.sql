/****** Object:  StoredProcedure [dbo].[spEmployeeClientTimesheetReport]     ******/
DROP PROCEDURE IF EXISTS [dbo].[spEmployeeClientTimesheetReport]
GO
/****** Object:  StoredProcedure [dbo].[spEmployeeClientTimesheetReport]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [dbo].[spEmployeeClientTimesheetReport]
    @paramClientId AS INT,
    @paramDateStart AS DATE,
	@paramDateEnd AS DATE,
	@paramEmployeeClientId AS NVARCHAR(MAX)
AS
BEGIN
 
   
SELECT * FROM (
SELECT 
FORMAT(ea.attendanceDate,'yyyy-MM-dd') AS [Date],
ea.TotalHours,
CONCAT(e.FirstName, ' ', e.LastName) AS FullName,
c.ClientName as Client,
s.StateOrCityName AS [State],
co.CountryName AS Country,
ec.Id AS EmployeeClientId,
 CASE
            WHEN ea.IsManualHours = 1
               THEN 'ManualHours'
               ELSE 'WorkedHours'
       END as [Type],
[as].ApprovalStatusDescription AS Details
FROM Employeeattendance ea 
LEFT JOIN EmployeeClient ec ON ec.Id = ea.employeeClientId
LEFT JOIN [State] s ON s.Id = ec.stateId 
LEFT JOIN Country co ON co.Id = s.CountryId
LEFT JOIN Employee e ON e.Id = ec.EmployeeId
LEFT JOIN Client c ON c.Id = ec.ClientId
LEFT JOIN UserRole ur ON ur.Id = e.UserRoleId
LEFT JOIN ApprovalStatus [as] ON [as].Id = ea.ApprovalStatusId
WHERE 
(
  ec.TerminationDate IS NULL 
  OR ec.TerminationDate > DateAdd(
    day, 
    -1, 
    getDate()
  ) ) AND
ec.ClientId = @paramClientId AND
ec.Id IN (SELECT value AS splitted_value FROM STRING_SPLIT(@paramEmployeeClientId, ',')) AND
(ea.ApprovalStatusId IN (1,2,3) OR ea.ApprovalStatusId IS NULL) AND -- 1 => Submitted, 2 => Approved, 3 => Rejected
FORMAT(ea.attendanceDate,'yyyy-MM-dd') BETWEEN @paramDateStart AND @paramDateEnd

UNION ALL

SELECT *
FROM (
SELECT 
FORMAT(h.HolidayDate,'yyyy-MM-dd') AS [Date],
8 AS TotalHours,
CONCAT(e.FirstName, ' ', e.LastName) AS FullName,
c.ClientName AS Client,
s.StateOrCityName AS [State],
co.CountryName AS Country,
ec.Id AS EmployeeClientId,
'Holiday' AS [Type],
h.holidayName AS Details
FROM Holiday h
LEFT JOIN [State] s ON s.Id = h.stateId 
LEFT JOIN Country co ON co.Id = s.CountryId
LEFT JOIN EmployeeClient ec ON ec.StateId = s.Id
LEFT JOIN Employee e ON e.Id = ec.EmployeeId
LEFT JOIN Client c ON c.Id = ec.ClientId
WHERE 
(
  ec.TerminationDate IS NULL 
  OR ec.TerminationDate > DateAdd(
    day, 
    -1, 
    getDate()
  ) ) AND
ec.ClientId = @paramClientId AND
ec.Id in (SELECT value AS splitted_value FROM STRING_SPLIT(@paramEmployeeClientId, ','))
AND FORMAT(h.HolidayDate,'yyyy-MM-dd') BETWEEN @paramDateStart AND @paramDateEnd
) Holiday GROUP BY [Date], TotalHours, FullName, Client, [State], Country, EmployeeClientId, [Type], Details

UNION ALL


SELECT 
FORMAT(LeaveDate,'yyyy-MM-dd') AS [Date],
WithPay + WithoutPay AS TotalHours,
FullName,
Client,
[State],
Country,
EmployeeClientId,
'Leave' AS [Type],
Details
 FROM (
SELECT 
eld.Id AS EmployeeLeaveDetailId,
elh.Id AS EmployeeLeaveHeaderId,
eld.LeaveDate,
eld.WithPay,
eld.WithoutPay,
eld.[Status] AS ApprovalStatusId, 
[as].ApprovalStatusDescription AS Details,
CONCAT(e.FirstName, ' ', e.LastName) AS FullName,
lt.LeaveName,
lt.LeaveCode,
ec.Id as EmployeeClientId,
s.StateOrCityName AS [State],
co.CountryName AS Country,
c.ClientName as Client
FROM EmployeeLeaveDetail eld
LEFT JOIN EmployeeLeaveHeader elh ON elh.Id = eld.EmployeeLeaveHeaderId
LEFT JOIN ApprovalStatus [as] ON [as].Id = eld.[Status]
LEFT JOIN EmployeeClient ec ON ec.Id = elh.EmployeeClientId 
LEFT JOIN [State] s ON s.Id = ec.stateId 
LEFT JOIN Country co ON co.Id = s.CountryId
LEFT JOIN Employee e ON e.Id = ec.EmployeeId
LEFT JOIN Client c ON c.Id = ec.ClientId
LEFT JOIN LeaveType lt ON lt.Id = elh.LeaveTypeId
WHERE 
(
  ec.TerminationDate IS NULL 
  OR ec.TerminationDate > DateAdd(
    day, 
    -1, 
    getDate()
  ) ) AND 
ec.ClientId = @paramClientId AND
ec.Id IN (SELECT value AS splitted_value FROM STRING_SPLIT(@paramEmployeeClientId, ',')) AND
[as].ApprovalStatusDescription  IN ('Approved','Submitted')
AND eld.LeaveDate BETWEEN @paramDateStart AND @paramDateEnd
AND lt.LeaveCode IN (SELECT slt.LeaveCode from ClientLeaveType sclt
LEFT JOIN LeaveType slt ON slt.Id = sclt.LeaveTypeId
WHERE sclt.ClientId = ec.ClientId)
) EmployeeVacationLeaveDetail

) TeamMember ORDER BY EmployeeClientId ASC, [DATE] ASC
    OPTION (RECOMPILE);


END;

-- NOTE
-- OPTIMIZE THE QUERY USING THE ''OPTION (RECOMPILE)'' code
-- REFERENCE: https://www.tangrainc.com/blog/2007/08/parameter-sniffing/

-- SQL Server 2005 offers the new query hint RECOMPILE which will force recompilation of the individual query.
-- This method is better than the prior method because recompilation will affect only one statement and 
-- all other queries in the stored procedure will not be recompiled.
