CREATE TABLE ReimbursementTypes (
    Id INT IDENTITY(1,1) PRIMARY KEY,
	[Name] VARCHAR(100),
    [Description] VARCHAR(MAX),
	Code VARCHAR(100),
	ModifiedBy VARCHAR(100),
	CreatedBy VARCHAR(100),
	IsActive BIT,
	DateCreated DATETIME,
	DateModified DATETIME
);

