DECLARE @ForExamination AS INTEGER , @Corrected AS INTEGER, 
@Finalized AS INTEGER, @Completed AS INTEGER, @Reading AS INTEGER,
@CancelledExam AS INTEGER, @PageNumber AS INTEGER, @RowsOfPage AS INTEGER,
@SEARCHITEM AS VARCHAR, @Draft AS INTEGER, @Payment AS INTEGER,
@DateFrom AS DATETIME, @DateTo AS DATETIME, @IsDeleted AS BIT
SELECT @ForExamination = 3,
       @Completed = 8,
       @Finalized = 5,  
	   @Corrected = 6,
	   @Reading = 4,
	   @CancelledExam = 7,
	   @Draft = 1,
	   @Payment = 2,
	   @PageNumber={1},
	   @RowsOfPage={0},
	   @DateFrom =  '{5}',  
	   @DateTo = '{4}',  
	   @IsDeleted = {3};


DROP TABLE IF EXISTS #TempPatientRecords

--------------------------------------------------
SELECT *
INTO #TempPatientRecords 
FROM PatientRecord pr
WHERE (CAST(pr.ProcedureDateTime AS Date) BETWEEN @DateFrom AND @DateTo)

--------------------------------------------------
SELECT 
*,
A.DraftPayment + A.ForExamination + A.FinalizedCorrectedCompleted + A.ForReading + A.CancelledExam as Total
FROM 
(
SELECT 
(SELECT COUNT(*) FROM #TempPatientRecords pr
WHERE pr.RequestStatusId IN (@Draft,@Payment) AND pr.ModalityId = m.Id) as DraftPayment,
(SELECT COUNT(*) FROM #TempPatientRecords pr
WHERE pr.RequestStatusId IN (@ForExamination) AND pr.ModalityId = m.Id) as ForExamination,
(SELECT COUNT(*) FROM #TempPatientRecords pr
WHERE pr.RequestStatusId IN (@Completed,@Finalized,@Corrected) AND pr.ModalityId = m.Id) as FinalizedCorrectedCompleted,
(SELECT COUNT(*) FROM #TempPatientRecords pr
WHERE pr.RequestStatusId IN (@Reading) AND pr.ModalityId = m.Id ) as ForReading,
(SELECT COUNT(*) FROM #TempPatientRecords pr
WHERE pr.RequestStatusId IN (@CancelledExam) AND pr.ModalityId = m.Id) as CancelledExam
FROM
Modality m
WHERE m.[Description] LIKE '%{2}%'
ORDER BY m.Id ASC
OFFSET (@PageNumber-1)*@RowsOfPage ROWS 
FETCH NEXT @RowsOfPage ROWS ONLY
) A WHERE A.DraftPayment + A.ForExamination + A.FinalizedCorrectedCompleted + A.ForReading + A.CancelledExam != 0;

--------------------------------------------------
SELECT 
COUNT(*) as TotalCount
FROM 
(
SELECT 
m.Id as ModalityId,
m.[Description] as Modality,
(SELECT COUNT(*) FROM #TempPatientRecords pr
WHERE pr.RequestStatusId IN (@Draft,@Payment) AND pr.ModalityId = m.Id) as DraftPayment,
(SELECT COUNT(*) FROM #TempPatientRecords pr
WHERE pr.RequestStatusId IN (@ForExamination) AND pr.ModalityId = m.Id) as ForExamination,
(SELECT COUNT(*) FROM #TempPatientRecords pr
WHERE pr.RequestStatusId IN (@Completed,@Finalized,@Corrected) AND pr.ModalityId = m.Id) as FinalizedCorrectedCompleted,
(SELECT COUNT(*) FROM #TempPatientRecords pr
WHERE pr.RequestStatusId IN (@Reading) AND pr.ModalityId = m.Id ) as ForReading,
(SELECT COUNT(*) FROM #TempPatientRecords pr
WHERE pr.RequestStatusId IN (@CancelledExam) AND pr.ModalityId = m.Id) as CancelledExam
FROM
Modality m
WHERE m.[Description] LIKE '%{2}%'
) A WHERE A.DraftPayment + A.ForExamination + A.FinalizedCorrectedCompleted + A.ForReading + A.CancelledExam != 0;


--------------------------------------------------
SELECT 
SUM(A.DraftPayment + A.ForExamination + A.FinalizedCorrectedCompleted + A.ForReading + A.CancelledExam) as GrandTotal
FROM 
(
SELECT 
m.Id as ModalityId,
m.[Description] as Modality,
(SELECT COUNT(*) FROM #TempPatientRecords pr
WHERE pr.RequestStatusId IN (@Draft,@Payment) AND pr.ModalityId = m.Id) as DraftPayment,
(SELECT COUNT(*) FROM #TempPatientRecords pr
WHERE pr.RequestStatusId IN (@ForExamination) AND pr.ModalityId = m.Id) as ForExamination,
(SELECT COUNT(*) FROM #TempPatientRecords pr
WHERE pr.RequestStatusId IN (@Completed,@Finalized,@Corrected) AND pr.ModalityId = m.Id) as FinalizedCorrectedCompleted,
(SELECT COUNT(*) FROM #TempPatientRecords pr
WHERE pr.RequestStatusId IN (@Reading) AND pr.ModalityId = m.Id ) as ForReading,
(SELECT COUNT(*) FROM #TempPatientRecords pr
WHERE pr.RequestStatusId IN (@CancelledExam) AND pr.ModalityId = m.Id) as CancelledExam
FROM
Modality m
WHERE m.[Description] LIKE '%{2}%'
) A WHERE A.DraftPayment + A.ForExamination + A.FinalizedCorrectedCompleted + A.ForReading + A.CancelledExam != 0;