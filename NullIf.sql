/*

-- This expression that uses NULLIF 

SELECT 
    NULLIF(a,b)

-- is equivalent to the following expression that uses the CASE expression:

CASE 
    WHEN a=b THEN NULL 
    ELSE a 
END

*/

SELECT 
    NULLIF('Hello', 'Hello') result; -- result = null
    
SELECT 
    NULLIF('Hello', 'Hi') result; -- result = Hello    