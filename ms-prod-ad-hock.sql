
--(a) State-wise total number of unorganised workers, including migrant workers and gig workers, registered on the e-Shram portal so far, and the percentage of the estimated workforce covered, category-wise details thereof;

--unorganised workers
select primary_occupation, count(1) as total from uw_registrations group by primary_occupation
--migrant workers
1) select current_district,primary_occupation,count(1) as migrant_in from uw_registrations
where  current_district <> district and date_of_registration < '2025-04-01 00:00:00.000'
group by current_district,primary_occupation
2)select district,primary_occupation,count(1) migrant_out from uw_registrations
where  current_district <> district and date_of_registration < '2025-04-01 00:00:00.000'
group by district,primary_occupation
--gig workers
select primary_occupation, count(1) as total_gig_worker from uw_registrations where date_of_registration<'2025-04-01 00:00:00.000' and using_gig_platform=1
group by primary_occupation 
-----------------------------------------------
--4:07 PM 4/8/2025
--10 Specific platform aggregator 
select b.current_district,count(1) as [Total Count]from [uw_platform_data] a
inner join uw_registrations b on a.ad_hashed = b.ad_hashed
left join ref_aggregator_platform c on a.platform_id = c.id
where a.delete_status=0 and b.using_gig_platform=1 and c.Id in ('10253',
'10087',
'10421',
'10372',
'10162',
'12881',
'10089',
'13434',
'13430',
'10353',
'13435'
)
group by b.current_district
-----------------------------------------------
--dms SSMS claim id
select  submitted_by_district,lower(claim_id) as claim_id ,ad_hash from uw_claim uw --Later vlookup with ref_district
------------------------------------------
--8:05 PM 4/9/2025
--Platform worker state & district wise for current date(Pipe-line)
declare @currentdate datetime
set @currentdate= ( select cast(getdate() as date))
select  s.State_Name ,d.District_name ,count(1) as Total_Count from uw_registrations   u
left join ref_district d on u.current_district=d.District_LG_code
left join ref_state s on d.State_LG_Code=s.State_lg_Code 
where cast(date_of_registration as date)=@currentdate
and mode_of_registration in (6,7)
group by d.District_name ,s.State_Name
____________________________________________
declare @currentdate datetime
set @currentdate= ( select cast(getdate() as date))
select  s.State_Name,d.District_name ,count(1) as Total_Count from uw_registrations u
left join ref_district d on u.current_district=d.District_LG_code
left join ref_state s on d.State_LG_Code=s.State_lg_Code
where cast(date_of_registration as date)=@currentdate
and mode_of_registration not in (6,7) and using_gig_platform=1
group by d.District_name ,s.State_Name
_______________________________________________
SELECT  s.State_Name ,d.District_name,count(1) as Total_Count
    FROM uw_registrations u
left join ref_district d on u.current_district=d.District_LG_code
left join ref_state s on d.State_LG_Code=s.State_lg_Code
    WHERE using_gig_platform = 1 and mode_of_registration not in (6,7)
      AND CAST(end_time_in_filling_the_form AS DATE) = CAST(GETDATE() AS DATE)
group by  s.State_Name ,d.District_name
----------------------------------
--10:25 AM 4/16/2025
--Platform aggregator wise State & District Count

select s.State_Name,d.District_name,c.Platform_Name,count(1) as [Total Count]from [uw_platform_data] a
inner join uw_registrations b on a.ad_hashed = b.ad_hashed
left join ref_aggregator_platform c on a.platform_id = c.id
left join ref_district d on b.current_district=d.District_LG_code
left join ref_state s on d.State_LG_Code=s.State_lg_Code
where a.delete_status=0 and b.mode_of_registration in (6,7) and b.date_of_registration>'2025-04-07 00:00:00.000'
group by s.State_Name,c.Platform_Name,d.District_name order by s.State_Name,d.District_name asc
--_____________________________________________________________
select s.State_Name,d.District_name,c.Platform_Name,count(1) as [Total Count]from [uw_platform_data] a
inner join uw_registrations b on a.ad_hashed = b.ad_hashed
left join ref_aggregator_platform c on a.platform_id = c.id
left join ref_district d on b.current_district=d.District_LG_code
left join ref_state s on d.State_LG_Code=s.State_lg_Code
where a.delete_status=0 and b.mode_of_registration not in (6,7) and b.using_gig_platform=1 and b.end_time_in_filling_the_form>'2025-04-07 00:00:00.000'
group by s.State_Name,c.Platform_Name,d.District_name order by s.State_Name,d.District_name asc

