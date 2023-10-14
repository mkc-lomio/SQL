CREATE OR ALTER PROCEDURE spGetEmployeeWorkHours
    @paramEmployeeId AS INT,
    @paramDateStart AS DATE,
	@paramDateEnd AS DATE
AS
BEGIN

SELECT * FROM (

SELECT * FROM (
SELECT FORMAT(ea.attendanceDate,'MM/dd/yyyy') as [Description],
SUM(ea.TotalHours)  as TotalHours
FROM Employeeattendance ea 
WHERE ea.employeeClientId = @paramEmployeeId AND ea.attendanceDate BETWEEN @paramDateStart AND @paramDateEnd
GROUP BY FORMAT(ea.attendanceDate,'MM/dd/yyyy')
) WorkedHours 

UNION ALL

SELECT * FROM (
SELECT  [Date] as [Description], 0 as TotalHours 
FROM GetDateSequencefunc('2023-10-01', '2023-10-15') -- SQL FUNCTION
WHERE [Date] NOT IN (

SELECT FORMAT(ea.attendanceDate,'MM/dd/yyyy') as [Description]
FROM Employeeattendance ea 
WHERE ea.employeeClientId = @paramEmployeeId AND ea.attendanceDate BETWEEN @paramDateStart AND @paramDateEnd
GROUP BY FORMAT(ea.attendanceDate,'MM/dd/yyyy')

)) DateRange 

) WorkHoursTimeSheetReport 
UNION

SELECT 'Total', CAST(SUM(TotalHours) AS DECIMAL(10,2)) as TotalHours FROM (

SELECT FORMAT(ea.attendanceDate,'MM/dd/yyyy') as [Description],
SUM(ea.TotalHours)  as TotalHours
FROM Employeeattendance ea 
WHERE ea.employeeClientId = @paramEmployeeId AND ea.attendanceDate BETWEEN @paramDateStart AND @paramDateEnd
GROUP BY FORMAT(ea.attendanceDate,'MM/dd/yyyy')

) WorkedHours 


ORDER BY [Description]

END;


EXEC spGetEmployeeWorkHours @paramEmployeeId = 0, @paramDateStart = '2023-10-01', @paramDateEnd = '2023-10-15'

-- RESULT

-- Description	TotalHours
-- 10/01/2023	0
-- 10/02/2023	0
-- 10/03/2023	0
-- 10/04/2023	0
-- 10/05/2023	0
-- 10/06/2023	0
-- 10/07/2023	0
-- 10/08/2023	0
-- 10/09/2023	0
-- 10/10/2023	8.61666666666667
-- 10/11/2023	9.33333333333333
-- 10/12/2023	0
-- 10/13/2023	0
-- 10/14/2023	0
-- 10/15/2023	0
-- Total	17.95