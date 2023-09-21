   
DECLARE @reportdate datetime = '{0}/{1}/{2}', @yearstart datetime = '{0}/01/01', @monthstart datetime = '{0}/{1}/01'


BEGIN 

SELECT * INTO #Temp1 FROM ViewTable ORDER BY PolicyNumber, EndorsementNumber
SELECT * INTO #TempBindedPremium FROM ViewTable

SELECT 
PolicyNumber,
MAX(TransactionProcessDate) AS MaxDate
INTO #TempMaxDate
FROM #Temp1
WHERE TransactionProcessDate < DATEADD(day, 1, @reportdate)
GROUP BY PolicyNumber
SELECT
PolicyEndDate = CASE WHEN PolicyStatus='CANCELLED' THEN CancellationEffectiveDate ELSE PolicyExpirationDate END
INTO #TempPolicy
FROM #TempMaxDate TMD
JOIN #Temp1 T1 ON T1.PolicyNumber=TMD.PolicyNumber AND T1.TransactionProcessDate=TMD.MaxDate

-----------------------------------
SELECT * 
INTO #TempPolicy2
FROM #TempPolicy
WHERE PolicyEndDate >= @monthstart OR LastActivityDate >= @monthstart

-----------------------------------
SELECT
FORMAT(T1.TransactionEffectiveDate,'MM/dd/yyyy') as TransactionEffectiveDate,
AccountingDate = CASE WHEN T1.TransactionProcessDate > T1.TransactionEffectiveDate THEN FORMAT(T1.TransactionProcessDate, 'MM/yy') ELSE FORMAT(T1.TransactionEffectiveDate, 'MM/yy') END,
CAST(T1.ProRatedPremium AS DECIMAL(18,2)) AS ProratedPremium,
T1.TransactionType,
TotalPolicyDays = DATEDIFF(DAY, T1.PolicyEffectiveDate, T1.PolicyExpirationDate),
TotalCoveredDays = DATEDIFF(DAY, T1.TransactionEffectiveDate, T1.PolicyExpirationDate),
ITDCoveredDays = 
	CASE WHEN MONTH(@reportdate) = MONTH(TP2.PolicyEndDate) AND YEAR(@reportdate) = YEAR(TP2.PolicyEndDate) THEN
		CASE WHEN T1.TransactionProcessDate < DATEADD(day, 1, @reportdate) THEN
			DATEDIFF(	DAY,
						T1.TransactionEffectiveDate,
						CASE WHEN TP2.PolicyEndDate<@reportdate THEN TP2.PolicyEndDate ELSE @reportdate END)
		ELSE 0
		END
	ELSE
		CASE WHEN T1.TransactionProcessDate < DATEADD(day, 1, @reportdate) THEN
			DATEDIFF(	DAY,
						T1.TransactionEffectiveDate,
						CASE WHEN TP2.PolicyEndDate<=@reportdate THEN TP2.PolicyEndDate ELSE @reportdate END) + (CASE WHEN TP2.PolicyEndDate<=@reportdate THEN 0 ELSE 1 END) --UPDATED
		ELSE 0
		END
	END,
YTDCoveredDays = 
	CASE WHEN MONTH(@reportdate) = MONTH(TP2.PolicyEndDate) AND YEAR(@reportdate) = YEAR(TP2.PolicyEndDate) THEN
		CASE WHEN YEAR(T1.TransactionProcessDate) = YEAR(@reportdate) THEN
			DATEDIFF(	DAY, 
						T1.TransactionEffectiveDate,
						CASE WHEN TP2.PolicyEndDate<@reportdate THEN TP2.PolicyEndDate ELSE @reportdate END)
		ELSE 
	   	  CASE WHEN T1.TransactionProcessDate < DATEADD(day, 1, @reportdate) THEN
				DATEDIFF(	DAY, 
							CASE WHEN T1.TransactionEffectiveDate < @yearstart THEN @yearstart ELSE T1.TransactionEffectiveDate END,
							CASE WHEN TP2.PolicyEndDate<@reportdate THEN TP2.PolicyEndDate ELSE @reportdate END)
			ELSE 0
			END
		END
	ELSE
		CASE WHEN YEAR(T1.TransactionProcessDate) = YEAR(@reportdate) THEN
			DATEDIFF(	DAY, 
						T1.TransactionEffectiveDate,
						CASE WHEN TP2.PolicyEndDate<@reportdate THEN TP2.PolicyEndDate ELSE @reportdate END) + (CASE WHEN TP2.PolicyEndDate<=@reportdate THEN 0 ELSE 1 END) 
		ELSE 
		    CASE WHEN T1.TransactionProcessDate < DATEADD(day, 1, @reportdate) THEN
				DATEDIFF(	DAY, 
							CASE WHEN T1.TransactionEffectiveDate < @yearstart THEN @yearstart ELSE T1.TransactionEffectiveDate END,
							CASE WHEN TP2.PolicyEndDate<=@reportdate THEN TP2.PolicyEndDate ELSE @reportdate END) + (CASE WHEN TP2.PolicyEndDate<=@reportdate THEN 0 ELSE 1 END) 
			ELSE 0
			END
		END
	END,