------------------------------------------------------------------------------
--5:03 PM 4/21/2025
--Platform worker having pan and platform name 

select count(1) as [Total Count]from [uw_platform_data] a
inner join uw_registrations b on a.ad_hashed = b.ad_hashed
left join ref_aggregator_platform c on a.platform_id = c.id
where 
a.delete_status=0 and 
b.using_gig_platform=1 and
b.pan_no is not null and
b.pan_no <>'' and 
c.Platform_Name is not null and 
c.Platform_Name <>''
------------------------------------------------------------------------------
--9:55 AM 4/22/2025
--Jansuraksha data till date

select id,
email_address,
scheme,
is_mole_funded,
token,
request_status,
request_success,
request_message,
response_timestamp,
redirect_url,
urn,
enroll_status,
failure_reason,
inserted_date_time,
ad_hashed_s512,
response_master_policy_no,
response_cover_start_date,
response_cover_end_date,
request_token,
response_request_date,
response_jansuraksha_token,
current_status,
request_timestamp,
consent_id
from jansuraksha_data where inserted_date_time>'2025-03-25 00:00:00.000'
----------------------------------------------------------------------------
--4:06 PM 4/30/2025
--Platform aggregator pipeline for power bi report
select 
b.ad_hashed,
c.Platform_Name,
CASE 
    WHEN b.aadhaar_gender = 'M' THEN 'Male'
    WHEN b.aadhaar_gender = 'F' THEN 'Female'
    WHEN b.aadhaar_gender = 'T' THEN 'Transgender'
    ELSE b.aadhaar_gender
END as Gender,
o.family_name as occupation,
o.job_role as [job role],
o.name as [job sector],
aadhaar_doB,
DATEDIFF(YEAR, b.aadhaar_doB, GETDATE()) 
    - CASE 
        WHEN FORMAT(GETDATE(), 'MM-dd') < FORMAT(b.aadhaar_doB, 'MM-dd') 
        THEN 1 
        ELSE 0 
      END AS ExactAge,
p.Name,
b.uan_no,
b.pan_no,
b.date_of_registration,
b.end_time_in_filling_the_form,
m.Name,
b.using_gig_platform,
d.District_name,
s.State_Name
from [uw_platform_data] a
inner join uw_registrations b on a.ad_hashed = b.ad_hashed
left join ref_aggregator_platform c on a.platform_id = c.id
left join ref_NCO_Occupation o on o.occupation=b.primary_occupation
left join ref_mode_of_registration m on m.Code=b.mode_of_registration
left join ref_state s on s.State_lg_Code=b.current_state
left join ref_district d on d.District_LG_code= b.current_district
left join ref_MaritalStatus p on p.Code=b.marital_status
where a.delete_status=0 and b.is_active=1

----------------------------------------------------------------------------
--1. The total number of e-Shram cards issued in Tamil Nadu till 21.07.2025, sector wise.

select current_state ,primary_occupation , count(1) as Total from uw_registrations
where date_of_registration<'2025-07-22 00:00:00.000' and current_state=33
group by current_state ,primary_occupation
-------------------------------------------------------------
--11:14 AM 7/30/2025

--(i) State-wise data of beneficiaries under e-Shram during
--the last five years and current year (upto 30.06.2025).

--Last 5 year
select State_Name,count(1) from uw_registrations a
left join ref_state b on a.current_state = b.State_lg_Code
where date_of_registration < '2025-07-01 00:00:00.000'
group by State_Name

