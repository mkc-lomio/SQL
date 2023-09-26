CREATE PROCEDURE spInsertReimbursementStatus
AS
BEGIN
   INSERT INTO ReimbursementStatus([Description],Code,ModifiedBy,CreatedBy,IsActive,DateCreated,DateModified)
   VALUES
   ('Approved','APD', 'system','system',1, GETDATE(),NULL),
   ('Submitted','SBD', 'system','system',1, GETDATE(),NULL),
   ('Rejected','RJD', 'system','system',1, GETDATE(),NULL),
   ('Cancelled','CCD', 'system','system',1, GETDATE(),NULL)
END;