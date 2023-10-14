DECLARE @WorkedHours TABLE
  (
     [date]     VARCHAR(200),
     totalhours DECIMAL(10, 2)
  );

  DECLARE @Holiday TABLE
  (
     [date]     VARCHAR(200),
     totalhours DECIMAL(10, 2)
  );

   DECLARE @TotalPerDay TABLE
  (
     [date]     VARCHAR(200),
     totalhours DECIMAL(10, 2)
  );


INSERT INTO @WorkedHours
            ([date],
             totalhours)
EXEC Spgetemployeeworkhours
  @paramEmployeeId = 543,
  @paramDateStart = '2023-10-01',
  @paramDateEnd = '2023-10-15'



INSERT INTO @Holiday
            ([date],
             totalhours)
EXEC Spgetemployeeholiday
  @paramEmployeeId = 543,
  @paramDateStart = '2023-10-01',
  @paramDateEnd = '2023-10-15'

  INSERT INTO @TotalPerDay
            ([date],
             totalhours)
			SELECT [Date], SUM(TotalHours) FROM (
			 SELECT * from @WorkedHours
			 UNION ALL 
			 SELECT * from @Holiday
			) A GROUP BY [date]


SELECT *
FROM   ( SELECT 1   AS Id,
               'Worked Hours' AS [Description],
               *
        FROM   @WorkedHours
        UNION ALL
		SELECT 2         AS Id,
               'Holiday' AS [Description],
               *
        FROM   @Holiday
		UNION ALL
		SELECT 10   AS Id,
               'Total' AS [Description],
               *
        FROM  @TotalPerDay
		) AS SourceData
       PIVOT ( Max([totalhours])
             FOR [date] IN ([10/01/2023],
                            [10/02/2023],
                            [10/03/2023],
                            [10/04/2023],
                            [10/05/2023],
                            [10/06/2023],
                            [10/07/2023],
                            [10/08/2023],
                            [10/09/2023],
                            [10/10/2023],
                            [10/11/2023],
                            [10/12/2023],
                            [10/13/2023],
                            [10/14/2023],
                            [10/15/2023],
                            [Total]) ) AS pivottable
ORDER  BY id 