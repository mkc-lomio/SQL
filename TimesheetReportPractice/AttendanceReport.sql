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

  INSERT INTO @WorkedHours ([Date],TotalHours)
EXEC spGetEmployeeWorkHours @paramEmployeeId = ' + CAST(@pEmployeeId AS VARCHAR(MAX))  + ', 
@paramDateStart = ''' + Convert(nvarchar(MAX), @pDateStart, 23) + ''',
@paramDateEnd =  ''' + Convert(nvarchar(MAX), @pDateEnd, 23) + '''

  DECLARE @Holiday TABLE
  (
     [date]     VARCHAR(200),
     totalhours DECIMAL(10, 2)
  );

  

INSERT INTO @Holiday ([Date],TotalHours)
EXEC spGetEmployeeHoliday @paramEmployeeId = ' + CAST(@pEmployeeId AS VARCHAR(MAX))  + ', 
@paramDateStart = ''' + Convert(nvarchar(MAX), @pDateStart, 23) + ''',
@paramDateEnd =  ''' + Convert(nvarchar(MAX), @pDateEnd, 23) + '''

    DECLARE @VacationLeave TABLE
  (
     [date]     VARCHAR(200),
     totalhours DECIMAL(10, 2)
  );

  INSERT INTO @VacationLeave ([Date],TotalHours)
EXEC spGetEmployeeLeave @paramEmployeeId = ' + CAST(@pEmployeeId AS VARCHAR(MAX))  + ', 
@paramDateStart = ''' + Convert(nvarchar(MAX), @pDateStart, 23) + ''',
@paramDateEnd =  ''' + Convert(nvarchar(MAX), @pDateEnd, 23) + ''',
@paramLeaveCode =  ''VL''

    DECLARE @SickLeave TABLE
  (
     [date]     VARCHAR(200),
     totalhours DECIMAL(10, 2)
  );

  INSERT INTO @SickLeave ([Date],TotalHours)
EXEC spGetEmployeeLeave @paramEmployeeId = ' + CAST(@pEmployeeId AS VARCHAR(MAX))  + ', 
@paramDateStart = ''' + Convert(nvarchar(MAX), @pDateStart, 23) + ''',
@paramDateEnd =  ''' + Convert(nvarchar(MAX), @pDateEnd, 23) + ''',
@paramLeaveCode =  ''SL''

    DECLARE @EmergencyLeave TABLE
  (
     [date]     VARCHAR(200),
     totalhours DECIMAL(10, 2)
  );

  INSERT INTO @EmergencyLeave ([Date],TotalHours)
EXEC spGetEmployeeLeave @paramEmployeeId = ' + CAST(@pEmployeeId AS VARCHAR(MAX))  + ', 
@paramDateStart = ''' + Convert(nvarchar(MAX), @pDateStart, 23) + ''',
@paramDateEnd =  ''' + Convert(nvarchar(MAX), @pDateEnd, 23) + ''',
@paramLeaveCode =  ''EL''

    DECLARE @UnpaidLeave TABLE
  (
     [date]     VARCHAR(200),
     totalhours DECIMAL(10, 2)
  );

  
INSERT INTO @UnpaidLeave ([Date],TotalHours)
EXEC spGetEmployeeLeave @paramEmployeeId = ' + CAST(@pEmployeeId AS VARCHAR(MAX))  + ', 
@paramDateStart = ''' + Convert(nvarchar(MAX), @pDateStart, 23) + ''',
@paramDateEnd =  ''' + Convert(nvarchar(MAX), @pDateEnd, 23) + ''',
@paramLeaveCode =  ''UL''


    DECLARE @TOILLeave TABLE
  (
     [date]     VARCHAR(200),
     totalhours DECIMAL(10, 2)
  );

  INSERT INTO @TOILLeave ([Date],TotalHours)
