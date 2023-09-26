CREATE TABLE EmployeeReimburesements (
    Id INT IDENTITY(1,1) PRIMARY KEY,
	ReimbursementTypeId INT,
	EmployeeId INT,
	ReviewerEmployeeId INT,
	ReimbursementStatusId INT,
    AdditionalInfo NVARCHAR(MAX),
	TotalAmount DECIMAL,
	TransactionDate DATETIME,
	ApprovedDate DATETIME,
	RequestedDate DATETIME,
	ReviewerRemarks NVARCHAR(MAX),
	ModifiedBy VARCHAR(100),
	CreatedBy VARCHAR(100),
	IsActive BIT,
	DateCreated DATETIME,
	DateModified DATETIME
);
