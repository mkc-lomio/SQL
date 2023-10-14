CREATE TABLE SampleData (
    DateValue DATE,
    Value INT
);

-- Insert some sample data
INSERT INTO SampleData (DateValue, Value)
VALUES
    ('2023-10-01', 10),
    ('2023-10-05', 15),
    ('2023-10-10', 20),
    ('2023-10-15', 25);

-- Generate the column list for the pivot dynamically
DECLARE @columns NVARCHAR(MAX);
DECLARE @sql NVARCHAR(MAX);

SELECT @columns = STRING_AGG(QUOTENAME(CONVERT(VARCHAR(10), DateValue, 120)), ', ')
FROM (
    SELECT DISTINCT DateValue
    FROM SampleData
) AS DateRange;

-- Create the dynamic SQL for the pivot
SET @sql = N'
SELECT *
FROM (
    SELECT DateValue, Value
    FROM SampleData
) AS SourceData
PIVOT (
    MAX(Value)
    FOR DateValue IN (' + @columns + ')
) AS PivotTable';

-- Execute the dynamic SQL
EXEC sp_executesql @sql;