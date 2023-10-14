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

DECLARE @WorkedHours TABLE
  (
     [date]     VARCHAR(200),
     totalhours DECIMAL(10, 2)
  );

  DECLARE @Holiday TABLE
  (
     [date]     VARCHAR(200),
     totalhours DECIMAL(10, 2)
  );

   DECLARE @TotalPerDay TABLE
  (
     [date]     VARCHAR(200),
     totalhours DECIMAL(10, 2)
  );


INSERT INTO @WorkedHours ([Date],TotalHours)
EXEC spGetEmployeeWorkHours @paramEmployeeId = ' + CAST(@pEmployeeId AS VARCHAR(MAX))  + ', 
@paramDateStart = ''' + Convert(nvarchar(MAX), @pDateStart, 23) + ''',
@paramDateEnd =  ''' + Convert(nvarchar(MAX), @pDateEnd, 23) + '''

INSERT INTO @Holiday ([Date],TotalHours)
EXEC spGetEmployeeHoliday @paramEmployeeId = ' + CAST(@pEmployeeId AS VARCHAR(MAX))  + ', 
@paramDateStart = ''' + Convert(nvarchar(MAX), @pDateStart, 23) + ''',
@paramDateEnd =  ''' + Convert(nvarchar(MAX), @pDateEnd, 23) + '''

  INSERT INTO @TotalPerDay
            ([date],
             totalhours)
			SELECT [Date], SUM(TotalHours) FROM (
			 SELECT * from @WorkedHours
			 UNION ALL 
			 SELECT * from @Holiday
			) A GROUP BY [date]

SELECT *
FROM (
   SELECT 1   AS Id,
               ''Worked Hours'' AS [Description],
               *
        FROM   @WorkedHours
        UNION ALL
		SELECT 2         AS Id,
               ''Holiday'' AS [Description],
               *
        FROM   @Holiday
		UNION ALL
		SELECT 10   AS Id,
               ''Total'' AS [Description],
               *
        FROM  @TotalPerDay
) AS SourceData
PIVOT (
    MAX([TotalHours])
    FOR [Date] IN (' + @columns + ',' + '[Total]' + ')
) AS PivotTable ORDER BY Id';

EXEC sp_executesql @sql;
END;


EXEC spGetEmployeeTimeSheetReport @pEmployeeId = 543, @pDateStart = '2023-10-01', @pDateEnd = '2023-10-15'

-- Id	Description	10/01/2023	10/02/2023	10/03/2023	10/04/2023	10/05/2023	10/06/2023	10/07/2023	10/08/2023	10/09/2023	10/10/2023	10/11/2023	10/12/2023	10/13/2023	10/14/2023	10/15/2023	Total
-- 1	Worked Hours	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	8.62	9.33	0.00	0.00	0.00	0.00	17.95
-- 2	Holiday	0.00	8.00	0.00	0.00	0.00	0.00	8.00	0.00	0.00	0.00	8.00	0.00	0.00	0.00	0.00	24.00
-- 10	Total	0.00	8.00	0.00	0.00	0.00	0.00	8.00	0.00	0.00	8.62	17.33	0.00	0.00	0.00	0.00	41.95