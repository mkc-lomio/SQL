SELECt * FROM Markers

BEGIN TRANSACTION 
UPDATE Markers Set Content = 'Hello world!!!!'

COMMIT TRANSACTION
ROLLBACK TRANSACTION