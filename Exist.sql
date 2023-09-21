-- The EXISTS operator is a logical operator that allows you to check whether a subquery returns any row. 
-- The EXISTS operator returns TRUE if the subquery returns one or more rows.

-- In practice, you use the EXISTS when you need to check the existence of rows from related tables without returning data from them.

-- NOTE: Exist vs IN. both returns same result.


SELECT
    *
FROM
    sales.orders o
WHERE
    EXISTS (
        SELECT
            customer_id
        FROM
            sales.customers c
        WHERE
            o.customer_id = c.customer_id
        AND city = 'San Jose'
    )
ORDER BY
    o.customer_id,
    order_date;