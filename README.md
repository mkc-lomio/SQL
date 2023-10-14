

# SQL Cheatsheet

![image](https://github.com/mkc-lomio/SQL/assets/78136159/02f26200-2a74-4096-8ca2-4fe137915c9e)

# Types of Databases

![image](https://github.com/mkc-lomio/SQL/assets/78136159/f90f0783-5abf-4e3a-b92e-ce784e63e514)

![image](https://github.com/mkc-lomio/SQL/assets/78136159/767a6067-18b7-4168-bd99-7751283260fa)

![image](https://github.com/mkc-lomio/SQL/assets/78136159/1070d1b2-0b40-47e6-b714-509b89512bc2)

### How to choose the right database?

![image](https://github.com/mkc-lomio/SQL/assets/78136159/66535502-c6d3-456f-8eed-7412ce74ab71)

Reference: https://www.linkedin.com/feed/update/urn:li:activity:7084871539216535552/?updateEntityUrn=urn%3Ali%3Afs_updateV2%3A%28urn%3Ali%3Aactivity%3A7084871539216535552%2CFEED_DETAIL%2CEMPTY%2CDEFAULT%2Cfalse%29

# How to optimize sql queries 
1. Define business requirements first
   
2. SELECT fields instead of using SELECT *

3. Avoid SELECT DISTINCT
   
  3.1 When using table joins that involve tables with one-to-many relationships, use EXISTS rather than DISTINCT.
  
BAD `` SELECT DISTINCT c.country_id, c.country_name FROM countries c, customers e WHERE e.country_id = c.country_id; ``

GOOD `` SELECT c.country_id, c.country_name FROM countries c WHERE EXISTS (SELECT * FROM customers e WHERE e.country_id = c.country_id); ``

5. Create joins with INNER JOIN (not WHERE)
   
6. Use WHERE instead of HAVING to define filters
   
7. Use wildcards at the end of a phrase only
  -- Consider this query to pull cities beginning with ‘Char’
   
   `` SELECT City FROM Customers WHERE City LIKE ‘%Char%’ ``

   This query will pull the expected results of Charleston, Charlotte, and Charlton. However, it will also pull unexpected results, such as Cape Charles, Crab Orchard, and Richardson.

   A more efficient query would be

   `` SELECT City FROM Customers WHERE City LIKE ‘Char%’ ``
   
   This query will pull only the expected results of Charleston, Charlotte, and Charlton.
   
8. Use LIMIT/TOP to sample query results
   
   - Before running a query for the first time, ensure the results will be desirable and meaningful by using a LIMIT/TOP statement.
     
9. Run your query during off-peak hours - make sure no conflict when executing a large query.
    
10. Avoid using multiple OR in the FILTER predicate  
EXAMPLE

BAD `` SELECT * FROM USER WHERE Name = @P OR login = @P; ``

GOOD `` SELECT * FROM USER WHERE Name = @P UNION SELECT * FROM USER WHERE login = @P; ``

GOOD `` SELECT * FROM sales WHERE product_id IN (4, 7); ``

11. Use Union ALL instead of Union wherever possible - Union ALL executes faster than Union because, in UNION, duplicates are removed whether they exist or not. Union ALL displays the data with duplicates.


12. Avoid using aggregate functions on the right side of the operator
 
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


### SubQuery

You can use a subquery in many places:

In place of an expression
 
 - With IN or NOT IN
 - With ANY or ALL
 - With EXISTS or NOT EXISTS
 - In UPDATE, DELETE, or INSERT statement
 - In the FROM clause


 A correlated subquery is a subquery that uses the values of the outer query. In other words, the correlated subquery depends on the outer query for its values.

 Moreover, a correlated subquery is executed repeatedly, once for each row evaluated by the outer query. The correlated subquery is also known as a repeating subquery.


 ### JOINS

 1. CROSS JOIN - The CROSS JOIN gets a row from the first table (T1) and then creates a new row for every row in the second table (T2).
    
 ![image](https://github.com/mkc-lomio/SQL/assets/78136159/1b31fd79-c13a-4ed0-992f-c10e525f7005)

 2. SELF-JOIN - allows you to join a table to itself. It helps query hierarchical data or compare rows within the same table.

 ![image](https://github.com/mkc-lomio/SQL/assets/78136159/6bcd687f-5e7f-4213-96e9-995b0a926be0)

 3. FULL-JOIN - returns a result set that contains all rows from both left and right tables, with the matching rows from both sides where available. In case there is no match, the missing side will have NULL values.

 ![image](https://github.com/mkc-lomio/SQL/assets/78136159/9209581c-fdc3-4971-887d-4b6396483919)

 4. RIGHT-JOIN - The right join or right outer join selects data starting from the right table. It is a reversed version of the left join.

 ![image](https://github.com/mkc-lomio/SQL/assets/78136159/5c0a02bb-a685-4347-b92f-19c7a22da86a)

 5. LEFT-JOIN - Left Join selects data starting from the left table and matching rows in the right table.

   If a row in the left table does not have a matching row in the right table, the columns of the right table will have nulls.

   ![image](https://github.com/mkc-lomio/SQL/assets/78136159/104daa9e-07c4-47da-9801-771e20764c13)

6. INNER JOIN - Inner Join produces a data set that includes rows from the left table, and matching rows from the right table.

  ![image](https://github.com/mkc-lomio/SQL/assets/78136159/6c78d6c8-2589-4e1b-b5c2-5c275c9456ae)

 
### UNION 

![image](https://github.com/mkc-lomio/SQL/assets/78136159/fa2e7188-a1e7-4bfb-9b83-b9e748d5671e)

### Intersect 

![image](https://github.com/mkc-lomio/SQL/assets/78136159/879781d8-699c-4e9e-bcda-1f19712dc1fc)


### Views

#### When to use Views and Stored Procedure?

 Views:

you should use views when you want to simplify data access, enforce security policies, or create reusable query structures.

 - Query Reusability: Views can be used to encapsulate commonly used SQL queries.
 - Performance: In some cases, views can improve query performance. They allow you to precompute and store complex queries, reducing the need for repeatedly executing the same query logic.
 - Data Transformation: Views can be used to transform data into a more suitable format for reporting or analysis. For example, you can create a view that calculates aggregates or pivots data.

 Stored Procedures:

 Use stored procedures when you need to encapsulate business logic, manage transactions, optimize performance, or enforce security at the operation level. 

 - Business Logic: Stored procedures are used to encapsulate business logic or application-specific operations within the database.
 - Code Reusability: Stored procedures can be called from multiple parts of an application, promoting code reusability and reducing redundancy.
 - Transaction Management: Stored procedures can be used to group multiple SQL statements into a single transaction.
 - Performance Optimization: Stored procedures can be optimized by the database engine, which can result in better performance compared to executing equivalent SQL statements in a client application.

NOTE:
- Nested Declare variable in stored procedure is not advisable

References:
Date Conversion: https://stackoverflow.com/questions/74385/how-to-convert-datetime-to-varchar