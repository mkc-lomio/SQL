CREATE OR ALTER PROCEDURE spGetEmployeeTimeSheetReport
    @pEmployeeId AS INT,
    @pDateStart AS DATE,
	@pDateEnd AS DATE
AS
BEGIN

DECLARE @columns NVARCHAR(MAX);
DECLARE @sql NVARCHAR(MAX);

SELECT @columns = STRING_AGG(QUOTENAME(CONVERT(VARCHAR(10), [Date], 120)), ', ')
FROM (
     SELECT [Date] FROM GetDateSequencefunc(@pDateStart, @pDateEnd)
) AS DateRange;

SET @sql = N'

DECLARE @WorkedHours TABLE (
		[Date] VARCHAR(200)
		,TotalHours DECIMAL(10,2)
		);

INSERT INTO @WorkedHours ([Date],TotalHours)
EXEC spGetEmployeeWorkHours @paramEmployeeId = ' + CAST(@pEmployeeId AS VARCHAR(MAX))  + ', 
@paramDateStart = ''' + Convert(nvarchar(MAX), @pDateStart, 23) + ''',
@paramDateEnd =  ''' + Convert(nvarchar(MAX), @pDateEnd, 23) + '''


DECLARE @Holiday TABLE (
		[Date] VARCHAR(200)
		,TotalHours DECIMAL(10,2)
		);

INSERT INTO @Holiday ([Date],TotalHours)
EXEC spGetEmployeeHoliday @paramEmployeeId = ' + CAST(@pEmployeeId AS VARCHAR(MAX))  + ', 
@paramDateStart = ''' + Convert(nvarchar(MAX), @pDateStart, 23) + ''',
@paramDateEnd =  ''' + Convert(nvarchar(MAX), @pDateEnd, 23) + '''

SELECT *
FROM (
   SELECT 2 AS Id, ''Holiday'' AS [Description],
               *
        FROM   @Holiday
		UNION ALL
SELECT 1 AS Id, ''Worked Hours'' AS [Description],
               *
        FROM   @WorkedHours 
) AS SourceData
PIVOT (
    MAX([TotalHours])
    FOR [Date] IN (' + @columns + ',' + '[Total]' + ')
) AS PivotTable ORDER BY Id';

EXEC sp_executesql @sql;
END;


EXEC spGetEmployeeTimeSheetReport @pEmployeeId = 543, @pDateStart = '2023-10-01', @pDateEnd = '2023-10-15'

-- 1	Worked Hours	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	8.62	9.33	0.00	0.00	0.00	0.00	17.95
-- 2	Holiday	0.00	8.00	0.00	0.00	0.00	0.00	8.00	0.00	0.00	0.00	8.00	0.00	0.00	0.00	0.00	24.00