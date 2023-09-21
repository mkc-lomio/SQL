DECLARE  @PageNumber AS INTEGER, @RowsOfPage AS INTEGER
SELECT @PageNumber=1,
	   @RowsOfPage=10;
--------------------------------------
SELECT * FROM 
(
SELECT *
FROM Notifications n
WHERE n.Title LIKE '%{2}%'
ORDER BY n.Id ASC
OFFSET (@PageNumber-1)*@RowsOfPage ROWS 
FETCH NEXT @RowsOfPage ROWS ONLY
) A;

