DECLARE @PageNumber AS INT
DECLARE @RowsOfPage AS INT
DECLARE @SortingCol AS VARCHAR(100) ='ToolTip'
DECLARE @SortType AS VARCHAR(100) = 'ASC'

SET @PageNumber=1
SET @RowsOfPage=4

SELECT
    *
FROM
    Markers
ORDER BY
CASE WHEN @SortingCol = 'ToolTip' AND @SortType ='ASC' THEN Tooltip END,
CASE WHEN @SortingCol = 'ToolTip' AND @SortType ='DESC' THEN Tooltip END DESC
OFFSET (@PageNumber-1)*@RowsOfPage ROWS 
FETCH NEXT @RowsOfPage ROWS ONLY;