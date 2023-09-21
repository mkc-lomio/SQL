 DECLARE @PageNumber AS INTEGER, @RowsOfPage AS INTEGER
SELECT @PageNumber=1,
	   @RowsOfPage=10;
DROP TABLE IF EXISTS #TempCorrectedRecords
DROP TABLE IF EXISTS #TempFinalizedRecords
DROP TABLE IF EXISTS #TempReleaseTable

------------------------------------------------------------------
SELECT * INTO #TempCorrectedRecords  FROM (
SELECT
 pr.PatientId,
 rs.Name,
 MAX(pr.Id) as PatientRecordId
FROM PatientRecord pr 
LEFT JOIN RequestStatus rs ON rs.Id = pr.RequestStatusId
WHERE 
rs.[Name] LIKE '%Corrected%'
GROUP By pr.PatientId, rs.Name
) A 
SELECT * INTO #TempFinalizedRecords  FROM (
SELECT
 pr.PatientId,
 rs.Name,
 MAX(pr.Id) as PatientRecordId
FROM PatientRecord pr 
LEFT JOIN RequestStatus rs ON rs.Id = pr.RequestStatusId
WHERE 
rs.[Name] LIKE '%Finalized%'
GROUP By pr.PatientId, rs.Name
) A 
-----------------------------------------------------------------------
SELECT * INTO #TempReleaseTable FROM ( SELECT tcr.PatientRecordId, 
0 as ReleaseStatusId,
pr.ProcedureDateTime as DateFinalized,
'' as ReleaseMethod,
'' as ReportStatus,
GETDATE() as CreatedDate,
GETDATE() as UpdatedDate,
'WIP' as UpdatedBy,
'WIP' as CreatedBy,
0 as IsDeleted FROM #TempCorrectedRecords tcr
LEFT JOIN PatientRecord pr ON pr.Id = tcr.PatientRecordId
UNION  
SELECT tfr.PatientRecordId, 
0 as ReleaseStatusId,
pr.ProcedureDateTime as DateFinalized,
'' as ReleaseMethod,
'' as ReportStatus,
GETDATE() as CreatedDate,
GETDATE() as UpdatedDate,
'WIP' as UpdatedBy,
'WIP' as CreatedBy,
0 as IsDeleted FROM #TempFinalizedRecords tfr
LEFT JOIN PatientRecord pr ON pr.Id = tfr.PatientRecordId) B
INSERT INTO Releases  
--------------------------------------------------------------------------
SELECT * FROM #TempReleaseTable trt
WHERE trt.PatientRecordId NOT IN (Select r.PatientRecordId from Releases r)