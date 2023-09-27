CREATE
	OR
ALTER PROCEDURE kis_spEmployeeReimbursement_UpdateInsertRecord (
	 @employeeReimbursementId AS int,
	 @reimbursementTypeId INT,
	 @employeeId INT,
	 @reviewerEmployeeId INT,
	 @reimbursementStatusId INT,
     @additionalInfo NVARCHAR(MAX),
	 @totalAmount DECIMAL,
	 @transactionDate DATETIME,
	 @approvedDate DATETIME,
	 @requestedDate DATETIME,
	 @reviewerRemarks NVARCHAR(MAX),
	 @modifiedBy VARCHAR(100),
	 @createdBy VARCHAR(100),
	 @isActive BIT,
	 @dateCreated DATETIME,
	 @dateModified DATETIME
	)
AS
BEGIN

DECLARE @EmployeeReimbursement TABLE (
    Id INT,
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


INSERT INTO @EmployeeReimbursement (
        Id,
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
        DateModified)
         VALUES (
		 @employeeReimbursementId,
        @reimbursementTypeId, 
        @employeeId, 
     @reviewerEmployeeId,
	 @reimbursementStatusId,
     @additionalInfo,
	 @totalAmount,
	 @transactionDate,
	 @approvedDate,
	 @requestedDate,
	 @reviewerRemarks,
	 @modifiedBy,
	 @createdBy,
	 @isActive,
	 @dateCreated,
	 @dateModified
         );


	 MERGE  EmployeeReimbursements t 
      USING  @EmployeeReimbursement s  ON (t.Id = s.Id)
WHEN MATCHED
    THEN UPDATE SET 
        t.ReimbursementTypeId = @reimbursementTypeId,
		t.EmployeeId = @employeeId,
        t.ReviewerEmployeeId = @reviewerEmployeeId,
        t.ReimbursementStatusId = @reimbursementStatusId,
        t.AdditionalInfo = @additionalInfo,
        t.TotalAmount = @totalAmount,
        t.TransactionDate = @transactionDate,
        t.ApprovedDate = @approvedDate,
        t.RequestedDate = @requestedDate,
		t.ReviewerRemarks = @reviewerRemarks,
		t.ModifiedBy = @modifiedBy,
		t.CreatedBy = @createdBy,
		t.IsActive = @isActive,
		t.DateCreated = @dateCreated,
		t.DateModified = @dateModified
WHEN NOT MATCHED BY TARGET 
    THEN INSERT (ReimbursementTypeId, 
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
        DateModified)
         VALUES (
        @reimbursementTypeId, 
        @employeeId, 
     @reviewerEmployeeId,
	 @reimbursementStatusId,
     @additionalInfo,
	 @totalAmount,
	 @transactionDate,
	 @approvedDate,
	 @requestedDate,
	 @reviewerRemarks,
	 @modifiedBy,
	 @createdBy,
	 @isActive,
	 @dateCreated,
	 @dateModified
         );

END;