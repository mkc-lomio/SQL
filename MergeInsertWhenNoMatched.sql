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
 		MERGE [dbo].[Holiday] AS h  
			USING (SELECT  
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
     ho.stateId = @oldStateId) 
			as src (stateId, holidayName, holidayDay, holidayYear, cutOff, adjustedDuration, holidayDate)  
			ON (h.stateId = src.stateId and h.holidayDate = src.holidayDate)  			
			WHEN NOT MATCHED THEN  
				INSERT (stateId, holidayName, holidayDay, holidayYear, cutOff, adjustedDuration, holidayDate)  
				VALUES (src.stateId, src.holidayName,src.holidayDay,src.holidayYear,
				src.cutOff,src.adjustedDuration,src.holidayDate); 
END  
GO