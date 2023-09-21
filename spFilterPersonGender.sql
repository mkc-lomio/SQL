CREATE OR ALTER PROCEDURE spFilterPersonGender(
    @gender AS VARCHAR = 'F'  -- it mean optional parameter
)
AS
BEGIN
    SELECT
        *
    FROM 
        dbo.Persons
    WHERE
        Gender LIKE @gender 
END;


EXEC spFilterPersonGender
    @gender = 'M'