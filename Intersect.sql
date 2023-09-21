-- The SQL Server INTERSECT combines result sets of two or more queries and returns distinct rows that are output by both queries.

SELECT
    city
FROM
    sales.customers
INTERSECT
SELECT
    city
FROM
    sales.stores
ORDER BY
    city;