MTDCoveredDays = 
    CASE WHEN MONTH(@reportdate) = MONTH(TP2.PolicyEndDate) AND YEAR(@reportdate) = YEAR(TP2.PolicyEndDate) THEN
		CASE WHEN MONTH(T1.TransactionProcessDate) = MONTH(@reportdate)  AND  YEAR(T1.TransactionProcessDate) = YEAR(@reportdate) THEN
			DATEDIFF(	DAY, 
						T1.TransactionEffectiveDate,
						CASE WHEN TP2.PolicyEndDate<@reportdate THEN TP2.PolicyEndDate ELSE @reportdate END)
		ELSE
			CASE WHEN T1.TransactionProcessDate<=@reportdate THEN
				DATEDIFF(	DAY, 
							CASE WHEN T1.TransactionEffectiveDate < @monthstart THEN @monthstart ELSE T1.TransactionEffectiveDate END,
							CASE WHEN TP2.PolicyEndDate<@reportdate THEN TP2.PolicyEndDate ELSE @reportdate END)
			ELSE 0
			END
		END
	ELSE
		CASE WHEN MONTH(T1.TransactionProcessDate) = MONTH(@reportdate)  AND  YEAR(T1.TransactionProcessDate) = YEAR(@reportdate) THEN
				DATEDIFF(	DAY, 
							T1.TransactionEffectiveDate,
							CASE WHEN TP2.PolicyEndDate<=@reportdate THEN TP2.PolicyEndDate ELSE @reportdate END) + (CASE WHEN TP2.PolicyEndDate<=@reportdate THEN 0 ELSE 1 END)
		ELSE
			CASE WHEN T1.TransactionProcessDate < DATEADD(day, 1, @reportdate) THEN
				DATEDIFF(	DAY, 
							CASE WHEN T1.TransactionEffectiveDate < @monthstart THEN @monthstart ELSE T1.TransactionEffectiveDate END,
							CASE WHEN TP2.PolicyEndDate<=@reportdate THEN TP2.PolicyEndDate ELSE @reportdate END) + (CASE WHEN TP2.PolicyEndDate<=@reportdate THEN 0 ELSE 1 END)
			ELSE 0
			END
		END
	END
INTO #Temp3
FROM #Temp1 T1
WHERE T1.TransactionEffectiveDate < DATEADD(day, 1, @reportdate)
AND T1.TransactionProcessDate < DATEADD(day, 1, @reportdate)
END


------------------------------------------------------------------------------
BEGIN 
SELECT 
InforcePremium = CASE WHEN PolicyEndDate > @reportdate THEN ProRatedPremium ELSE 0 END,
UnearnedPremium =	CASE WHEN PolicyEndDate > @reportdate THEN 
						CASE WHEN T3.TransactionType NOT IN ('CANCELLED', 'REINSTATE') THEN 
							CAST(ProRatedPremium AS DECIMAL(18,2)) - (ITDCoveredDays * ROUND(ProRatedPremium/TotalCoveredDays,2)) 
						ELSE 0 END
					ELSE 0 END,
ITDEarnedPremium = CASE WHEN T3.TransactionType NOT IN ('CANCELLED', 'REINSTATE') THEN 
						CASE WHEN PolicyEndDate > @reportdate THEN
							ITDCoveredDays * ROUND(ProRatedPremium/TotalCoveredDays,2) 
						ELSE ROUND(ProRatedPremium/TotalCoveredDays * DATEDIFF(DAY, T3.PolicyEffectiveDate, PolicyEndDate), 2) END
					ELSE 0 END
CASE WHEN T3.PolicyStatus = 'CANCELLED' THEN 1 ELSE 0 END as IsPolicyCancelled
FROM #Temp3 T3
END