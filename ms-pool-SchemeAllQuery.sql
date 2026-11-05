-------------------------------------------------------------------
--Person with atleast one or more scheme available 
--Que-
--| Aadhaar | Row (schemes)  | CASE result |
--| ------- | ----- | ----------- |
--| A1      | Row 1 | 0           |
--| A1      | Row 2 | 1           |
--| A1      | Row 3 | 1           |
--Ans
--| Aadhaar | Has_Any_Scheme |
--| ------- | -------------- |
--| A1      | 1              |
SELECT
    COUNT(*) AS Persons_With_Atleast_One_Scheme
FROM (
    SELECT
        a.AadhaarHash512,
        MAX(
            CASE
                WHEN
                 
               a.Status_Of_ONORC = 'Y'
                 OR a.Status_Of_PM_SVANIDHI = 'Y'
                 OR a.Status_Of_MGNREGA = 'Y'
                 OR a.Status_Of_PMAY_G = 'Y'
                 OR a.Status_Of_NFBS = 'Y'
                 OR a.Status_Of_IGNDPS = 'Y'
                 OR a.Status_Of_IGNOAPS = 'Y'
                 OR a.Status_Of_IGNWPS = 'Y'
                 OR a.Status_Of_PMAY_U = 'Y'
                 OR a.Status_Of_PMMSY = 'Y'
                 OR a.Status_Of_PMJJBY = 'Y'
                 OR a.Status_Of_PMSBY = 'Y'
                 OR a.Status_Of_PMJAY = 'Y'
                 OR a.Status_Of_DAY_NULM = 'Y'
                 OR a.Status_Of_PMKISAN = 'Y'
                 OR a.Status_Of_PMMVY = 'Y'
                THEN 1 ELSE 0
            END
        ) AS Has_Any_Scheme
    FROM [bsm2m].[MemberScheme_Matrix_Dim] a
    GROUP BY
        a.AadhaarHash512
) s
INNER JOIN worker_dim w
    ON s.AadhaarHash512 = w.Ad_Hashed_s512
WHERE
    s.Has_Any_Scheme = 1;

-------------------------------------------------------------------
--Migrant in and Migrant out of single state where it avails scheme 

--Migrant In
DECLARE @StateCode INT = 27;
DECLARE @AsOfDate DATETIME = '2026-01-28 00:00:00.000';

SELECT  
    SUM(CASE WHEN a.[Status_Of_ONORC] = 'Y' THEN 1 ELSE 0 END) AS [Status_Of_ONORC],
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
	INNER JOIN worker_dim b ON a.AadhaarHash512 = b.Ad_Hashed_s512


	WHERE 
    b.CurrentEshramStateCode = @StateCode
    AND b.CurrentEshramPermanentStateCode <> b.CurrentEshramStateCode
    AND b.RegistrationDate < @AsOfDate;
	
	
--Migrant Out

DECLARE @StateCode INT = 27;
DECLARE @AsOfDate DATETIME = '2026-01-28 00:00:00.000';

SELECT  
    SUM(CASE WHEN a.[Status_Of_ONORC] = 'Y' THEN 1 ELSE 0 END) AS [Status_Of_ONORC],
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
	INNER JOIN worker_dim b ON a.AadhaarHash512 = b.Ad_Hashed_s512


	WHERE 
    b.CurrentEshramPermanentStateCode = @StateCode
    AND b.CurrentEshramPermanentStateCode <> b.CurrentEshramStateCode
    AND b.RegistrationDate < @AsOfDate;
-------------------------------------------------------  
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

---------------------------------
--verify data for scheme in ETL scheme incremental load
--------------------------------
SELECT DISTINCT
    dim.AadhaarHash512,count(d.LocationStateCode as SchemeCode)
FROM [bsm2m].[MemberScheme_Matrix_Dim] dim
INNER JOIN [bsm2m].[MemberScheme_Matrix_Fact] f
    ON f.DWH_MemberId = dim.DWH_MemberId
LEFT JOIN [bsm].[MemberScheme_Lookup_Location_Dim] d
    ON d.LocationID = f.CurrentLocationID
WHERE dim.Status_Of_ONORC = 'Y'
AND d.LocationStateCode IN (4,37)
group by d.LocationStateCode
--------------------------------
--for old 37 scheme important tables
--------------------------------
Important table for 37 schemes
[bsm1m].[MemberScheme_Matrix_Fact_20240222]
[bsm1m].[MemberScheme_Matrix_Dim_20240311]
 [bsm].[MemberScheme_Lookup_Location_Dim]
 [bsm1m].[MemberScheme_Matrix_Dim_20240311_bi_final]
 [bsm1m].[MemberScheme_Matrix_Dim_20240311]
---------------------------------