DECLARE @PersonInsertedData TABLE(Id UNIQUEIDENTIFIER,
    LastName NVARCHAR,
    FirstName NVARCHAR,
	Gender CHAR,
	IsActive BIT,
	Age INT,
	CreatedDate DATETIME)

	INSERT INTO Persons (LastName,FirstName,ImageURI,Gender,IsActive,Grade, CashOnHand,Age,CreatedDate)
	OUTPUT inserted.Id, inserted.LastName, inserted.FirstName, inserted.Gender, inserted.IsActive,
	inserted.Age,inserted.CreatedDate
    VALUES ('Lomio', 'Marc Kenneth', 'N/A', 'M',1,90,1000000,25, GETDATE())


SELECT * FROM @PersonInsertedData
SELECT TOP 1 * FROM Persons Where LastName LIKE 'Lomio%'