---------------------------------------
--Incremental update. original query
---------------------------------------
DECLARE @CurrentDate DATE;
DECLARE @Previous8DayDate DATE;
-- Set values
SET @CurrentDate = CAST(GETDATE() AS DATE);
SET @Previous8DayDate = CAST(DATEADD(DAY, -8, GETDATE()) AS DATE);
select case when date_of_registration = end_time_in_filling_the_form then 1
			when date_of_registration <> end_time_in_filling_the_form then 2 end as record_status,ad_hashed_s512 as aadhaar_hash512,aadhaar_name as beneficiary_name,current_state as state_code,current_district as district_code,
            aadhaar_gender as gender,aadhaar_doB AS dob,current_rural_urban as RuralorUrban,social_category as social_category,'NOT PROVIDED' as family_id,'NOT PROVIDED' as unique_member_id, disability as DifferentlyAbled,primary_occupation AS OccupationCode,date_of_registration
            from uw_registrations where end_time_in_filling_the_form > @Previous8DayDate and end_time_in_filling_the_form < @CurrentDate
________________________________
Folder name
________________________________

@concat(
  'eshram_raw_',
  formatDateTime(addDays(utcNow(), -1), 'dd-MM-yyyy')
________________________________
python mail send code 
________________________________
from datetime import datetime, timedelta

# Get yesterday's date
yesterday = datetime.utcnow() - timedelta(days=1)

# Get yesterday's date
yesterday_8 = datetime.utcnow() - timedelta(days=7)

# Format the date
formatted_date = yesterday.strftime('%d-%m-%Y')

# Format the date
formatted_date8 = yesterday_8.strftime('%d-%m-%Y')
-----------------------------------
--IN case of  parallel/segment/fragnent/chunk run change this below
--*Note:- change the date for 1 week
------------------------------------
--STEP1
-----------------------------------
DECLARE @CurrentDate DATE;
DECLARE @Previous8DayDate DATE;
-- Set values
SET @CurrentDate = '2026-02-19';--change the date here(Thursday date)
SET @Previous8DayDate = DATEADD(DAY, -8, @CurrentDate);
select case when date_of_registration = end_time_in_filling_the_form then 1
			when date_of_registration <> end_time_in_filling_the_form then 2 end as record_status,ad_hashed_s512 as aadhaar_hash512,aadhaar_name as beneficiary_name,current_state as state_code,current_district as district_code,
            aadhaar_gender as gender,aadhaar_doB AS dob,current_rural_urban as RuralorUrban,social_category as social_category,'NOT PROVIDED' as family_id,'NOT PROVIDED' as unique_member_id, disability as DifferentlyAbled,primary_occupation AS OccupationCode,date_of_registration
            from uw_registrations where end_time_in_filling_the_form > @Previous8DayDate and end_time_in_filling_the_form < @CurrentDate

------------------------------------
--STEP2
-----------------------------------
@concat(
  'eshram_raw_',
  formatDateTime(addDays(utcNow(), -22), 'dd-MM-yyyy')--change the no of days here
)
------------------------------------
--STEP3
-----------------------------------
from datetime import datetime, timedelta

--# Get yesterday's date 
yesterday = datetime.utcnow() - timedelta(days=22)  --change the number of days here

--# Get yesterday's date
yesterday_8 = datetime.utcnow() - timedelta(days=28) --change the number of days here

--# Format the date
formatted_date = yesterday.strftime('%d-%m-%Y')

--# Format the date
formatted_date8 = yesterday_8.strftime('%d-%m-%Y')
------