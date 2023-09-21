

/* 

The COALESCE expression is a syntactic sugar of the CASE expression.

The following expressions return the same result:

COALESCE(e1,e2,e3)

CASE
    WHEN e1 IS NOT NULL THEN e1
    WHEN e2 IS NOT NULL THEN e2
    ELSE e3
END

-- you can use the COALESCE expression to substitute NULL by the string N/A (not available) as shown in the following query

*/

UPDATE Persons SET FirstName = NULL WHERE ID = 'BB4CA349-CC7B-40D6-980F-000003630E20'

SELECT TOP 1
    LastName, 
    COALESCE(FirstName,'N/A') FirstName
FROM 
    Persons

