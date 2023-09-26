CREATE
	OR

ALTER PROCEDURE spPaginatedEmployeeReimbursement (
	@pageNumber AS INT
	,@pageRows AS INT
	,@search AS VARCHAR(100) = ''
	,@sortingColumn AS VARCHAR(100) = 'Type'
	,@sortingType AS VARCHAR(100) = 'ASC'
	)
AS
BEGIN
	DECLARE @EmployeeReimbursementVarTable TABLE (
		EmployeeReimbursementId INT
		,ReimbursementTypeId INT
		,EmployeeId INT
		,ReviewerEmployeeId INT
		,ReimbursementStatusId INT
		,[Type] VARCHAR(200)
		,TotalAmount DECIMAL
		,[Status] VARCHAR(100)
		,Reviewer VARCHAR(200)
		,TransactionDate DATETIME
		,RequestedDate DATETIME
		);

	IF @search != ''
	BEGIN
		INSERT INTO @EmployeeReimbursementVarTable (
			EmployeeReimbursementId
			,ReimbursementTypeId
			,EmployeeId
			,ReviewerEmployeeId
			,ReimbursementStatusId
			,[Type]
			,TotalAmount
			,[Status]
			,Reviewer
			,TransactionDate
			,RequestedDate
			)
		SELECT *
		FROM (
			SELECT er.Id AS EmployeeReimbursementId
				,er.ReimbursementTypeId
				,er.EmployeeId
				,er.ReviewerEmployeeId
				,er.ReimbursementStatusId
				,rt.[Name] AS [Type]
				,er.TotalAmount
				,rs.[Description] AS [Status]
				,'' AS Reviewer
				,-- need employee table
				er.TransactionDate
				,er.RequestedDate
			FROM EmployeeReimbursements er
			INNER JOIN ReimbursementStatus rs ON rs.Id = er.ReimbursementStatusId
			INNER JOIN ReimbursementTypes rt ON rt.Id = er.ReimbursementTypeId
			WHERE rs.[Description] LIKE @search + '%' -- NOTE: For temporary. not yet final.
			
			UNION
			
			SELECT er.Id AS EmployeeReimbursementId
				,er.ReimbursementTypeId
				,er.EmployeeId
				,er.ReviewerEmployeeId
				,er.ReimbursementStatusId
				,rt.[Name] AS [Type]
				,er.TotalAmount
				,rs.[Description] AS [Status]
				,'' AS Reviewer
				,-- need employee table
				er.TransactionDate
				,er.RequestedDate
			FROM EmployeeReimbursements er
			INNER JOIN ReimbursementStatus rs ON rs.Id = er.ReimbursementStatusId
			INNER JOIN ReimbursementTypes rt ON rt.Id = er.ReimbursementTypeId
			WHERE rs.[Description] LIKE @search + '%' -- NOTE: For temporary. not yet final.
			) A
	END
	ELSE
	BEGIN
		INSERT INTO @EmployeeReimbursementVarTable (
			EmployeeReimbursementId
			,ReimbursementTypeId
			,EmployeeId
			,ReviewerEmployeeId
			,ReimbursementStatusId
			,[Type]
			,TotalAmount
			,[Status]
			,Reviewer
			,TransactionDate
			,RequestedDate
			)
		SELECT er.Id AS EmployeeReimbursementId
			,er.ReimbursementTypeId
			,er.EmployeeId
			,er.ReviewerEmployeeId
			,er.ReimbursementStatusId
			,rt.[Name] AS [Type]
			,er.TotalAmount
			,rs.[Description] AS [Status]
			,'' AS Reviewer
			,-- need employee table
			er.TransactionDate
			,er.RequestedDate
		FROM EmployeeReimbursements er
		INNER JOIN ReimbursementStatus rs ON rs.Id = er.ReimbursementStatusId
		INNER JOIN ReimbursementTypes rt ON rt.Id = er.ReimbursementTypeId
	END

	SELECT *
	FROM @EmployeeReimbursementVarTable
	ORDER BY CASE 
			WHEN @sortingColumn = 'Type'
				AND @sortingType = 'ASC'
				THEN [Type]
			END
		,CASE 
			WHEN @sortingColumn = 'Type'
				AND @sortingType = 'DESC'
				THEN [Type]
			END
		,CASE 
			WHEN @sortingColumn = 'TotalAmount'
				AND @sortingType = 'ASC'
				THEN TotalAmount
			END
		,CASE 
			WHEN @sortingColumn = 'TotalAmount'
				AND @sortingType = 'DESC'
				THEN TotalAmount
			END
		,CASE 
			WHEN @sortingColumn = 'Status'
				AND @sortingType = 'ASC'
				THEN [Status]
			END
		,CASE 
			WHEN @sortingColumn = 'Status'
				AND @sortingType = 'DESC'
				THEN [Status]
			END
		,CASE 
			WHEN @sortingColumn = 'Reviewer'
				AND @sortingType = 'ASC'
				THEN Reviewer
			END
		,CASE 
			WHEN @sortingColumn = 'Reviewer'
				AND @sortingType = 'DESC'
				THEN Reviewer
			END
		,CASE 
			WHEN @sortingColumn = 'TransactionDate'
				AND @sortingType = 'ASC'
				THEN TransactionDate
			END
		,CASE 
			WHEN @sortingColumn = 'TransactionDate'
				AND @sortingType = 'DESC'
				THEN TransactionDate
			END
		,CASE 
			WHEN @sortingColumn = 'RequestedDate'
				AND @sortingType = 'ASC'
				THEN RequestedDate
			END
		,CASE 
			WHEN @sortingColumn = 'RequestedDate'
				AND @sortingType = 'DESC'
				THEN RequestedDate
			END OFFSET(@pageNumber - 1) * @pageRows ROWS

	FETCH NEXT @pageRows ROWS ONLY;

	SELECT COUNT(*)
	FROM @EmployeeReimbursementVarTable;
END;