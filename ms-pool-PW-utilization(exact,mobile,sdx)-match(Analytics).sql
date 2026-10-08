--Run this pipeline if any sftp data received and you have not ran it after that
Aggregator_SFTP_to_uw_Registration_analytics

--Total Data Shared
select count(1) from pw_aggregator_rawdata_utilization
WHERE
is_processed = 1
and data_received_stage=4
and aggregator_name = 'amazonindia'
--Valid  Mobile received
select count(1) from pw_aggregator_rawdata_utilization
WHERE
is_processed = 1
AND aggregator_name = 'amazonindia'
AND data_received_stage=4
AND LEN(mobile_number) = 10
AND mobile_number NOT LIKE '%[^0-9]%'
AND mobile_number IS NOT NULL
AND LTRIM(RTRIM(mobile_number)) <> ''
--Valid Name  received
select count(1) from pw_aggregator_rawdata_utilization 
where is_processed=1 
and aggregator_name = 'amazonindia'
and data_received_stage=4 
and pw_name IS NOT NULL
and LTRIM(RTRIM(pw_name)) <> ''
--Count of PAN details received
select count(1) from pw_aggregator_rawdata_utilization
WHERE
is_processed = 1
and data_received_stage=4 
and aggregator_name = 'zeptoindia'
and pan_number IS NOT NULL
And len(pan_number) = 10
--Count of workers registered on eShram
SELECT COUNT(*) as total
FROM eshram_pw_aggregator_processeddata_utilization p
WHERE p.is_processed = 1
  AND p.aggregator_name = 'amazonindia'
  AND p.data_received_stage = 4
  AND p.match_category <> 'sdx match'
  AND  EXISTS (
      SELECT 1
      FROM worker_dim w
      WHERE w.Ad_Hashed_s512 = p.Ad_Hashed_s512
  )
--Count of workers not registered on eShram
Total Data Shared - Count of workers registered on eShram(substract)
--Count of workers registered on eShram but not as platform workers(Included Duplicate )
SELECT COUNT(*) as total
FROM Aggregator_stage4_utilization p
WHERE 
 p.aggregator_name = 'amazonindia'
  AND  EXISTS (
      SELECT 1
      FROM uw_registrations w
      WHERE w.Ad_Hashed_s512 = p.ad_hash_512
	  and w.using_gig_platform<>1
  )
--Count of workers registered on eShram but not as platform workers(Included No Duplicate)
SELECT p.aggregator_name,COUNT(DISTINCT p.ad_hash_512) AS total
FROM Aggregator_stage4_utilization p
WHERE p.aggregator_name in ( 'swiggyindia',
'uncledelivery',
'zeptoindia',
'delhivery',
'eternallimited',
'urbancompany',
'snabbit',
'bharattaxi',
'ola',
'driveu',
'pronto',
'uber',
'rapidoindia',
'amazonindia',
'blinkit',
'factrika',
'flipkart'

)
  AND EXISTS (
      SELECT 1
      FROM uw_registrations w
      WHERE w.Ad_Hashed_s512 = p.ad_hash_512
        AND w.using_gig_platform <> 1
  ) group by p.aggregator_name

--The number of unique ad_hash_512 values in Aggregator_stage4_utilization for aggregator_name = 'amazonindia' 
--that do not have any matching ad_512 value in unique_pw_worker_staged_uw_reg
    SELECT  p.aggregator_name,COUNT(DISTINCT p.ad_hash_512) as total FROM Aggregator_stage4_utilization p 
WHERE   p.aggregator_name in ( 'swiggyindia',
'uncledelivery',
'zeptoindia',
'delhivery',
'eternallimited',
'urbancompany',
'snabbit',
'bharattaxi',
'ola',
'driveu',
'pronto',
'uber',
'rapidoindia',
'amazonindia',
'blinkit',
'factrika',
'flipkart'

) 
 AND NOT EXISTS (  
    SELECT 1       FROM unique_pw_worker_staged_uw_reg w  
     WHERE w.ad_512 = p.ad_hash_512   )  
group by p.aggregator_name

--exact and 90 match
    SELECT  p.aggregator_name,COUNT(DISTINCT p.Ad_Hashed_s512) as total FROM eshram_pw_aggregator_processeddata_utilization p 
WHERE   p.aggregator_name in ( 'swiggyindia',
'uncledelivery',
'zeptoindia',
'delhivery',
'eternallimited',
'urbancompany',
'snabbit',
'bharattaxi',
'ola',
'driveu',
'pronto',
'uber',
'rapidoindia',
'amazonindia',
'blinkit',
'factrika',
'flipkart'

) AND p.match_category = '90 match'
 AND NOT EXISTS (  
    SELECT 1       FROM unique_pw_worker_staged_uw_reg w  
     WHERE w.ad_512 = p.Ad_Hashed_s512   )  
group by p.aggregator_name
--------------------
--Count of workers not registered on eShram-Unique Count
SELECT 
    a.aggregator_name,
    COUNT(*) AS total
FROM
(
    SELECT DISTINCT
        pw_name,
        mobile_number,
        aggregator_name
    FROM pw_aggregator_rawdata_utilization
    WHERE is_processed = 1
      AND data_received_stage = 4
) a
LEFT JOIN
(
    SELECT 
        p.pw_name,
        p.mobile_number,
        p.aggregator_name
    FROM eshram_pw_aggregator_processeddata_utilization_matched p
    WHERE p.is_processed = 1
      AND p.data_received_stage = 4
) b
    ON a.mobile_number = b.mobile_number
   AND a.pw_name = b.pw_name
WHERE b.mobile_number IS NULL
GROUP BY a.aggregator_name;