----Current year
select State_Name,count(1) from uw_registrations a
left join ref_state b on a.current_state = b.State_lg_Code
where date_of_registration >= '2025-01-01 00:00:00.000' and date_of_registration < '2025-07-01 00:00:00.000'
group by State_Name

--(ii) District-wise (Tamil Nadu) data of beneficiaries under e-Shram during the last five years and current year (upto 30.06.2025).

--Last 5 year
select District_name,count(1) from uw_registrations a
left join ref_district b on a.current_district = b.District_LG_code
where current_state = 33 and date_of_registration < '2025-07-01 00:00:00.000'
group by District_name

----Current year
select District_name,count(1) from uw_registrations a left join ref_district b on a.current_district = b.District_LG_code
where current_state = 33 and date_of_registration > = '2025-01-01 00:00:00.000' and date_of_registration < '2025-07-01 00:00:00.000'
group by District_name

--Jansuraksha data 
select j.scheme,count(1) as total from jansuraksha_data j
left join uw_registrations u on u.ad_hashed_s512=j.ad_hashed_s512
where u.date_of_registration <'2025-08-12 00:00:00.000' and j.is_mole_funded=1 and u.current_state=36
group by j.scheme

------------------------------------------------------------------
--Subdistrict & State & District wise wise registration count
--(State & District wise registration count)
select State_Name,District_name,count(1) as Total from uw_registrations a
left join ref_state b on a.current_state = b.State_lg_Code
left join ref_district c on a.current_district = c.District_LG_code
where date_of_registration < '2025-09-09 00:00:00.000'
group by State_Name,District_name

--(Sub-district wise registration count)
select d.Subdistrict_LG_code,d.Subdistrict_Name,count(1) from uw_registrations a
left join ref_subdistrict d on a.current_tehsil = d.Subdistrict_LG_code
where a.date_of_registration < '2025-09-09 00:00:00.000'
group by d.Subdistrict_LG_code,d.Subdistrict_Name
----------------------------------------------------
--Eshram Name or Aadhar Name against UAN
SELECT u.u as uan_no,
       COALESCE(r.aadhaar_name, 'Not Available') AS aadhaar_name
FROM (
    VALUES 
        ('712093279661'),
        ('871279478622'),
        ('712099796794'),
        ('778669979564')
) u(u)
LEFT JOIN uw_registrations r
    ON r.uan_no = u.u;
--------------------------------------------------------------------------------------
--Financial year at once (2021-2022 to 2024-2025)
--( to change DATEADD(YEAR, -4, @currentFYStart) 4 to 5 or 6 according to financial year according to requirement)
--( to change primary_occupation column according to requirement)
-------------------------------------------------------
DECLARE @today DATE = GETDATE();
DECLARE @currentFYStart DATE;
DECLARE @from_year DATE;
DECLARE @to_year DATE;

-- Determine the start of the current financial year
SET @currentFYStart = CASE 
                        WHEN MONTH(@today) >= 4 
                             THEN CAST(CAST(YEAR(@today) AS VARCHAR) + '-04-01' AS DATE)
                        ELSE 
                             CAST(CAST(YEAR(@today) - 1 AS VARCHAR) + '-04-01' AS DATE)
                      END;

-- Last 4 financial years including current FY
SET @from_year = DATEADD(YEAR, -4, @currentFYStart);     -- Start of FY minus 4 years
SET @to_year   = DATEADD(DAY, -1, DATEADD(YEAR, 1, @currentFYStart));  -- End of current FY

SELECT
       CASE 
            WHEN MONTH(date_of_registration) IN (4,5,6)  THEN 'Q1'
            WHEN MONTH(date_of_registration) IN (7,8,9)  THEN 'Q2'
            WHEN MONTH(date_of_registration) IN (10,11,12) THEN 'Q3'
            WHEN MONTH(date_of_registration) IN (1,2,3)   THEN 'Q4'
       END AS FinancialQuarter,

       CASE 
            WHEN MONTH(date_of_registration) IN (1, 2, 3) 
                 THEN YEAR(date_of_registration) - 1
            ELSE YEAR(date_of_registration)
       END AS FinancialYear,
       primary_occupation,
       COUNT(*) AS TotalRegistrations
