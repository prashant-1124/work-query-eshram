----------------------
--With PAN
----------------------

select c.Platform_Name,s.State_Name,d.District_name,count(1) as Total_with_pan from uw_platform_data a
inner join uw_registrations b on a.ad_hashed = b.ad_hashed
left join ref_aggregator_platform c on a.platform_id = c.id
inner join ref_district d on d.District_LG_code=b.current_district
inner join ref_state s on s.State_lg_Code= b.current_state
where a.delete_status=0 and b.using_gig_platform=1 and b.pan_no<>'' and b.pan_no is not null
group by c.Platform_Name,s.State_Name,d.District_name
--------------------
--Without PAN
----------------------
select c.Platform_Name,s.State_Name,d.District_name,count(1) as Total_without_pan from uw_platform_data a
inner join uw_registrations b on a.ad_hashed = b.ad_hashed
left join ref_aggregator_platform c on a.platform_id = c.id
inner join ref_district d on d.District_LG_code=b.current_district
inner join ref_state s on s.State_lg_Code= b.current_state
where a.delete_status=0 and b.using_gig_platform=1 and (b.pan_no='' or b.pan_no is null)
group by c.Platform_Name,s.State_Name,d.District_name
--------------------
--Other With PAN
----------------------
SELECT 'Other' AS [Platform Name],s.State_Name,d.District_name,count(1) as with_pan
FROM uw_registrations u
left join ref_state s on s.State_lg_Code=u.current_state
left join ref_district d on d.District_LG_code=u.current_district
WHERE NOT EXISTS (
    SELECT 1
    FROM  uw_platform_data p
    WHERE p.ad_hashed = u.ad_hashed
     

AND p.delete_status = 0
AND p.complete_status = 1
)
 AND u.using_gig_platform = 1
      AND u.is_active = 1 and u.pan_no<> '' and u.pan_no is not null  group by s.State_Name,d.District_name


--------------------
--Other Without PAN
----------------------
SELECT 'Other' AS [Platform Name],s.State_Name,d.District_name,count(1) as without_pan
FROM uw_registrations u
left join ref_state s on s.State_lg_Code=u.current_state
left join ref_district d on d.District_LG_code=u.current_district
WHERE NOT EXISTS (
    SELECT 1
    FROM  uw_platform_data p
    WHERE p.ad_hashed = u.ad_hashed
     

AND p.delete_status = 0
AND p.complete_status = 1
)
 AND u.using_gig_platform = 1
      AND u.is_active = 1 and (u.pan_no = '' or u.pan_no is  null) group by s.State_Name,d.District_name


--------------------
--Total_Aggregator_Category
----------------------
SELECT
    c.Platform_Name AS Platform_Name,
    COUNT(1) AS Total_Count
FROM uw_platform_data a
INNER JOIN uw_registrations b
    ON a.ad_hashed = b.ad_hashed
LEFT JOIN ref_aggregator_platform c
    ON a.platform_id = c.id
WHERE a.delete_status = 0
  AND a.complete_status = 1
  AND b.is_active = 1
  AND b.using_gig_platform = 1
GROUP BY c.Platform_Name

UNION ALL

SELECT
    'Other' AS Platform_Name,
    COUNT(1) AS Total_Count
FROM uw_registrations u
WHERE NOT EXISTS (
    SELECT 1
    FROM uw_platform_data p
    WHERE p.ad_hashed = u.ad_hashed
      AND p.delete_status = 0
      AND p.complete_status = 1
)
AND u.using_gig_platform = 1
AND u.is_active = 1;


--NOTE: Then run the below query and union data in excel 

SELECT
    CONCAT(aggregator_name,'_sftp') AS Platform_Name,
    COUNT(1) AS Total_Count
FROM eshram_pw_aggregator_processeddata_utilization e
WHERE e.match_category <> 'sdx match'
  AND (
       (e.data_received_stage = 1 AND e.aggregator_name IN ('blinkit','rapidoindia','zeptoindia'))
    OR (e.data_received_stage = 3 AND e.aggregator_name IN ('uber','eternallimited'))
    OR (e.data_received_stage = 2 AND e.aggregator_name IN (
            'ola',
            'porterindia',
            'swiggyindia',
            'uncledelivery',
            'urbancompany'
        ))
  )
GROUP BY aggregator_name
--------------------
--Total_platform_uw_using_gig_and_sftp(use VLOOKUP in excel and fetch statewise data)
----------------------
SELECT 
    current_state,
    COALESCE(COUNT(current_state), 0) AS Total_Platform_uw_using_gig
FROM uw_registrations 
   AND using_gig_platform = 1
GROUP BY current_state
ORDER BY current_state ASC;

------------
SELECT 
    w.CurrentEshramStateCode,
    COALESCE(COUNT(DISTINCT e.Ad_Hashed_s512), 0) AS Total_Unique_Workers
FROM worker_dim w
LEFT JOIN eshram_pw_aggregator_processeddata_utilization e
    ON e.Ad_Hashed_s512 = w.Ad_Hashed_s512
   AND e.match_category <> 'sdx match'
   AND (
        (e.data_received_stage = 1 AND e.aggregator_name IN ('blinkit','rapidoindia','zeptoindia'))
     OR (e.data_received_stage = 3 AND e.aggregator_name IN ('uber','eternallimited'))
     OR (e.data_received_stage = 2 AND e.aggregator_name IN (
            'ola','porterindia','swiggyindia',
            'uncledelivery','urbancompany'
        ))
   )
GROUP BY w.CurrentEshramStateCode
-----------
SELECT 
    w.CurrentEshramStateCode,
    COALESCE(COUNT(DISTINCT u.ad_512), 0) AS total_union_all
FROM worker_dim w 
LEFT JOIN (
    SELECT DISTINCT ad_512
    FROM dbo.unique_pw_worker_staged_uw_reg
) u
    ON w.Ad_Hashed_s512 = u.ad_512
GROUP BY w.CurrentEshramStateCode
---------------------------------
--Month on Month (mm/yyyy) sftp data received
SELECT
    FORMAT(w.RegistrationDate, 'MM/yyyy') AS MonthYear,
    COUNT(1) AS Total_Count
FROM eshram_pw_aggregator_processeddata_utilization e
inner join worker_dim w on e.Ad_Hashed_s512=w.Ad_Hashed_s512
WHERE e.match_category <> 'sdx match'
  AND (
       (e.data_received_stage = 1 AND e.aggregator_name IN ('blinkit','rapidoindia','zeptoindia'))
    OR (e.data_received_stage = 3 AND e.aggregator_name IN ('uber','eternallimited'))
    OR (e.data_received_stage = 2 AND e.aggregator_name IN (
            'ola',
            'porterindia',
            'swiggyindia',
            'uncledelivery',
            'urbancompany'
        ))
  )
GROUP BY  FORMAT(w.RegistrationDate, 'MM/yyyy')
--using gig
SELECT 
    FORMAT(date_of_registration, 'MM/yyyy') AS MonthYear,COUNT(1) AS Total
FROM uw_registrations
WHERE date_of_registration < '2026-07-28 00:00:00.000' and using_gig_platform=1
GROUP BY FORMAT(date_of_registration, 'MM/yyyy')
ORDER BY MIN(date_of_registration);
