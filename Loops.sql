DECLARE @i INT = 10;
WHILE @i <= 30 BEGIN PRINT @i 
SET 
  @i = @i + 10 IF @i = 20 PRINT @i PRINT '----';
CONTINUE;
-- skip the current iteration of the loop immediately and continue the next one.
END 

DECLARE @x INT = 10;
WHILE @x <= 30 BEGIN PRINT @x 
SET 
  @x = @x + 10 IF @x = 20 PRINT @x PRINT 'END' BREAK;
-- exit the loop immediately and skip the rest of the code after it within a loop.
END