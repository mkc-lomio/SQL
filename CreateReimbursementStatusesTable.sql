CREATE TABLE ReimbursementStatus (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    [Description] VARCHAR(200),
	Code VARCHAR(100),
	ModifiedBy VARCHAR(100),
	CreatedBy VARCHAR(100),
	IsActive BIT,
	DateCreated DATETIME,
	DateModified DATETIME
);

