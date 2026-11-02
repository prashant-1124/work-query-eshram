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
