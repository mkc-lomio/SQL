CREATE CLUSTERED INDEX index_PersonGender ON SQLPlaygroundDb.dbo.Person (Gender);

USE SQLPlaygroundDb;  
GO  
-- Find an existing index named IX_Person_Gender and delete it if found.   
IF EXISTS (SELECT name FROM sys.indexes  
            WHERE name = N'IX_Person_Gender')   
    DROP INDEX IX_Person_Gender ON Person.Gender;   
GO  
-- Create a nonclustered index called IX_Person_Gender   
-- on the Person.Gender  table using the Gender column.   
CREATE NONCLUSTERED INDEX IX_ProductVendor_VendorID   
    ON IX_Person_Gender (Gender);   
GO  

CREATE INDEX IX_Person_Gender
ON Person (Gender);
GO

