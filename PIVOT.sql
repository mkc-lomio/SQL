SELECT * FROM (
    SELECT 
		p.Gender,
		p.Id
    FROM 
        Persons p
) t
PIVOT(
    COUNT(Id) 
    FOR Gender IN (
        [M],
		[F])
) AS pivot_table;


SELECT COUNT(*) FROM Persons p WHERE p.Gender = 'F'

SELECT COUNT(*) FROM Persons p WHERE p.Gender = 'M'

-- Step 1 Simple Query
-- Step 2 Assign to temp table
-- Step 3 Use Pivot
Reference https://sqlservertutorial.net/sql-server-basics/sql-server-pivot/