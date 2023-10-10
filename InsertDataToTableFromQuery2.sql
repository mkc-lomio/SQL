DROP PROCEDURE IF EXISTS [dbo].[kis_spStateHoliday_TransferTo_NewState]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO        
CREATE PROCEDURE [dbo].[kis_spStateHoliday_TransferTo_NewState] 
@oldStateId INT,
@newStateId INT
AS
BEGIN
	SET NOCOUNT ON;
	INSERT INTO Holiday (stateId, holidayName, holidayDay, holidayYear, cutOff, adjustedDuration, holidayDate) 
SELECT
    @newStateId,
    ho.holidayName,
    ho.holidayDay,
    ho.holidayYear,
	ho.cutOff,
	ho.adjustedDuration,
	ho.holidayDate
FROM
     Holiday ho 
WHERE
     ho.stateId = @oldStateId
END
GO