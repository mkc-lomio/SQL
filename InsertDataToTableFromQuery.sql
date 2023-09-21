-- It allows you to specify the number of rows returned by the query to be inserted into the target table. 

/* 

INSERT  [ TOP ( expression ) [ PERCENT ] ] 
INTO target_table (column_list)
query 

*/

INSERT INTO sales.addresses (street, city, state, zip_code) 
SELECT
    street,
    city,
    state,
    zip_code
FROM
    sales.customers
ORDER BY
    first_name,
    last_name; 