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
