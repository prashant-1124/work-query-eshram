--Total data received 
-----------------------
SELECT count(1)
    FROM pw_aggregator_rawdata_utilization
    WHERE 
        (
            (data_received_stage = 3 AND aggregator_name IN ('uber')) 
            
            )

--count of pw whose all data is available
----------------------------------
SELECT COUNT(1)
FROM pw_aggregator_rawdata_utilization
WHERE aggregator_name = 'uber'
  AND data_received_stage = 3
  AND mobile_number IS NOT NULL AND TRIM(mobile_number) <> ''
  AND pw_name IS NOT NULL AND TRIM(pw_name) <> ''
  AND date_of_birth IS NOT NULL
  AND pan_number IS NOT NULL AND TRIM(pan_number) <> ''
  AND city_name IS NOT NULL AND TRIM(city_name) <> ''
  AND gender IS NOT NULL AND TRIM(gender) <> ''
  AND state_code IS NOT NULL AND TRIM(state_code) <> ''
  AND district_code IS NOT NULL AND TRIM(district_code) <>'';
  AND  days_worked is not null
 ---------------------------------
--total utilization received for pw

SELECT COUNT(1)
FROM pw_aggregator_rawdata_utilization
WHERE aggregator_name = 'uber'
  AND data_received_stage = 3
  AND  days_worked>0

--------------------------------
--worker meeting eligibilty cretria >=90   
SELECT COUNT(1)
FROM pw_aggregator_rawdata_utilization
WHERE aggregator_name = 'uber'
  AND data_received_stage = 3
  AND  days_worked>=90
 --------------------------------
 --PAN Available
 SELECT COUNT(1)
FROM pw_aggregator_rawdata_utilization
WHERE aggregator_name = 'uber'
  AND data_received_stage = 3
  AND pan_number IS NOT NULL AND TRIM(pan_number) <> ''
  --------------------------------
 --Total match with eshram(match category all(sdx_match,exact match, 90% match)
 SELECT count(1)
    FROM eshram_pw_aggregator_processeddata_utilization
    WHERE 
        (
            (data_received_stage = 3 AND aggregator_name IN ('uber'))
            
            )			
-----------------------------
--platform worker which we have received from platform aggregators, where age/DOB received and where age/dob is 60 and above. 
--**Note:- Filter out the 60 -100(>59 and <101) age only
SELECT ExactAge, COUNT(1) AS Total
FROM (
    SELECT 
        DATEDIFF(YEAR, dob, GETDATE()) 
        - CASE 
            WHEN DATEADD(YEAR, DATEDIFF(YEAR, dob, GETDATE()), dob) > GETDATE()
            THEN 1 
            ELSE 0 
          END AS ExactAge
    FROM (
        SELECT TRY_CONVERT(date, date_of_birth) AS dob
        FROM pw_aggregator_rawdata_utilization
        WHERE date_of_birth IS NOT NULL
          AND (
            (data_received_stage = 1 AND aggregator_name IN ('blinkit', 'rapidoindia', 'zeptoindia')) OR
            (data_received_stage = 3 AND aggregator_name IN ('uber', 'eternallimited')) OR
            (data_received_stage = 2 AND aggregator_name IN (
                'ola', 'porterindia', 'swiggyindia', 'uncledelivery', 'urbancompany'
            ))
          )
    ) x
    WHERE dob IS NOT NULL
) t
WHERE ExactAge >= 60
GROUP BY ExactAge
ORDER BY ExactAge;
			
  