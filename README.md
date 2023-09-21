# SQL

# How to optimize sql queries 
1. Define business requirements first 
2. SELECT fields instead of using SELECT *
3. Avoid SELECT DISTINCT\
  3.1 When using table joins that involve tables with one-to-many relationships, use EXISTS rather than DISTINCT.
BAD `` SELECT DISTINCT c.country_id, c.country_name FROM countries c, customers e WHERE e.country_id = c.country_id; ``
GOOD `` SELECT c.country_id, c.country_name FROM countries c WHERE EXISTS (SELECT * FROM customers e WHERE e.country_id = c.country_id); ``
4. Create joins with INNER JOIN (not WHERE)
5. Use WHERE instead of HAVING to define filters
6. Use wildcards at the end of a phrase only
  -- Consider this query to pull cities beginning with ‘Char’
   
   `` SELECT City FROM Customers WHERE City LIKE ‘%Char%’ ``

   This query will pull the expected results of Charleston, Charlotte, and Charlton. However, it will also pull unexpected results, such as Cape Charles, Crab Orchard, and Richardson.

   A more efficient query would be

   `` SELECT City FROM Customers WHERE City LIKE ‘Char%’ ``
   
   This query will pull only the expected results of Charleston, Charlotte, and Charlton.
7. Use LIMIT to sample query results
   - Before running a query for the first time, ensure the results will be desirable and meaningful by using a LIMIT statement.
8. Run your query during off-peak hours - make sure no conflict when executing a large query. 
9. Avoid using multiple OR in the FILTER predicate  
EXAMPLE 
BAD `` SELECT * FROM USER WHERE Name = @P OR login = @P; ``
GOOD `` SELECT * FROM USER WHERE Name = @P UNION SELECT * FROM USER WHERE login = @P; ``
GOOD `` SELECT * FROM sales WHERE product_id IN (4, 7); ``
10. Use Union ALL instead of Union wherever possible - Union ALL executes faster than Union because, in UNION, duplicates are removed whether they exist or not. Union ALL displays the data with duplicates.
11. Avoid using aggregate functions on the right side of the operator
BAD ``` SELECT * FROM sales WHERE EXTRACT (YEAR FROM TO_DATE (time_id, ‘DD-MON-YYYY’)) = 2021 AND EXTRACT (MONTH FROM TO_DATE (time_id, ‘DD-MON-YYYY’)) = 2002;   ``` 
GOOD  `` SELECT * FROM sales WHERE TRUNC (time_id) BETWEEN TRUNC(TO_DATE(‘12/01/2001’, ’mm/dd/yyyy’)) AND TRUNC (TO_DATE (‘12/30/2001’,’mm/dd/yyyy’)); ``

Reference:
https://medium.com/geekculture/9-ways-to-optimize-sql-queries-f62680d6f59a


# Indexes

### Why Indexes Are Used?
Indexes help faster data retrieval from the databases. Basically, it speeds up the select queries and where clause. But at the same time, it degraded the performance of INSERT and UPDATE queries.

### When Should We Avoid Using Indexes?
1. Indexes should not be used on tables containing few records.
2. Tables that have frequent, large batch updates or insert operations.
3. Indexes should not be used on columns that contain a high number of NULL values.
4. Indexes should not be used on the columns that are frequently manipulated.
 NOTE: Remember creating too many indexes on a table can slow down your index-related operations to multi-fold.

### When to use Indexes
1. Report Queries


Reference: https://levelup.gitconnected.com/indexes-when-to-use-and-when-to-avoid-in-sql-445ffae6b4a3


### OUTPUT Clause
Output usage with DML statements.
 - INSERT
 - DELETE
 - UPDATE
 - MERGE

 It mostly used in the store procedures,
 Scenario 1: If you want to develop an audit feature where you won't know what the previous data was and with what it has been changed with.
 Scenario 2: If you are writing the data migration script where you will be having a complex logic want to retain the updated/inserted record to perform another set of operations with that data in the same-store procedure.