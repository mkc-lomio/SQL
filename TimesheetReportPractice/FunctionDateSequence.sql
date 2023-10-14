CREATE OR ALTER FUNCTION GetDateSequence
(
    @StartDate DATE,
    @EndDate DATE
)
RETURNS TABLE
AS
RETURN (
    WITH DateSequence AS (
        SELECT @StartDate AS [Date]
        UNION ALL
        SELECT DATEADD(DAY, 1, [Date])
        FROM DateSequence
        WHERE [Date] < @EndDate
           AND DATEDIFF(DAY, @StartDate, [Date]) <= 15 -- Choose a suitable maximum number of recursions
    )

    SELECT FORMAT(ds.[Date], 'MM/dd/yyyy') AS [Date]
    FROM DateSequence ds
);