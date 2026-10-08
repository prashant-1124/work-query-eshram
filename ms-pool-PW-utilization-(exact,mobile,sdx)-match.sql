----------------------
--Step 1(Mobile Match)
----------------------
--#Insert into existing TABLE
---Note:- if any new data arrive run this query ONLY & change aggregator_name only if required change data_received_stage also
INSERT INTO eshram_pw_aggregator_processeddata_utilization_mobile_match (
    UANNumber, workerfullname, GenderCode, DateOfBirth, pan_number, CurrentEshramStateCode,
    CurrentRegisteredMobileNo, Ad_Hashed_s512, CurrentEshramDistrictCode,
    date_of_birth, mobile_number, pw_name, days_worked, gender, state_code,
    district_code, aggregator_name, insert_date, is_processed
)
SELECT
    a.UANNumber, a.workerfullname, a.GenderCode, a.DateOfBirth, b.pan_number, a.CurrentEshramStateCode,
    a.CurrentRegisteredMobileNo, a.Ad_Hashed_s512, a.CurrentEshramDistrictCode,
    b.date_of_birth, b.mobile_number, b.pw_name, b.days_worked, b.gender, b.state_code,
    b.district_code, b.aggregator_name, GETDATE(), b.is_processed
FROM (
    SELECT 
        UANNumber, workerfullname, GenderCode, YEAR(DateOfBirth) AS DateOfBirth,
        CurrentEshramStateCode, CurrentRegisteredMobileNo, Ad_Hashed_s512, CurrentEshramDistrictCode
    FROM worker_dim
    WHERE CurrentRegisteredMobileNo IS NOT NULL AND LTRIM(RTRIM(CurrentRegisteredMobileNo)) != ''
) a
JOIN (
    SELECT *
    FROM pw_aggregator_rawdata_utilization
    WHERE mobile_number IS NOT NULL
      AND mobile_number != ''
      AND is_processed = 0
	  AND data_received_stage=4
      AND aggregator_name = 'amazonindia'  
) b
ON a.CurrentRegisteredMobileNo = b.mobile_number;
----------------------
--Step 2(exact match)
----------------------
insert into eshram_pw_aggregator_processeddata_utilization(UANNumber,workerfullname,GenderCode,DateOfBirth,pan_number,CurrentEshramStateCode
,CurrentRegisteredMobileNo,Ad_Hashed_s512,CurrentEshramDistrictCode
,date_of_birth, mobile_number,
pw_name,days_worked,gender,state_code,district_code,aggregator_name,insert_date,is_processed,match_category, data_received_stage)
select UANNumber,workerfullname,GenderCode,DateOfBirth,pan_number,CurrentEshramStateCode
,CurrentRegisteredMobileNo,Ad_Hashed_s512,CurrentEshramDistrictCode
,date_of_birth as date_of_birth,
mobile_number as mobile_number,
pw_name,days_worked,gender,state_code,district_code,aggregator_name,getdate() as insert_date,is_processed,'exact match' as match_category, 4
 from eshram_pw_aggregator_processeddata_utilization_mobile_match 
where UPPER(REPLACE(REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(workerfullname)),CHAR(160), ''),CHAR(9), ''),CHAR(10), ''),' ', ''))=
UPPER(REPLACE(REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(pw_name)),CHAR(160), ''),CHAR(9), ''),CHAR(10), ''),' ', '')) and 
is_processed=0 and aggregator_name = 'amazonindia'
----------------------
--Step 3(SDX match)
----------------------

insert into eshram_pw_aggregator_processeddata_utilization(UANNumber,workerfullname,GenderCode,DateOfBirth,pan_number,CurrentEshramStateCode
,CurrentRegisteredMobileNo,Ad_Hashed_s512,CurrentEshramDistrictCode
,date_of_birth, mobile_number,
pw_name,days_worked,gender,state_code,district_code,aggregator_name,insert_date,is_processed,match_category,data_received_stage)
select UANNumber,workerfullname,GenderCode,DateOfBirth,pan_number,CurrentEshramStateCode
,CurrentRegisteredMobileNo,Ad_Hashed_s512,CurrentEshramDistrictCode
,date_of_birth as date_of_birth,
mobile_number as mobile_number,
pw_name,days_worked,gender,state_code,district_code,aggregator_name,getdate() as insert_date,is_processed,'sdx match' as match_category,4 
 from eshram_pw_aggregator_processeddata_utilization_mobile_match 
where is_processed=0 and aggregator_name = 'amazonindia' and upper(trim(workerfullname)) != upper(trim(pw_name))
and  SOUNDEX(UPPER(REPLACE(REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(workerfullname)),CHAR(160), ''),CHAR(9), ''),CHAR(10), ''),' ', ''))) = SOUNDEX(UPPER(REPLACE(REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(pw_name)),CHAR(160), ''),CHAR(9), ''),CHAR(10), ''),' ', '')))

