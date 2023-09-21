SELECT
TOP 10
    LastName,
    CASE 
        WHEN Grade < 75 THEN 'FAIL'
		WHEN Grade >= 75 AND Grade <= 90  THEN 'GOOD'
		WHEN Grade > 90 THEN 'GREAT JOB'
	 ELSE 'N/A'
    END AS	grade_status
FROM Persons