FROM uw_registrations
WHERE primary_occupation IN 
('6121.0201',
'9313.9900',
'7112.0200',
'7214.0801',
'8341.0300',
'5120.0501'
,'5120.0600'
,'5120.9900'
,'9111.9900') and current_state=27 and current_tehsil=4199 and date_of_registration<'2025-12-10 00:00:00.000'
  AND date_of_registration >= @from_year
  AND date_of_registration <= @to_year
GROUP BY
       CASE 
            WHEN MONTH(date_of_registration) IN (4,5,6) THEN 'Q1'
            WHEN MONTH(date_of_registration) IN (7,8,9) THEN 'Q2'
            WHEN MONTH(date_of_registration) IN (10,11,12) THEN 'Q3'
            WHEN MONTH(date_of_registration) IN (1,2,3) THEN 'Q4'
       END,
       CASE 
            WHEN MONTH(date_of_registration) IN (1,2,3) 
                 THEN YEAR(date_of_registration) - 1
            ELSE YEAR(date_of_registration)
       END,
       primary_occupation
ORDER BY FinancialYear, FinancialQuarter, primary_occupation;
-----------------------------------------------------------
--skill development table
select min(insert_date_time) from skill_certified_data
--for scheme (PMSYM and Other scheme)
select * from scheme_master
select top 10 * from scheme_mapping
-----------------------------------------------------
--5:24 PM 15-Dec-25
--State-wise distribution of delivery partners/aggregators, as per the Classification of Aggregators available in eShram.
select c.Platform_Name,b.current_state,count(1) from uw_platform_data a
inner join uw_registrations b on a.uan_no = b.uan_no
left join ref_aggregator_platform c on a.platform_id = c.id
where complete_status = 1 and date_of_registration < '2025-12-15 00:00:00.000'
group by b.current_state,c.Platform_Name
-----------------------------------------------------
--5:24 PM 15-Dec-25
--Aspirational District
select a.district_name as District,a.state_name as State,count(1) as Total from ref_aspirational_data a 
inner join uw_registrations u on a.District_code= u.current_district
where u.date_of_registration>=  '2025-10-01 00:00:00.000' and  u.date_of_registration>=  '2025-12-31 00:00:00.000'
group by a.district_name,a.state_name
----------------------------------------
--2:10 PM 19-Jan-26
--UAN Information with Full Address

SELECT 
    u.uan_no,
    u.aadhaar_name,
    u.Father_name,
    u.husband_name,
    u.aadhaar_doB,
    u.aadhaar_gender,
    b.Name AS blood_group,
    n.family_name as occupation,
    n.consent_agree,
    u.mobile_number,
    CONCAT(
        s.State_Name, ', ',
        d.District_name, ', ',
        sd.Subdistrict_Name, ', ',
        u.current_pincode
    ) AS Full_Address
FROM uw_registrations u
LEFT JOIN ref_state s 
    ON u.current_state = s.State_lg_Code
LEFT JOIN ref_district d 
    ON u.current_district = d.District_LG_code
LEFT JOIN ref_subdistrict sd 
    ON u.current_tehsil = sd.Subdistrict_LG_code
LEFT JOIN ref_NCO_Occupation n 
    ON n.occupation = u.primary_occupation
LEFT JOIN ref_blood_group b 
    ON b.Code = u.blood_group
WHERE u.uan_no = '711288779276';

