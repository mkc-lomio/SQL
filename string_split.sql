DROP PROCEDURE IF EXISTS [dbo].[kis_spClientStateUpdate_To_NewState]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO        
CREATE PROCEDURE [dbo].[kis_spClientStateUpdate_To_NewState] 
@oldStateId INT,
@newStateId INT,
@clientId INT, 
@employeeClientId VARCHAR(MAX)
AS
BEGIN
  UPDATE EmployeeClient SET StateId = @newStateId WHERE ID IN (SELECT value AS splitted_value 
FROM STRING_SPLIT(@employeeClientId, ',')) 
END