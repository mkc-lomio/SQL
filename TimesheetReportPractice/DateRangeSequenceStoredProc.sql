CREATE OR ALTER PROCEDURE spGetTimeSheetDateRange
    @StartDate AS DATE,
	@EndDate AS DATE
AS
BEGIN

;WITH DateSequence AS (
    SELECT @StartDate AS Date
    UNION ALL
    SELECT DATEADD(DAY, 1, Date)
    FROM DateSequence
    WHERE Date < @EndDate
)

SELECT ds.[Date] AS [DateRange]
FROM DateSequence ds
GROUP BY ds.[Date]
OPTION (MAXRECURSION 0);

END;


EXEC spGetTimeSheetDateRange @StartDate = '2023-10-01', @EndDate = '2023-10-15'