----------------------------------------
--Domestic and houshold worker 
select s.State_Name, count(1) as total from uw_registrations u with (NOLOCK)
left join ref_state s on u.current_state=s.State_lg_Code
where u.date_of_registration<'2026-01-20 00:00:00.000' and u.primary_occupation in ('5120.0501','5120.0600','5120.9900','9111.9900')
group by s.State_Name order by total desc
------------------------------------
--Annual Login Count on eShram.
select sum(total) as daily_user_update_count from [dbo].[daily_update_records_stats] where registration_date > = '2025-01-01' and registration_date < '2026-01-01'
--------------Annual Unique Login Count of eShram.-----------------------------
SELECT COUNT(1) AS Duplicate_UAN_Count FROM (
    SELECT UANNumber FROM dbo.Worker_History_Dim WHERE RegistrationDate >= '2026-01-01' AND RegistrationDate <  '2026-01-21'
    GROUP BY UANNumber HAVING COUNT(1) > 1 ) a;
--**Note:- [dbo].[daily_update_records_stats]- pipeline is running on daily basis . if user update daily for 3 days then daily_user_update_count is 3 
-- but eshram_user_registration_count be 1 only (user Specific)


----------------------------------------------
--eshram Platform or gig worker available in NCS Scheme 
SELECT ur.current_state,d.District_name,ur.aadhaar_name,ur.mobile_number,o.job_role,
DATEDIFF(YEAR,ur.aadhaar_doB, GETDATE()) 
              - CASE WHEN MONTH(GETDATE()) * 100 + DAY(GETDATE()) < MONTH(ur.aadhaar_doB) * 100 + DAY(ur.aadhaar_doB) THEN 1 ELSE 0 END AS Age
FROM uw_registrations ur
JOIN (
    SELECT DISTINCT ad_hashed_s512, uan_no
    FROM scheme_mapping
    WHERE scheme_type = '01'
) s
    ON ur.uan_no = s.uan_no
Inner JOIN unique_pw_worker_staged_uw_reg un
    ON un.ad_512 = s.ad_hashed_s512
inner join ref_NCO_Occupation o on o.occupation=ur.primary_occupation
inner join ref_district d on d.District_LG_code=ur.current_district


WHERE ur.current_state = 27 and ur.current_district in ('482','483','497') and ur.date_of_registration<'2026-02-12 00:00:00.000';


--eshram Platform or gig worker not available in NCS Scheme
SELECT 
    ur.current_state,
    d.District_name,
    ur.aadhaar_name,
    ur.mobile_number,
    o.job_role,
    DATEDIFF(YEAR,ur.aadhaar_doB, GETDATE()) 
              - CASE WHEN MONTH(GETDATE()) * 100 + DAY(GETDATE()) < MONTH(ur.aadhaar_doB) * 100 + DAY(ur.aadhaar_doB) THEN 1 ELSE 0 END AS Age
FROM uw_registrations ur
Inner JOIN unique_pw_worker_staged_uw_reg un on un.ad_512=ur.ad_hashed_s512
inner join ref_NCO_Occupation o on o.occupation=ur.primary_occupation
inner join ref_district d on d.District_LG_code=ur.current_district
WHERE ur.current_state = 27 and ur.current_district in ('482','483','497') and ur.date_of_registration<'2026-02-12 00:00:00.000'
AND NOT EXISTS(
    SELECT 1
    FROM scheme_mapping s
    WHERE s.scheme_type = '01'
      AND s.uan_no  = ur.uan_no 
)

----------------------------------------------
--workers who have migrated from Rural to Urban locations
SELECT 
    state,
    COUNT(*) AS rural_to_urban_migrants
FROM uw_registrations
WHERE rural_urban = 0
AND current_rural_urban = 1 and state<>current_state
GROUP BY state
-------------------------------
--year wise or yearly from 1-jan to 31-dec data 
DECLARE @from_year DATE = '2020-01-01';---change from date as start date
DECLARE @to_year DATE = '2026-03-31';---change to date as end date

SELECT
       YEAR(date_of_registration) AS RegistrationYear,
       primary_occupation,
       COUNT(*) AS TotalRegistrations
FROM uw_registrations
WHERE 
date_of_registration >= @from_year
AND date_of_registration <= @to_year
AND date_of_registration < '2026-03-06 00:00:00.000' --change here the todays date

GROUP BY
       YEAR(date_of_registration),
       primary_occupation
ORDER BY
       RegistrationYear,
       primary_occupation;
