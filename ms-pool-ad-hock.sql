--**2:36 PM 3/28/2025**
--**Unique mobile number from sql pool for sftp data**
select distinct mobile_number from (SELECT a.*
FROM [dbo].[sftp_aggregator_26032025] a
LEFT JOIN [dbo].[aggregator_processed_outcome] b ON a.mobile_number = b.mobile_number 
WHERE b.mobile_number IS NULL) c
-------------------------------------------------------------------------------
--100%Match
select distinct(o.UANNumber),o.mobile_number,w.CurrentEshramStateCode from [dbo].[aggregator_processed_outcome] o 
inner join [dbo].[worker_dim] w on o.UANNumber=w.Worker_ID
where o.match_category ='exact match'
--------------------------------------------------------------------------------
--90%Match(fuzzyData)
select distinct(o.UANNumber),o.mobile_number,w.CurrentEshramStateCode,w.CurrentEshramState from [dbo].[aggregator_processed_outcome_fr] o 
inner join [dbo].[worker_dim] w on o.UANNumber=w.Worker_ID
---------------------------------------------------------------------------------
--**11:42 AM 4/15/2025
--combination of name and mobile number without space
SELECT 
    REPLACE(TRIM(driver_name), ' ', '') + REPLACE(mobile_number, ' ', '') AS driver_mobile_combo,
    COUNT(*) AS combo_count
FROM 
    sftp_aggregator_26032025
WHERE 
    mobile_number IS NOT NULL AND REPLACE(mobile_number, ' ', '') <> ''
    AND driver_name IS NOT NULL AND REPLACE(driver_name, ' ', '') <> ''
GROUP BY 
    REPLACE(TRIM(driver_name), ' ', '') + REPLACE(mobile_number, ' ', '')
HAVING 
    COUNT(*) = 1;

----------------------------------------------------------------------------
--10:46 AM 7/22/2025
--(a) the number of informal workers registered on e-Shram portal in the country as on date, State-wise; 
select w.CurrentEshramState,count(1) as Total from [bsm2m].[MemberScheme_Matrix_Dim] m
inner join worker_dim w on w.Ad_Hashed_s512=m.AadhaarHash512
where Status_Of_ESHRAM='Y' and  Status_Of_ONORC='Y'
group by w.CurrentEshramState

--(b) the details of schemes being run for welfare of informal workers in the country along with the number of beneficiaries, scheme-wise and State-wise?

select w.CurrentEshramState,count(1) as Total from [bsm2m].[MemberScheme_Matrix_Dim] m
inner join worker_dim w on w.Ad_Hashed_s512=m.AadhaarHash512
where Status_Of_ESHRAM='Y' and   Status_Of_PMAY_U='Y'
group by w.CurrentEshramState

-------------------------------------------------------------
--11:14 AM 7/30/2025

--(i) State-wise data of beneficiaries under e-Shram during
--the last five years and current year (upto 30.06.2025).

--Last 5 year
select State_Name,count(1) from uw_registrations a
left join ref_state b on a.current_state = b.State_lg_Code
where date_of_registration < '2025-07-01 00:00:00.000'
group by State_Name


(iii) State-wise & District-wise
(Tamil Nadu) data number of eShram registrants
in Tamil Nadu availing benefits in respect of 14
Schemes integrated/mapped with eShram (upto 30.06.2025)

--StateWise Scheme
select w.CurrentEshramState,count(1) as Total from [bsm2m].[MemberScheme_Matrix_Dim] m
inner join worker_dim w on w.Ad_Hashed_s512=m.AadhaarHash512
where m.Status_Of_ESHRAM='Y' and m.Status_Of_MGNREGA='Y' and w.CurrentEshramState='TAMIL NADU'
group by w.CurrentEshramState

--DistrictWise Scheme
select w.CurrentEshramDistrict,count(1) as Total from [bsm2m].[MemberScheme_Matrix_Dim] m
inner join worker_dim w on w.Ad_Hashed_s512=m.AadhaarHash512
where m.Status_Of_ESHRAM='Y' and m.Status_Of_MGNREGA ='Y' and w.CurrentEshramState='TAMIL NADU' and w.RegistrationDate<'2025-07-01 00:00:00.000'
group by w.CurrentEshramDistrict
------------------------------------------------------------------
--Eshram schemes under 8 states 
select w.CurrentEshramState,count(1) as Total from [bsm2m].[MemberScheme_Matrix_Dim] m
inner join worker_dim w on w.Ad_Hashed_s512=m.AadhaarHash512
where m.Status_Of_ESHRAM='Y' and m.Status_Of_ONORC='Y' and w.CurrentEshramState in ('ARUNACHAL PRADESH','ASSAM','MANIPUR','MEGHALAYA','MIZORAM','NAGALAND','SIKKIM','TRIPURA')
group by w.CurrentEshramState
------------------------------------------------------------------
--2:38 PM 19-Nov-25
--Uttar Pradesh who have received benefits under various social-security schemes, district, occupational and sector-wise;

select w.CurrentEshramDistrict,w.CurrentPrimaryOccupation,count(1) as Total from [bsm2m].[MemberScheme_Matrix_Dim] m
inner join worker_dim w on w.Ad_Hashed_s512=m.AadhaarHash512
where m.Status_Of_ESHRAM='Y' and m.Status_Of_PMMVY='Y' and w.CurrentEshramState='UTTAR PRADESH'
group by w.CurrentEshramDistrict,w.CurrentPrimaryOccupation

--------------------------------------------------------------------------------------
--Platform aggregator Worker Registration Count - SFTP

SELECT 
    state_code,
    MAX(data_received_stage) AS data_received_stage,
    COUNT(1) AS state_not_null
FROM pw_aggregator_rawdata_utilization
WHERE state_code IS NOT NULL
  AND NULLIF(LTRIM(RTRIM(state_code)), '') IS NOT NULL
  AND state_code NOT IN ('NULL', '#N/A', '\N')
GROUP BY state_code;

--*Note : Please remove state_code = 88 and 25 as it is not available in master

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
------------------------------------------
