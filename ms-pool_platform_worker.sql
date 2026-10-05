--Platform worker and esham unorganised worker all query scheme wise also
 --PW worker
 SELECT
    b.CurrentEshramStateCode,FORMAT(RegistrationDate,'MMM') as Months,count(1) as Total
FROM  worker_dim b
INNER JOIN [dbo].[unique_pw_worker_staged_uw_reg] u
    ON u.ad_512 = b.Ad_Hashed_s512
where  b.RegistrationDate>='2025-01-01 00:00:00.000' and b.RegistrationDate<'2026-01-01 00:00:00.000'
GROUP BY b.CurrentEshramStateCode,FORMAT(RegistrationDate,'MMM')
--------
 SELECT
    b.CurrentPrimaryOccupation,count(1) as Total
FROM  worker_dim b
INNER JOIN [dbo].[unique_pw_worker_staged_uw_reg] u
    ON u.ad_512 = b.Ad_Hashed_s512
where  b.CurrentEshramStateCode = '24' GROUP BY b.CurrentPrimaryOccupation
----eshramworker registered on scheme
 SELECT
    b.CurrentEshramDistrictCode,count(1) as Total
FROM [bsm2m].[MemberScheme_Matrix_Dim] a
INNER JOIN worker_dim b
    ON a.AadhaarHash512 = b.Ad_Hashed_s512
where b.CurrentEshramStateCode = '24' 
GROUP BY b.CurrentEshramDistrictCode
----eshramworker only registration
 SELECT
    b.CurrentEshramDistrictCode,count(1) as Total
FROM worker_dim b
where b.CurrentEshramStateCode = '24' 
GROUP BY b.CurrentEshramDistrictCode
----------
--Platform worker
  SELECT b.CurrentEshramDistrictCode,    
    SUM(CASE WHEN a.Status_Of_ONORC = 'Y' THEN 1 ELSE 0 END) AS Status_Of_ONORC,
    SUM(CASE WHEN a.Status_Of_PM_SVANIDHI = 'Y' THEN 1 ELSE 0 END) AS Status_Of_PM_SVANIDHI,
    SUM(CASE WHEN a.Status_Of_MGNREGA = 'Y' THEN 1 ELSE 0 END) AS Status_Of_MGNREGA,
    SUM(CASE WHEN a.Status_Of_PMAY_G = 'Y' THEN 1 ELSE 0 END) AS Status_Of_PMAY_G,
    SUM(CASE WHEN a.Status_Of_NFBS = 'Y' THEN 1 ELSE 0 END) AS Status_Of_NFBS,
    SUM(CASE WHEN a.Status_Of_IGNDPS = 'Y' THEN 1 ELSE 0 END) AS Status_Of_IGNDPS,
    SUM(CASE WHEN a.Status_Of_IGNOAPS = 'Y' THEN 1 ELSE 0 END) AS Status_Of_IGNOAPS,
    SUM(CASE WHEN a.Status_Of_IGNWPS = 'Y' THEN 1 ELSE 0 END) AS Status_Of_IGNWPS,
    SUM(CASE WHEN a.Status_Of_PMAY_U = 'Y' THEN 1 ELSE 0 END) AS Status_Of_PMAY_U,
    SUM(CASE WHEN a.Status_Of_PMMSY = 'Y' THEN 1 ELSE 0 END) AS Status_Of_PMMSY,
    SUM(CASE WHEN a.Status_Of_PMJJBY = 'Y' THEN 1 ELSE 0 END) AS Status_Of_PMJJBY,
    SUM(CASE WHEN a.Status_Of_PMSBY = 'Y' THEN 1 ELSE 0 END) AS Status_Of_PMSBY,
    SUM(CASE WHEN a.Status_Of_PMJAY = 'Y' THEN 1 ELSE 0 END) AS Status_Of_PMJAY,
    SUM(CASE WHEN a.Status_Of_DAY_NULM = 'Y' THEN 1 ELSE 0 END) AS Status_Of_DAY_NULM,
    SUM(CASE WHEN a.Status_Of_PMKISAN = 'Y' THEN 1 ELSE 0 END) AS Status_Of_PMKISAN,
    SUM(CASE WHEN a.Status_Of_PMMVY = 'Y' THEN 1 ELSE 0 END) AS Status_Of_PMMVY

