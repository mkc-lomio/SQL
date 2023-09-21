Declare @SalesOrderCode nvarchar(100) = 'XXX-XXXX' DECLARE @Var_Table TABLE (
  CustomerCode VARCHAR(100), 
  );
INSERT INTO @Var_Table (CustomerCode) 
SELECT 
  * 
FROM 
  (
    SELECT 
      c.CustomerCode 
    FROM 
      Customer c 
      INNER JOIN Sales s ON s.BillToCode = c.CustomerCode 
    WHERE 
      s.SalesOrderCode = @SalesOrderCode
  ) AS t IF (
    SELECT 
      COUNT(1) 
    FROM 
      @Var_Table
  ) = 1 BEGIN 
SELECT 
  'PM' END ELSE BEGIN 
SELECT 
  'AV' END
