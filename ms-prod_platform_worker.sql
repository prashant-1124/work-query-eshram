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