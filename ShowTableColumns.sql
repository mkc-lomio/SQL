-- Show and Search table columns

SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = N'feeAgreement'

SELECT TABLE_NAME, COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE COLUMN_NAME LIKE '%state%';



select * from information_schema.columns where table_name = 'EmployeeWorkSchedule'

select * from information_schema.columns where COLUMN_NAME LIKE  '%Status%'

