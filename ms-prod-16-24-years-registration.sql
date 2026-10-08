************************************************************************
--16-24 age group data
************************************************************************	
SELECT count(1)   
  FROM 
    uw_registrations
  WHERE 
    date_of_registration >= '2021-04-01 00:00:00.000' and date_of_registration < '2022-04-01 00:00:00.000'
	and aadhaar_doB >'2001-04-07'
-------------------------------------------------------------------------
SELECT count(1)   
  FROM 
    uw_registrations
  WHERE 
    date_of_registration >= '2022-04-01 00:00:00.000' and date_of_registration < '2023-04-01 00:00:00.000'
	and aadhaar_doB >'2001-04-07'
-------------------------------------------------------------------------
SELECT count(1)   
  FROM 
    uw_registrations
  WHERE 
    date_of_registration >= '2023-04-01 00:00:00.000' and date_of_registration < '2024-04-01 00:00:00.000'
	and aadhaar_doB >'2001-04-07'
------------------------------------------------------------------------
SELECT count(1)   
  FROM 
    uw_registrations
  WHERE 
    date_of_registration >= '2024-04-01 00:00:00.000' and date_of_registration < '2025-04-01 00:00:00.000' 
	and aadhaar_doB >'2001-04-07'
----------------------------------------------------------------------------------
SELECT count(1)   
  FROM 
    uw_registrations
  WHERE 
    date_of_registration >= '2025-04-01 00:00:00.000' and date_of_registration < '2025-04-07 00:00:00.000' 
	and aadhaar_doB >'2001-04-07' --change the date till yesterday data pop out(2025-2026 FY)
	
	
***************************************************************************
--**Dynamic query for above*****
***************************************************************************
-- Declare start and end years
DECLARE @from_year VARCHAR(4) = '2022';  --change financial year
DECLARE @to_year VARCHAR(4) = '2023';    --change financial year
DECLARE @dob_cutoff DATE = '2002-10-27';   --change today's 'day' and 'month' only as person born in 2001 yr is already 24 year (but verify year 2000 according to current year)

DECLARE @from_date DATE = CAST(@from_year + '-04-01 00:00:00.000' AS DATEtime);
DECLARE @to_date DATE = CAST(@to_year + '-04-01 00:00:00.000' AS DATEtime);-- change the -04-01 according to last date in last FY

SELECT COUNT(1) AS TotalRegistrations
FROM uw_registrations
WHERE 
    date_of_registration >= @from_date
    AND date_of_registration < @to_date
    AND aadhaar_doB > @dob_cutoff;	