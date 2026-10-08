
--Kindly share the state wise count of migrant in and migrant out workers based on current and permanent address.
---migrant in based on current and permanent address/state-------
select current_state  , count(1) as migrant_in from uw_registrations
where current_state <> state and date_of_registration < '2025-03-09 00:00:00.000'
group by current_state

---migrant out based on current and permanent address/state-------
select state,count(1) migrant_out from uw_registrations
where  current_state <> state and date_of_registration < '2025-03-09 00:00:00.000'
group by state


---++++++++++++
----
---migrant in based on current and permanent-------
select current_district,count(1) as migrant_in from uw_registrations
where  current_district <> district and date_of_registration < '2025-03-09 00:00:00.000'
group by current_district

---migrant out based on current and permanent-------
select district,count(1) migrant_out from uw_registrations
where  current_district <> district and date_of_registration < '2025-03-09 00:00:00.000'
group by district

---++++++++++++
----(in sql pool)
---migrant in based on current State and parmanent State address
select CurrentEshramStateCode  , count(1) as migrant_in from worker_dim
where CurrentEshramPermanentStateCode <> CurrentEshramStateCode and RegistrationDate < '2026-01-28 00:00:00.000' 
group by CurrentEshramStateCode


---migrant out based on current State and parmanent State address
select CurrentEshramPermanentStateCode,count(1) migrant_out from worker_dim
where  CurrentEshramPermanentStateCode <> CurrentEshramStateCode and RegistrationDate < '2026-01-28 00:00:00.000' 
group by CurrentEshramPermanentStateCode

----(in sql pool)
---migrant in based on current State and parmanent State address(CURRENT VS PARMANENT)
select CurrentEshramStateCode  , count(1) as migrant_in from worker_dim
where   CurrentEshramPermanentStateCode <> CurrentEshramStateCode and RegistrationDate < '2026-01-20 00:00:00.000' 
group by CurrentEshramStateCode
---migrant out based on current State and parmanent State address(CURRENT VS PARMANENT)
select CurrentEshramPermanentStateCode,count(1) migrant_out from worker_dim
where   CurrentEshramPermanentStateCode <> CurrentEshramStateCode and RegistrationDate < '2026-01-20 00:00:00.000' 
group by CurrentEshramPermanentStateCode
---migrant in based on current State and aadhaar State address(CURRENT VS AADHAAR)
select CurrentEshramStateCode  , count(1) as migrant_in from worker_dim
where  CurrentEshramStateCode<>CurrentAadhaarStateCode and RegistrationDate < '2026-01-20 00:00:00.000' 
group by CurrentEshramStateCode
---migrant out based on current State and aadhaar State address(CURRENT VS AADHAAR)
select CurrentAadhaarStateCode,count(1) migrant_out from worker_dim
where  CurrentEshramStateCode<>CurrentAadhaarStateCode and RegistrationDate < '2026-01-20 00:00:00.000' 
group by CurrentAadhaarStateCode
--migrant in based on parmanent State and aadhaar State address(PARMANENT VS AADHAAR)
select CurrentEshramPermanentStateCode  , count(1) as migrant_in from worker_dim
where  CurrentEshramPermanentStateCode<>CurrentAadhaarStateCode and RegistrationDate < '2026-01-20 00:00:00.000' 
group by CurrentEshramPermanentStateCode
--migrant out based on parmanent State and aadhaar State address(PARMANENT VS AADHAAR)
select CurrentAadhaarStateCode,count(1) migrant_out from worker_dim
where  CurrentEshramPermanentStateCode<>CurrentAadhaarStateCode and RegistrationDate < '2026-01-20 00:00:00.000' 
group by CurrentAadhaarStateCode

--------------------------------------------------------------------------

----Details of migrant workers from Bihar employed in different states i.e migrant out in different states from Bihar.(Statewise)
select current_state,count(1) migrant_out from uw_registrations
where  current_state <> state and date_of_registration < '2026-03-23 00:00:00.000' and state = 10 and current_state<>10
group by current_state
----Details of migrant workers from Bihar employed in different states i.e migrant out in different states from Bihar.(Districtwise)
select current_district,count(1) migrant_out from uw_registrations
where  current_district <> district and date_of_registration < '2026-03-23 00:00:00.000' and district = 199 and current_district<>199
group by current_district


--Details of migrant workers from Different state employed in Bihar i.e migrant in from Bihar to different states .
select state,count(1) migrant_in from uw_registrations
where  current_state <> state and date_of_registration < '2026-03-23 00:00:00.000' and state <> 10 and current_state=10
group by state
----Details of migrant workers from Different state employed in Bihar i.e migrant in from Bihar to different states.(Districtwise)
select district,count(1) migrant_in from uw_registrations
where  current_district <> district and date_of_registration < '2026-03-23 00:00:00.000' and district <> 199 and current_district =199
group by district
----------------------------------------------------
--Migrant data based on current rural and urban
select * from ref_rural_urban
--------------current rural---------
--migrant in
select current_state,count(1) migrant_in from uw_registrations 
where date_of_registration < '2026-01-23 00:00:00.000' and current_state <> state and current_rural_urban = 0 
group by current_state
--migrant out
select state,count(1) migrant_out from uw_registrations 
where date_of_registration < '2026-01-23 00:00:00.000' and current_state <> state and current_rural_urban = 0 
group by state

-----------current urban----------------
--migrant in
select current_state,count(1) migrant_in from uw_registrations 
where date_of_registration < '2026-01-23 00:00:00.000' and current_state <> state and current_rural_urban = 1 
group by current_state
--migrant out
select state,count(1) migrant_out from uw_registrations 
where date_of_registration < '2026-01-23 00:00:00.000' and current_state <> state and current_rural_urban = 1
group by state
----------------------------------------
--This will give one row each for districts 205, 216, and 223
--migrant_in = from other states into that district
--Currently residing in one of these Bihar districts, but permanent state is outside Bihar
SELECT
    current_district AS bihar_district,
    COUNT(*) AS migrant_in
FROM uw_registrations
WHERE
    current_district IN (205,216,223)
    AND current_state = 10
    AND state <> 10
    AND date_of_registration < '2026-03-31 00:00:00.000'
GROUP BY current_district
ORDER BY current_district;
--migrant_out = from that district to other states
--Permanent district is one of these Bihar districts, but currently living outside Bihar
SELECT
    district AS bihar_district,
    COUNT(*) AS migrant_out
FROM uw_registrations
WHERE
    district IN (205,216,223)
    AND state = 10
    AND current_state <> 10
    AND date_of_registration < '2026-03-31 00:00:00.000'
GROUP BY district
ORDER BY district;

---Currently residing in 205/216/223, but permanent district is somewhere else - Migrant IN
SELECT
    current_district AS bihar_district,
    COUNT(*) AS migrant_in
FROM uw_registrations
WHERE
    current_district IN (205,216,223)
    AND (
        district <> current_district
        OR state <> current_state
    )
    AND date_of_registration < '2026-03-31'
GROUP BY current_district
ORDER BY current_district;
--Permanent district is 205/216/223, but currently in a different district anywhere in India - Migrant OUT
SELECT
    district AS bihar_district,
    COUNT(*) AS migrant_out
FROM uw_registrations
WHERE
    district IN (205,216,223)
    AND (
        current_district <> district
        OR current_state <> state
    )
    AND date_of_registration < '2026-03-31'
GROUP BY district
ORDER BY district;
------------------------------------------------------------------
