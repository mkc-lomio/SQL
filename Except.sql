--EXCEPT compares the result sets of two queries and returns the distinct rows from the first query that are not output by the second query. 
--In other words, the EXCEPT subtracts the result set of a query from another.

SELECT
    product_id
FROM
    production.products
EXCEPT
SELECT
    product_id
FROM
    sales.order_items;