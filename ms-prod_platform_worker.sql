--Platform worker and esham unorganised worker all query scheme wise also
 --PW worker
SELECT
    b.current_state,count(1) as Total
FROM  uw_registrations b
INNER JOIN [dbo].[unique_pw_worker_staged_uw_reg] u
    ON u.ad_512 = b.Ad_Hashed_s512
where  b.date_of_registration<'2026-10-01 00:00:00.000'
GROUP BY b.current_state
------------------------------
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
---------------------------
--concatenate multiple platform names for a single user
----------------------------
SELECT
    u.uan_no,
    u.aadhaar_name,
    u.Father_name,
    u.husband_name,
    u.aadhaar_doB,
    u.aadhaar_gender,
    r.Name AS rural_urban,
    b.Name AS blood_group,
    n.family_name,
    n.job_role,

    STRING_AGG(c.Platform_Name, ',') AS Platform_Name,

    u.using_gig_platform,

    CONCAT(
        s.State_Name, ', ',
        d.District_name, ', ',
        sd.Subdistrict_Name, ', ',
        u.current_pincode
    ) AS current_Address

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
LEFT JOIN ref_rural_urban r
    ON r.Code = u.current_rural_urban
INNER JOIN uw_platform_data p
    ON p.ad_hashed = u.ad_hashed
LEFT JOIN ref_aggregator_platform c
    ON p.platform_id = c.id

WHERE u.uan_no in('784183765358',
'785324414646',
'785284474406',
'783769295674',
'784231302590',
'784064168462')
GROUP BY
    u.uan_no,
    u.aadhaar_name,
    u.Father_name,
    u.husband_name,
    u.aadhaar_doB,
    u.aadhaar_gender,
    r.Name,
    b.Name,
    n.family_name,
    n.job_role,
    u.using_gig_platform,
    s.State_Name,
    d.District_name,
    sd.Subdistrict_Name,
    u.current_pincode;