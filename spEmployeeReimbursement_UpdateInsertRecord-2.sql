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

	 MERGE  EmployeeReimbursements t 
      USING (
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
	 @dateModified)
	  ) 
	  AS EmployeeReimbursementSource(
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
	     ON (t.Id = EmployeeReimbursementSource.Id)
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

--- Execution
EXEC kis_spEmployeeReimbursement_UpdateInsertRecord
@employeeReimbursementId = 15000006,
 @reimbursementTypeId = 1,
	 @employeeId = 1,
	 @reviewerEmployeeId = 1,
	 @reimbursementStatusId = 1,
     @additionalInfo = 'None',
	 @totalAmount = 10.00,
	 @transactionDate =  '2023-01-26 13:23:54.677',
	 @approvedDate = '2023-01-26 13:23:54.677',
	 @requestedDate =  '2023-01-26 13:23:54.677',
	 @reviewerRemarks = 'GOOD',
	 @modifiedBy  = 'System',
	 @createdBy = 'System',
	 @isActive = 1,
	 @dateCreated = '2023-01-26 13:23:54.677',
	 @dateModified = '2023-01-26 13:23:54.677'