----------------------
--Step 4(90% match fuzzy logic)
----------------------
---------------------------------------------------------
Run the notebook __> NB_eshram_pw_aggregator_processeddata_utilization_fuzzy_90match
-----------------------------------------------------
--Step 5(change is_processed)
--Note:- Please run the below query in db after extracting ANALYTICS for reporting like count.
UPDATE pw_aggregator_rawdata_utilization
SET is_processed = 1
WHERE is_processed = 0 and data_received_stage=4 and aggregator_name = 'amazonindia' and CAST(inserted_date AS DATE) = '2026-06-17'
-----------------
UPDATE eshram_pw_aggregator_processeddata_utilization_mobile_match
SET is_processed = 1
WHERE is_processed = 0 and   aggregator_name = 'amazonindia' and  CAST(insert_date AS DATE) = '2026-06-18'
-------------------
UPDATE eshram_pw_aggregator_processeddata_utilization
SET is_processed = 1
WHERE is_processed = 0 and data_received_stage=4 and aggregator_name = 'blinkit' and  CAST(insert_date AS DATE) = '2026-06-18'

------------------------------------------------
--After pipeline run Please put null in sql for additional column added in pipeline as blank treat as '' (empty string not a null) 
--regardless of any column has data OR not just run this 
UPDATE pw_aggregator_rawdata_utilization
SET
    city_name = NULLIF(LTRIM(RTRIM(city_name)), ''),
    gender = NULLIF(LTRIM(RTRIM(gender)), ''),
	pan_number = NULLIF(LTRIM(RTRIM(pan_number)), ''),
    days_worked = NULLIF(LTRIM(RTRIM(days_worked)), ''),
	date_of_birth = NULLIF(LTRIM(RTRIM(date_of_birth)), ''),
	state_code = NULLIF(LTRIM(RTRIM(state_code)), ''),
	district_code = NULLIF(LTRIM(RTRIM(district_code)), ''),
	uan_number = NULLIF(LTRIM(RTRIM(uan_number)), '')
where data_received_stage =4  and is_processed=0 and  aggregator_name='bharattaxi'

------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------
--************************************************
--Below query required for cleaning data 
--************************************************

----------------
--If anything wrong happens
-------------
BEGIN TRANSACTION;

DELETE FROM pw_aggregator_rawdata_utilization
WHERE data_received_stage =4;

-- Verify results
SELECT COUNT(*)
FROM pw_aggregator_rawdata_utilization
WHERE data_received_stage =4;

-- If correct:
COMMIT;

-- If not:
-- ROLLBACK;


---------------------
--Mobile number with leading 91 
---------------------
--STEP-1(change 3 to number of letter you dont want including space like 4,5 etc..)
SELECT 
    mobile_number,
    CAST(mobile_number AS VARCHAR(20)) AS mobile_as_text,
    RIGHT(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(mobile_number,'+',''),' ',''),CHAR(160),''),CHAR(9),''),CHAR(10),''),CHAR(13),''),10) AS new_mn
FROM pw_aggregator_rawdata_utilization
WHERE aggregator_name = 'uncledelivery'
  AND data_received_stage = 4
  AND is_processed = 0
  AND inserted_date = '2026-06-18'
  AND CAST(mobile_number AS VARCHAR(20)) LIKE '91%';
--STEP-2
UPDATE pw_aggregator_rawdata_utilization
SET mobile_number =
    RIGHT(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(mobile_number,'+',''),' ',''),CHAR(160),''),CHAR(9),''),CHAR(10),''),CHAR(13),''),10) 
WHERE 
    REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(mobile_number,'+',''),' ',''),CHAR(160),''),CHAR(9),''),CHAR(10),''),CHAR(13),'')
    LIKE '91%'
    AND aggregator_name = 'uncledelivery'
    AND data_received_stage = 4
    AND is_processed = 0
  AND inserted_date = '2026-06-18';
----------------------
--Removing space 
--leading spaces (LTRIM/RTRIM)
--hidden NBSP (CHAR(160))
--tabs (CHAR(9))
--line breaks (CHAR(10))
--all internal spaces (' ')
------------------
UPPER(REPLACE(REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(workerfullname)),CHAR(160), ''),CHAR(9), ''),CHAR(10), ''),' ', ''))=
UPPER(REPLACE(REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(pw_name)),CHAR(160), ''),CHAR(9), ''),CHAR(10), ''),' ', ''))
-------------------
--Remove space in the mobile number
----------------
UPDATE pw_aggregator_rawdata_utilization
SET mobile_number =
    RIGHT(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(mobile_number,'+',''),' ',''),CHAR(160),''),CHAR(9),''),CHAR(10),''),CHAR(13),''),10)

WHERE 
    aggregator_name = 'pronto'
    AND data_received_stage = 4
    AND is_processed = 0;    