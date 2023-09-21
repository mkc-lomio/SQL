
-- SQL Server UNION is one of the set operations that allow you to combine results of two SELECT statements
-- into a single result set which includes all the rows that belong to the SELECT statements in the union.

SELECT
    first_name,
    last_name
FROM
    sales.staffs
UNION
SELECT
    first_name,
    last_name
FROM
    sales.customers;