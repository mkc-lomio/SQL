CREATE TABLE ReimbursementAttachments (
    Id INT IDENTITY(1,1) PRIMARY KEY,
	EmployeeReimbursementId INT ,
    [FileName] VARCHAR(200),
	ModifiedBy VARCHAR(100),
	CreatedBy VARCHAR(100),
	IsActive BIT,
	DateCreated DATETIME,
	DateModified DATETIME
);

