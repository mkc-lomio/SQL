
CREATE PROCEDURE spFindPersonGradeLessThanOrEqual (
    @grade INT,
	@person_count INT OUTPUT
) AS
BEGIN
    SELECT 
       *
    FROM
        dbo.Persons
    WHERE
        Grade <= @grade;

    SELECT @person_count = @@ROWCOUNT;
END;

--- Execute SP
DECLARE @count INT;

EXEC spFindPersonGradeLessThanOrEqual
    @grade = 75,
    @person_count = @count OUTPUT;

SELECT FORMAT(@count, 'N') AS 'Number of persons found';



