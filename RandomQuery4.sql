-- Reset Temp table 
BEGIN 
IF OBJECT_ID('tempdb..#TempRiskClaim') IS NOT NULL DROP TABLE #TempRiskClaim
IF OBJECT_ID('tempdb..#TempRiskClaimCS3s') IS NOT NULL DROP TABLE #TempRiskClaimCS3s
IF OBJECT_ID('tempdb..#TempRiskClaimDuplicates') IS NOT NULL DROP TABLE #TempRiskClaimDuplicates
END 

-- Query CS3s
SELECT * INTO #TempRiskClaimCS3s FROM (
SELECT rc.ClaimNumber, rc.ClaimSource, rc.CreatedDate 
FROM RiskClaim rc 
WHERE rc.ClaimSource IN ('CS3')
) A

-- Query RiskClaim based on CS3s
SELECT * INTO #TempRiskClaim FROM (
SELECT DISTINCT rc.ClaimNumber, rc.ClaimSource, rc.CreatedDate,rc.Id,rc.RiskDetailId FROM #TempRiskClaimCS3s cs3
LEFT JOIN RiskClaim rc ON rc.ClaimNumber = cs3.ClaimNumber
) B

-- Query duplicates in TempRiskClaim table
SELECT * INTO #TempRiskClaimDuplicates FROM (
SELECT trc.RiskDetailId, COUNT(trc.ClaimNumber) as DuplicateClaimNumber 
FROM #TempRiskClaim trc
LEFT JOIN RiskDetail rd ON rd.Id = trc.RiskDetailId
WHERE trc.ClaimSource IN ('FileHandler','CS3')
GROUP BY trc.ClaimNumber,trc.RiskDetailId
HAVING COUNT(trc.ClaimNumber) > 1 AND COUNT(trc.RiskDetailId) > 1
) C

-- Query ALL Duplicates in RiskClaim table
SELECT rc.ClaimNumber, rc.ClaimSource,
rc.RiskDetailId, rc.CreatedDate,
* FROM RiskClaim rc
WHERE rc.RiskDetailId IN (SELECT trcd.RiskDetailId FROM #TempRiskClaimDuplicates trcd)
AND ClaimSource IN ('FileHandler','CS3')
ORDER BY rc.RiskDetailId

-- Query Specific Claim 
SELECt * FROM #TempRiskClaim trc 
WHERE trc.ClaimNumber = 'M15358'
ORDER BY trc.RiskDetailId 