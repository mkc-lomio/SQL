BEGIN TRANSACTION

DECLARE @CountryPrimaryId AS INT=1 -- Andorra
DECLARE @CustomStateTable TABLE
  (
     [stateid]       INT,
     [country]       VARCHAR(max),
     [stateoriginid] INT NULL,
     [countryid]     INT,
     [statename]     VARCHAR(max),
     [statecode]     VARCHAR(max)
  )

INSERT INTO @CustomStateTable
            ([stateid],
             [country],
             [stateoriginid],
             [countryid],
             [statename],
             [statecode])
SELECT *
FROM   (SELECT s.id AS StateId,
               c.countryname,
               s.stateoriginid,
               s.countryid,
               s.stateorcityname,
               s.stateorcitycode
        FROM   [state] s
               INNER JOIN country c
                       ON c.id = s.countryid
        WHERE  c.id = @CountryPrimaryId
               AND s.stateorcitycode LIKE '%-%') A

--SELECT * FROM @CustomStateTable
--SELECT * FROM (
--SELECT s.Id as StateId,c.CountryName, s.StateOriginId, s.CountryId, s.StateOrCityName, s.StateOrCityCode FROM [State] s
--INNER JOIN Country c ON c.Id = s.CountryId
--WHERE c.Id = 1 AND s.StateOrCityCode NOT LIKE '%-%'
--) StateOrigin 

DECLARE @StateId       INT,
        @Country       NVARCHAR(255),
        @StateOriginId INT,
        @CountryId     INT,
        @StateName     NVARCHAR(255),
        @StateCode     NVARCHAR(255)

DECLARE state_cursor CURSOR FOR
  SELECT stateid,
         country,
         stateoriginid,
         countryid,
         statename,
         statecode
  FROM   @CustomStateTable 

OPEN state_cursor

FETCH next FROM state_cursor INTO @StateId, @Country, @StateOriginId, @CountryId
, @StateName, @StateCode

-- Start the loop
WHILE @@FETCH_STATUS = 0
  BEGIN
      PRINT @StateName + ' - ' + @StateCode

	  -- UPDATE CLIENT
      
	  -- UPDATE EMPLOYEE CLIENT
      
	  -- DELETE CUSTOM STATE

      -- Fetch the next row
      FETCH next FROM state_cursor INTO @StateId, @Country, @StateOriginId,
      @CountryId, @StateName, @StateCode
  END

-- Clean up
CLOSE state_cursor

DEALLOCATE state_cursor



IF ( @@ERROR = 0 )
  COMMIT
ELSE
  ROLLBACK 

  -- Result
--   (13 rows affected)
-- undefined - AD - Savills
-- Encamp - AD - Ballistix
-- AD - Enable Tech - AD - Enable Tech
-- AD - Lonicera Pty Ltd - AD - Lonicera Pty Ltd
-- 03 - Savills - 03 - Savills
-- 03 - Ballistix - 03 - Ballistix
-- 06 - Edge Concepts - 06 - Edge Concepts
-- 04 - ABC-Test - 04 - ABC-Test
-- 08 - U-tron - 08 - U-tron
-- 07 - HART Sport - 07 - HART Sport
-- 03 - Enable Tech - 03 - Enable Tech
-- 04 - Aro Software - 04 - Aro Software
-- 05 - Viva Leisure People Pty Ltd - 05 - Viva Leisure People Pty Ltd
