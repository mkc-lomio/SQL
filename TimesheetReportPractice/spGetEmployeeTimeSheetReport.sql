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

SELECT *
FROM (
    SELECT ''' + 'Worked Hours' + ''' as [Description], * FROM @WorkedHours
) AS SourceData
PIVOT (
    MAX([TotalHours])
    FOR [Date] IN (' + @columns + ',' + '[Total]' + ')
) AS PivotTable';

EXEC sp_executesql @sql;

END;

-- Description	10/01/2023	10/02/2023	10/03/2023	10/04/2023	10/05/2023	10/06/2023	10/07/2023	10/08/2023	10/09/2023	10/10/2023	10/11/2023	10/12/2023	10/13/2023	10/14/2023	10/15/2023	Total
-- Worked Hours	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	8.62	9.33	0.00	0.00	0.00	0.00	17.95