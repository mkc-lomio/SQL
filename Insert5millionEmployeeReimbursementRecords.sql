-- Set the number of records to insert
DECLARE @RecordsToInsert INT = 5000000
DECLARE @Counter INT = 1

-- Start inserting records
WHILE @Counter <= @RecordsToInsert
BEGIN
    INSERT INTO EmployeeReimbursements (
        ReimbursementTypeId, 
        EmployeeId, 
        ReviewerEmployeeId, 
        ReimbursementStatusId, 
        AdditionalInfo, 
        TotalAmount, 
        TransactionDate, 
        ApprovedDate, 
        RequestedDate, 
        ReviewerRemarks, 
        ModifiedBy, 
        CreatedBy, 
        IsActive, 
        DateCreated, 
        DateModified
    )
    VALUES (
        -- Generate random data or unique data for each column
        ABS(CHECKSUM(NEWID()) % 10) + 1, -- ReimbursementTypeId (Random value between 1 and 10)
        @Counter, -- EmployeeId (Incrementing value for uniqueness)
        NULL, -- ReviewerEmployeeId (Random value between 1 and 10)
        ABS(CHECKSUM(NEWID()) % 4) + 1, -- ReimbursementStatusId (Random value between 1 and 4)
        'Additional info for record ' + CONVERT(NVARCHAR(MAX), @Counter), -- AdditionalInfo
        RAND() * 1000, -- TotalAmount (Random decimal between 0 and 1000)
        DATEADD(day, -1 * FLOOR(RAND() * 365), GETDATE()), -- TransactionDate (Random date within the last year)
        NULL, -- ApprovedDate (Can be NULL)
        DATEADD(day, -1 * FLOOR(RAND() * 365), GETDATE()), -- RequestedDate (Random date within the last year)
        'Reviewer remarks for record ' + CONVERT(NVARCHAR(MAX), @Counter), -- ReviewerRemarks
        'ModifiedBy_' + CONVERT(VARCHAR(100), @Counter), -- ModifiedBy
        'CreatedBy_' + CONVERT(VARCHAR(100), @Counter), -- CreatedBy
        CAST(ABS(CHECKSUM(NEWID()) % 2) AS BIT), -- IsActive (Random 0 or 1)
        GETDATE(), -- DateCreated (Current timestamp)
        NULL -- DateModified (Can be NULL)
    )

    SET @Counter = @Counter + 1
END