---------------------------------------------------
--Platform Aggregator wise/Partner data(All except others)
select b.current_district,c.Platform_Name,count(1) as [Total Count]from [uw_platform_data] a
inner join uw_registrations b on a.ad_hashed = b.ad_hashed
left join ref_aggregator_platform c on a.platform_id = c.id
where a.delete_status=0 and a.complete_status = 1 and b.is_active = 1 and b.date_of_registration<'2026-03-03 00:00:00.000' 
and b.using_gig_platform=1
and b.current_state=32
group by b.current_district,c.Platform_Name

--Platform Aggregator wise data(others)
SELECT 'Other' AS [Platform Name],count(1) as Total
FROM uw_registrations u
WHERE NOT EXISTS (
    SELECT 1
    FROM  uw_platform_data p
    WHERE p.ad_hashed = u.ad_hashed
     

AND p.delete_status = 0
AND p.complete_status = 1
)
 AND u.using_gig_platform = 1
      AND u.is_active = 1 AND u.date_of_registration<'2026-03-03 00:00:00.000'
-----------------------------------------------------------
--Platform aggregator category wise (like ride sharing,food etc...)

select a.Name,count(1) as Total from  uw_platform_data up
left join uw_registrations uw on up.ad_hashed=uw.ad_hashed
right join ref_aggregator a on up.aggregator_id=a.Code 
where up.delete_status=0 and up.complete_status = 1 and uw.date_of_registration<'2026-04-23 00:00:00.000' and uw.using_gig_platform=1
and uw.aadhaar_gender='T'
group by a.Name
--Note** for (others) count please substract from the total count of aggregator wise count[ola,uber,sweegy etc.] 
--and aggregator category[ride sharing,health care etc.] (total aggregator wise count - total aggregator category)
-------------------------------------------------
-- Details of migrant workers from Bihar employed in different states i.e migrant out in different states from Bihar.
select current_state,count(1) migrant_out from uw_registrations
where  current_state <> state and date_of_registration < '2026-03-23 00:00:00.000' and state = 10 and current_state<>10
group by current_state
------------------------------------------------------
--Name of aggregator|Total number of Platform Workers registered|Total Number of female Platform Workers registered
select c.Platform_Name,count(1) as [Total Count], SUM(
        CASE 
            WHEN b.aadhaar_gender = 'F' THEN 1 
            ELSE 0 
        END
    ) AS [Female Count]
from [uw_platform_data] a
inner join uw_registrations b on a.ad_hashed = b.ad_hashed
left join ref_aggregator_platform c on a.platform_id = c.id
where a.delete_status=0 and a.complete_status = 1 and b.is_active = 1 and b.date_of_registration<'2026-05-21 00:00:00.000' 
and b.using_gig_platform=1
group by c.Platform_Name
------------------------------------------------------
--This does not mean they converted in 2021. It means:(eshram worker shifter to platform worker )

T--hey registered in 2021.
--They currently have using_gig_platform = 1.
--Their last profile update (end_time_in_filling_the_form) occurred in 2025.
--NOTE:- This is not the exact data this is only probability


SELECT year(r.date_of_registration),COUNT(DISTINCT u.ad_512) AS platform_workers_updated_2025
FROM unique_pw_worker_staged_uw_reg u
JOIN uw_registrations r
    ON u.ad_512 = r.ad_hashed_s512
WHERE cast(r.end_time_in_filling_the_form as date) >= '2026-01-01'
  AND cast(r.end_time_in_filling_the_form as date) < '2027-01-01'
  AND CAST(r.date_of_registration AS DATE) <> CAST(r.end_time_in_filling_the_form AS DATE) and r.using_gig_platform=1
  group by year(r.date_of_registration)
  
 ----------------------------------------------------------
 --Different scheme count Ranjit sir provided this table
 select sum(total_count) as total from scheme_wise_total_count where scheme_code='OCCUPDATENEWURL'
