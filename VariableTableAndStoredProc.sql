DECLARE @ResultVariable TABLE (
		[Id] INT
		,[Description] VARCHAR(100)
		,[Code] VARCHAR(100)
		,ModifiedBy VARCHAR(100)
		,CreatedBy VARCHAR(100)
		,IsActive BIT
		,DateCreated DATE
		,DateModified DATE NULL
		);

-- Execute the stored procedure and assign the result to the variable
INSERT INTO @ResultVariable
EXEC kis_spReimbursementStatus_AllRecord

-- Use the @ResultVariable in subsequent SQL statements
SELECT * FROM @ResultVariable;