FROM [bsm2m].[MemberScheme_Matrix_Dim] a
INNER JOIN worker_dim b
    ON a.AadhaarHash512 = b.Ad_Hashed_s512
INNER JOIN [dbo].[unique_pw_worker_staged_uw_reg] u
    ON u.ad_512 = a.AadhaarHash512
WHERE b.CurrentEshramStateCode='24'
GROUP BY b.CurrentEshramDistrictCode
------------------------------
--eshram worker registered on scheme

 SELECT b.CurrentEshramDistrictCode,
    
    SUM(CASE WHEN a.Status_Of_ONORC = 'Y' THEN 1 ELSE 0 END) AS Status_Of_ONORC,
    SUM(CASE WHEN a.Status_Of_PM_SVANIDHI = 'Y' THEN 1 ELSE 0 END) AS Status_Of_PM_SVANIDHI,
    SUM(CASE WHEN a.Status_Of_MGNREGA = 'Y' THEN 1 ELSE 0 END) AS Status_Of_MGNREGA,
    SUM(CASE WHEN a.Status_Of_PMAY_G = 'Y' THEN 1 ELSE 0 END) AS Status_Of_PMAY_G,
    SUM(CASE WHEN a.Status_Of_NFBS = 'Y' THEN 1 ELSE 0 END) AS Status_Of_NFBS,
    SUM(CASE WHEN a.Status_Of_IGNDPS = 'Y' THEN 1 ELSE 0 END) AS Status_Of_IGNDPS,
    SUM(CASE WHEN a.Status_Of_IGNOAPS = 'Y' THEN 1 ELSE 0 END) AS Status_Of_IGNOAPS,
    SUM(CASE WHEN a.Status_Of_IGNWPS = 'Y' THEN 1 ELSE 0 END) AS Status_Of_IGNWPS,
    SUM(CASE WHEN a.Status_Of_PMAY_U = 'Y' THEN 1 ELSE 0 END) AS Status_Of_PMAY_U,
    SUM(CASE WHEN a.Status_Of_PMMSY = 'Y' THEN 1 ELSE 0 END) AS Status_Of_PMMSY,
    SUM(CASE WHEN a.Status_Of_PMJJBY = 'Y' THEN 1 ELSE 0 END) AS Status_Of_PMJJBY,
    SUM(CASE WHEN a.Status_Of_PMSBY = 'Y' THEN 1 ELSE 0 END) AS Status_Of_PMSBY,
    SUM(CASE WHEN a.Status_Of_PMJAY = 'Y' THEN 1 ELSE 0 END) AS Status_Of_PMJAY,
    SUM(CASE WHEN a.Status_Of_DAY_NULM = 'Y' THEN 1 ELSE 0 END) AS Status_Of_DAY_NULM,
    SUM(CASE WHEN a.Status_Of_PMKISAN = 'Y' THEN 1 ELSE 0 END) AS Status_Of_PMKISAN,
    SUM(CASE WHEN a.Status_Of_PMMVY = 'Y' THEN 1 ELSE 0 END) AS Status_Of_PMMVY

FROM [bsm2m].[MemberScheme_Matrix_Dim] a
INNER JOIN worker_dim b
    ON a.AadhaarHash512 = b.Ad_Hashed_s512
	WHERE b.CurrentEshramStateCode ='9' and b.CurrentEshramDistrictCode='152'
	group by b.CurrentEshramDistrictCode
-----------------------------------------
--Aggregator wise for count for data came from sftp
SELECT u.aggregator_name,count(1) as Total
FROM eshram_pw_aggregator_processeddata_utilization u
inner join worker_dim w on w.Ad_Hashed_s512=u.Ad_Hashed_s512
WHERE u.match_category <> 'sdx match'
  AND (
        (u.data_received_stage = 1 AND u.aggregator_name IN ('blinkit', 'rapidoindia', 'zeptoindia')) OR
        (u.data_received_stage = 3 AND u.aggregator_name IN ('uber', 'eternallimited')) OR
        (u.data_received_stage = 2 AND u.aggregator_name IN ('ola', 'porterindia', 'swiggyindia', 'uncledelivery', 'urbancompany'))
      )
group by u.aggregator_name