------------------------------------------------------------
--Age group wise data for two different table Aggregator platform
WITH RegistrationAge AS
(
    SELECT
        b.ad_hashed,
        b.current_city,
        DATEDIFF(YEAR, b.aadhaar_doB, GETDATE())
        - CASE
            WHEN DATEADD(
                YEAR,
                DATEDIFF(YEAR, b.aadhaar_doB, GETDATE()),
                b.aadhaar_doB
            ) > GETDATE()
            THEN 1
            ELSE 0
          END AS ExactAge
    FROM uw_registrations b
    WHERE b.is_active = 1
      AND b.date_of_registration < '2026-08-12 00:00:00.000'
      AND b.using_gig_platform = 1
      AND b.current_state = 2
)

SELECT
    r.current_city,
    c.Platform_Name,
    CASE
        WHEN r.ExactAge BETWEEN 16 AND 18 THEN '16-18'
        WHEN r.ExactAge BETWEEN 19 AND 40 THEN '19-40'
        WHEN r.ExactAge BETWEEN 41 AND 50 THEN '41-50'
        WHEN r.ExactAge > 50 THEN 'Above 50'
        ELSE 'Below 16'
    END AS AgeGroup,
    COUNT(1) AS [Total Count]
FROM [uw_platform_data] a
INNER JOIN RegistrationAge r
    ON a.ad_hashed = r.ad_hashed
LEFT JOIN ref_aggregator_platform c
    ON a.platform_id = c.id
WHERE a.delete_status = 0
  AND a.complete_status = 1
GROUP BY
    r.current_city,
    c.Platform_Name,
    CASE
        WHEN r.ExactAge BETWEEN 16 AND 18 THEN '16-18'
        WHEN r.ExactAge BETWEEN 19 AND 40 THEN '19-40'
        WHEN r.ExactAge BETWEEN 41 AND 50 THEN '41-50'
        WHEN r.ExactAge > 50 THEN 'Above 50'
        ELSE 'Below 16'
    END
ORDER BY
    r.current_city,
    c.Platform_Name,
    AgeGroup;
--------------------------------
--Platform Aggregator gig Daily Report 
-------------------------------
--Total_Platform_uw_using_gig
select count(1) as Total from uw_registrations where using_gig_platform=1

--Total_Unique_Workers sftp aggregator categorywise
  SELECT u.current_district ,name,count(distinct u.ad_hashed_s512)
FROM eshram_pw_aggregator_processeddata_utilization a
inner join uw_registrations u on a.Ad_Hashed_s512=u.ad_hashed_s512
left join ref_aggregator ag    ON u.aggregator_id = ag.Code
WHERE match_category <> 'sdx match'
  AND (
        (a.data_received_stage = 1 AND a.aggregator_name IN ('blinkit', 'rapidoindia', 'zeptoindia')) OR
        (a.data_received_stage = 3 AND a.aggregator_name IN ('uber', 'eternallimited')) OR
        (a.data_received_stage = 2 AND a.aggregator_name IN ('ola', 'porterindia', 'swiggyindia', 'uncledelivery', 'urbancompany'))
      )	  group by u.current_district,name
--total_union_all(aggregator Category wise)
select uw.current_state,uw.current_district,count(1) as total from uw_registrations uw 
inner join unique_pw_worker_staged_uw_reg s on s.UANNumber=uw.uan_no where uw.date_of_registration<'2026-08-21 00:00:00.000'
group by uw.current_state,uw.current_district
-------------------------------------
--aggregator Category wise bulk sftp matched with eshram data
SELECT
    uw.current_district,
    a.Name AS AggregatorName,
  count(1) as total
FROM uw_platform_data up
LEFT JOIN uw_registrations uw
    ON up.ad_hashed = uw.ad_hashed
RIGHT JOIN ref_aggregator a
    ON up.aggregator_id = a.Code
INNER JOIN unique_pw_worker_staged_uw_reg s
    ON s.UANNumber = uw.uan_no
WHERE up.delete_status = 0
  AND up.complete_status = 1
  AND uw.date_of_registration < '2026-08-21 00:00:00.000'
group by  uw.current_district,
    a.Name 
