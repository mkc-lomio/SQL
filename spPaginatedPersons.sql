CREATE
	OR
ALTER PROCEDURE spPaginatedPersons (
	@pageNumber AS INT
	,@pageRows AS INT
	,@search AS VARCHAR(100) = ''
	,@sortingColumn AS VARCHAR(100) = 'Grade'
	,@sortingType AS VARCHAR(100) = 'ASC'
	)
AS
BEGIN
	DECLARE @PersonVarTable TABLE (
		Id VARCHAR(100)
		,LastName NVARCHAR(MAX)
		,FirstName NVARCHAR(MAX)
		,ImageURI VARCHAR(MAX)
		,Gender CHAR(1)
		,IsActive BIT NULL
		,Grade DECIMAL NULL
		,CashOnHand MONEY
		,Age INT NOT NULL
		,CreatedDate DATETIME
		);

	IF @search != ''
	BEGIN
		INSERT INTO @PersonVarTable (
			Id
			,LastName
			,FirstName
			,ImageURI
			,Gender
			,IsActive
			,Grade
			,CashOnHand
			,Age
			,CreatedDate
			)
		SELECT *
		FROM (
			SELECT *
			FROM Persons
			WHERE LastName LIKE @search + '%'
			
			UNION
			
			SELECT *
			FROM Persons
			WHERE FirstName LIKE @search + '%'
			) A
	END
	ELSE
	BEGIN
    INSERT INTO @PersonVarTable (
			Id
			,LastName
			,FirstName
			,ImageURI
			,Gender
			,IsActive
			,Grade
			,CashOnHand
			,Age
			,CreatedDate
			)
		SELECT *
		FROM Persons
	END

	SELECT *
	FROM @PersonVarTable
	ORDER BY CASE 
			WHEN @sortingColumn = 'Grade'
				AND @sortingType = 'ASC'
				THEN Grade
			END
		,CASE 
			WHEN @sortingColumn = 'Grade'
				AND @sortingType = 'DESC'
				THEN Grade
			END DESC OFFSET(@pageNumber - 1) * @pageRows ROWS

	FETCH NEXT @pageRows ROWS ONLY;

	SELECT COUNT(*)
	FROM @PersonVarTable;
END;

-- SELECT all data for 5million result 19 secs
EXEC spPaginatedPersons @pageNumber = 1, @pageRows = 10, @search = '', @sortingColumn = 'Grade', @sortingType = 'ASC'

-- Search certain data in 5million records 4secs
EXEC spPaginatedPersons @pageNumber = 1, @pageRows = 10, @search = 'FirstName4625089', @sortingColumn = 'Grade', @sortingType = 'ASC'
