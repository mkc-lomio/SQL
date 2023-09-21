SELECT
   cs.SalesOrderCode
INTO #SP_CheckForLegacyWalmartCustomer  
FROM
   Customer c
   INNER JOIN CustomerSales cs ON  cs.BillToCode = c.CustomerCode

IF (SELECT COUNT(1) FROM #SP_Emerut) = 1
 BEGIN
     EXEC SP_GetHTMLTemplate_C @TemplateName='TO_CHANGE',@TemplateContent=@htmlTemplate output            
 END
ELSE
BEGIN
     EXEC SP_GetHTMLTemplate_C @TemplateName='em_shipped-order.html',@TemplateContent=@htmlTemplate output            
END
