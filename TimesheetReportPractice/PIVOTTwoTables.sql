DECLARE @WorkedHours TABLE (
		[Description] VARCHAR(200),
		[Date] VARCHAR(200),
		TotalHours DECIMAL(10,2)
		);

		
INSERT INTO @WorkedHours ([Description],[Date],TotalHours)
SELECT 'Work Hours' as [Description], [Date], 0 as TotalHours 
FROM GetDateSequencefunc('2023-10-01', '2023-10-15') -- SQL FUNCTION


DECLARE @Holiday TABLE (
		[Description] VARCHAR(200),
		[Date] VARCHAR(200)
		,TotalHours DECIMAL(10,2)
		);

INSERT INTO @Holiday ([Description],[Date],TotalHours)
SELECT  'Holiday' as [Description], [Date], 0 as TotalHours 
FROM GetDateSequencefunc('2023-10-01', '2023-10-15') -- SQL FUNCTION

DECLARE @columns NVARCHAR(MAX);
DECLARE @sql NVARCHAR(MAX);

SELECT @columns = STRING_AGG(QUOTENAME(CONVERT(VARCHAR(10), [Date], 120)), ', ')
FROM (
     SELECT [Date] FROM GetDateSequencefunc('2023-10-01', '2023-10-15')
) AS DateRange;


SET @sql = N'
DECLARE @WorkedHours TABLE (
		[Description] VARCHAR(200),
		[Date] VARCHAR(200),
		TotalHours DECIMAL(10,2)
		);

		
INSERT INTO @WorkedHours ([Description],[Date],TotalHours)
SELECT ''Work Hours'' as [Description], [Date], 0 as TotalHours 
FROM GetDateSequencefunc(''2023-10-01'', ''2023-10-15'') 

DECLARE @Holiday TABLE (
		[Description] VARCHAR(200),
		[Date] VARCHAR(200)
		,TotalHours DECIMAL(10,2)
		);

INSERT INTO @Holiday ([Description],[Date],TotalHours)
SELECT  ''Holiday'' as [Description], [Date], 0 as TotalHours 
FROM GetDateSequencefunc(''2023-10-01'', ''2023-10-15'') 


SELECT *
FROM (
     SELECT * FROM @WorkedHours
	 UNION ALL
	 SELECT * FROM @Holiday
) AS SourceData
PIVOT (
    MAX([TotalHours])
    FOR [Date] IN (' + @columns + ')
) AS PivotTable';

SELECT @sql

EXEC sp_executesql @sql;

-- RESULT
-- Description	10/01/2023	10/02/2023	10/03/2023	10/04/2023	10/05/2023	10/06/2023	10/07/2023	10/08/2023	10/09/2023	10/10/2023	10/11/2023	10/12/2023	10/13/2023	10/14/2023	10/15/2023
-- Holiday	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00
-- Work Hours	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00