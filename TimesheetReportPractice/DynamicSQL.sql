-- Define variables for the dynamic date range
DECLARE @StartDate DATE = '2023-10-01';
DECLARE @EndDate DATE = '2023-10-15';

-- Generate a dynamic SQL statement to pivot the data within the specified date range
DECLARE @PivotSQL NVARCHAR(MAX);

SET @PivotSQL = N'
    SELECT *
    FROM (
        SELECT ID, ea.attendanceDate
        FROM Employeeattendance ea
        WHERE ea.attendanceDate >= ' + QUOTENAME(@StartDate, '''') + ' AND ea.attendanceDate <= ' + QUOTENAME(@EndDate, '''') + '
    ) AS SourceData
    PIVOT (
        COUNT(ID) FOR attendanceDate IN (
            ' + QUOTENAME(@StartDate) + ', ' + QUOTENAME(@EndDate) + '
        )
    ) AS PivotTable';

-- Execute the dynamic SQL statement
EXEC sp_executesql @PivotSQL;