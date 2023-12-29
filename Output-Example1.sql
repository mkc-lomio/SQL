 /****** Object:  StoredProcedure [dbo].[kis_spAddNewApprover] ******/
DROP PROCEDURE IF EXISTS [dbo].[kis_spAddNewApprover]
GO
/****** Object:  StoredProcedure [dbo].[kis_spAddNewApprover] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[kis_spAddNewApprover]
	@clientId INT,
	@userRoleId INT,
	@firstName VARCHAR(100),
	@lastName VARCHAR(100),
	@email VARCHAR(100),
	@password VARCHAR(100),
	@tmcode VARCHAR(100),
	@newId int output -- HERE
AS
BEGIN
	SET NOCOUNT ON
	INSERT INTO Employee(
	[ClientId],
	[UserRoleId],
	[FirstName],
	[LastName],
	[Email],
	[Password],
	[ReferenceCode],
	[WorkScheduleId],
	[DateCreated],
	[IsLocked],
	[Deactivated],
	[ActiveTM],
	[Modified],
	[RecordStatus],
	[TMCode]
	)VALUES(
	@clientId,
	@userRoleId,
	@firstName,
	@lastName,
	@email,
	@password,
	'',
	0,
	GETDATE(),
	0,
	0,
	1,
	GETDATE(),
	'Completed',
	@tmcode
	)

	SET @newId = SCOPE_IDENTITY() -- HERE
END
GO