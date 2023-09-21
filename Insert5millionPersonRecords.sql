-- Set the number of records to insert
DECLARE @RowCount INT = 5000000;
DECLARE @Counter INT = 1;

-- Loop to insert records
WHILE @Counter <= @RowCount
BEGIN
    INSERT INTO Persons (
        LastName,
        FirstName,
        ImageURI,
        Gender,
        IsActive,
        Grade,
        CashOnHand,
        Age,
        CreatedDate
    )
    VALUES (
        'LastName' + CAST(@Counter AS NVARCHAR(MAX)),
        'FirstName' + CAST(@Counter AS NVARCHAR(MAX)),
        'ImageURI' + CAST(@Counter AS NVARCHAR(MAX)),
        CASE WHEN @Counter % 2 = 0 THEN 'M' ELSE 'F' END,
        CASE WHEN @Counter % 3 = 0 THEN 1 ELSE 0 END,
        CAST(RAND() * 100 AS DECIMAL(10, 2)),
        CAST(RAND() * 10000 AS MONEY),
        CAST(RAND() * 100 AS INT),
        GETDATE()
    );

    SET @Counter = @Counter + 1;
END;

SELECT COUNT(*) AS TotalPersons FROM dbo.Persons
-- 3mins every 1million records
-- Total Execution 15mins