EXEC spGetEmployeeLeave @paramEmployeeId = ' + CAST(@pEmployeeId AS VARCHAR(MAX))  + ', 
@paramDateStart = ''' + Convert(nvarchar(MAX), @pDateStart, 23) + ''',
@paramDateEnd =  ''' + Convert(nvarchar(MAX), @pDateEnd, 23) + ''',
@paramLeaveCode =  ''TOIL''


    DECLARE @BonusLeave TABLE
  (
     [date]     VARCHAR(200),
     totalhours DECIMAL(10, 2)
  );

    INSERT INTO @BonusLeave ([Date],TotalHours)
EXEC spGetEmployeeLeave @paramEmployeeId = ' + CAST(@pEmployeeId AS VARCHAR(MAX))  + ', 
@paramDateStart = ''' + Convert(nvarchar(MAX), @pDateStart, 23) + ''',
@paramDateEnd =  ''' + Convert(nvarchar(MAX), @pDateEnd, 23) + ''',
@paramLeaveCode =  ''Bonus''


   DECLARE @TotalPerDay TABLE
  (
     [date]     VARCHAR(200),
     totalhours DECIMAL(10, 2)
  );

  INSERT INTO @TotalPerDay
            ([date],
             totalhours)
			SELECT [Date], SUM(TotalHours) FROM (
			 SELECT * from @WorkedHours
			 UNION ALL 
			 SELECT * from @Holiday
			  UNION ALL 
			 SELECT * from @VacationLeave
			  UNION ALL 
			 SELECT * from @SickLeave
			  UNION ALL 
			 SELECT * from @EmergencyLeave
			  UNION ALL 
			 SELECT * from @UnpaidLeave
			  UNION ALL 
			 SELECT * from @TOILLeave
			 UNION ALL 
			 SELECT * from @BonusLeave
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
		SELECT 3  AS Id,
               ''Vacation Leave'' AS [Description],
               *
        FROM   @VacationLeave
		     UNION ALL
		SELECT 4         AS Id,
               ''Personal Leave'' AS [Description],
               *
        FROM   @UnpaidLeave
		    UNION ALL
		SELECT 5         AS Id,
               ''Emergency Leave'' AS [Description],
               *
        FROM   @EmergencyLeave
		    UNION ALL
		SELECT 6    AS Id,
               ''Sick Leave'' AS [Description],
               *
        FROM   @SickLeave
			    UNION ALL
		SELECT 7    AS Id,
               ''TOIL Leave'' AS [Description],
               *
        FROM   @TOILLeave
        UNION ALL
		SELECT 8   AS Id,
               ''Bonus Leave'' AS [Description],
               *
        FROM   @BonusLeave
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

--SELECT @sql

EXEC sp_executesql @sql;
END;


EXEC spGetEmployeeTimeSheetReport @pEmployeeId = 543, @pDateStart = '2023-10-01', @pDateEnd = '2023-10-15'


-- Id	Description	10/01/2023	10/02/2023	10/03/2023	10/04/2023	10/05/2023	10/06/2023	10/07/2023	10/08/2023	10/09/2023	10/10/2023	10/11/2023	10/12/2023	10/13/2023	10/14/2023	10/15/2023	Total
-- 1	Worked Hours	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	8.62	9.33	0.00	0.00	0.00	0.00	17.95
-- 2	Holiday	0.00	8.00	0.00	0.00	0.00	0.00	8.00	0.00	0.00	0.00	8.00	0.00	0.00	0.00	0.00	24.00
-- 3	Vacation Leave	8.00	8.00	0.00	0.00	0.00	8.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	8.00	32.00
-- 4	Personal Leave	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	8.00	8.00	0.00	0.00	0.00	0.00	0.00	16.00
-- 5	Emergency Leave	0.00	0.00	0.00	0.00	0.00	0.00	0.00	8.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	8.00
-- 6	Sick Leave	8.00	8.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	4.00	8.00	36.00
-- 7	TOIL Leave	0.00	0.00	0.00	4.00	8.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	12.00
-- 8	Bonus Leave	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	4.00	8.00	0.00	0.00	0.00	12.00
-- 10	Total	16.00	24.00	0.00	4.00	8.00	8.00	8.00	8.00	8.00	16.62	21.33	8.00	0.00	4.00	16.00	157.95