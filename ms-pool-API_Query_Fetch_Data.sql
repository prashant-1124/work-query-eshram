----------BULK API--------------
/*select top 10 * from [state_district_reg_log]

select a.state_id,b.State_Name,sum(client_record_count) as registration_count from [state_district_reg_log] a
left join ref_state b on a.state_id = b.State_lg_Code where 
insert_datetime < '2024-08-21 00:00:00.000'
group by a.state_id,b.State_Name

select a.state_id,b.State_Name,sum(client_record_count) as registration_count from [state_district_reg_log] a
left join ref_state b on a.state_id = b.State_lg_Code where insert_datetime 
BETWEEN '2024-09-01 00:00:00.000' AND '2024-10-01 00:00:00.000'
group by a.state_id,b.State_Name


-----------pool query for async------
SELECT b.state_code,SUM(total_registration_count) FROM [data_sharing_reference_detail] a
LEFT JOIN [users_asnc_datasharing] b on a.user_name = b.user_name
WHERE insert_date_time < '2024-08-21 00:00:00.000' and a.user_name not in ('bhanu.prakash@psquickit.com','bparkash854@gmail.com')
group by b.state_code

SELECT b.state_code,SUM(total_registration_count) FROM [data_sharing_reference_detail] a
LEFT JOIN [users_asnc_datasharing] b on a.user_name = b.user_name
WHERE insert_date_time between '2024-09-01 00:00:00.000' AND '2024-10-01 00:00:00.000'
and a.user_name not in ('bhanu.prakash@psquickit.com','bparkash854@gmail.com')
group by b.state_code

SELECT SUM(total_registration_count) FROM [data_sharing_reference_detail]
WHERE insert_date_time between  '2024-09-01 00:00:00.000' and '2024-10-01 00:00:00.000'
and user_name <> 'bparkash854@gmail.com'


------------------------for bocw prod -----------------------

select a.state_id,b.State_Name,sum(client_record_count) from bocw_state_district_reg_log a
left join ref_state b on a.state_id = b.State_lg_Code
where insert_datetime < '2024-08-21 00:00:00.000'
--status = 1
group by a.state_id,b.State_Name

select a.state_id,b.State_Name,sum(client_record_count) as total from bocw_state_district_reg_log a
left join ref_state b on a.state_id = b.State_lg_Code
where insert_datetime between '2024-09-01 00:00:00.000' AND '2024-10-01 00:00:00.000'
--status = 1
group by a.state_id,b.State_Name

---------------pool query for bocw async----------------------
select b.state_code,sum(total_registration_count) from [data_sharing_reference_detail] a
left join [users_asnc_datasharing] b on a.user_name = b.user_name
where insert_date_time < '2024-08-21 00:00:00.000' and b.department_code = 2 and a.status = 1 and 
a.user_name not in ('bhanu.prakash@psquickit.com','bparkash854@gmail.com')
group by b.state_code

select b.state_code,sum(total_registration_count) from [data_sharing_reference_detail] a
left join [users_asnc_datasharing] b on a.user_name = b.user_name
where insert_date_time between '2024-09-01 00:00:00.000' AND '2024-10-01 00:00:00.000' and b.department_code = 2 and a.status = 1 and 
a.user_name not in ('bhanu.prakash@psquickit.com','bparkash854@gmail.com')
group by b.state_code
---------------pool query for LABOUR async----------------------
select b.state_code,sum(total_registration_count) from [data_sharing_reference_detail] a
left join [users_asnc_datasharing] b on a.user_name = b.user_name
where insert_date_time < '2024-08-21 00:00:00.000' and b.department_code = 1 and a.status = 1 and
a.user_name not in ('bhanu.prakash@psquickit.com','bparkash854@gmail.com')
group by b.state_code

select b.state_code,sum(total_registration_count) from [data_sharing_reference_detail] a
left join [users_asnc_datasharing] b on a.user_name = b.user_name
where insert_date_time between '2024-09-01 00:00:00.000' AND '2024-10-01 00:00:00.000' and b.department_code = 1 and a.status = 1 and
a.user_name not in ('bhanu.prakash@psquickit.com','bparkash854@gmail.com')
group by b.state_code*/

*************************************************************************************


--Code used in new format excel is from synapse pool and prod

-----------
--Labour_Async pool
------------
select b.state_code,sum(total_registration_count) from [data_sharing_reference_detail] a
left join [users_asnc_datasharing] b on a.user_name = b.user_name
where insert_date_time between    '2021-08-26 00:00:00.000' AND '2025-02-28 00:00:00.000' and b.department_code = 1 and a.status = 1 and
a.user_name not in ('bhanu.prakash@psquickit.com','bparkash854@gmail.com')
group by b.state_code

-----------
select b.state_code,sum(total_registration_count) from [data_sharing_reference_detail] a
left join [users_asnc_datasharing] b on a.user_name = b.user_name
where insert_date_time between   '2025-01-01 00:00:00.000' AND '2025-02-28 00:00:00.000' and b.department_code = 1 and a.status = 1 and
a.user_name not in ('bhanu.prakash@psquickit.com','bparkash854@gmail.com')
group by b.state_code


-----------
--BOCW_Async pool
------------

select b.state_code,sum(total_registration_count) from [data_sharing_reference_detail] a
left join [users_asnc_datasharing] b on a.user_name = b.user_name
where insert_date_time between   '2021-08-26 00:00:00.000' AND '2025-02-28 00:00:00.000' and b.department_code = 2 and a.status = 1 and 
a.user_name not in ('bhanu.prakash@psquickit.com','bparkash854@gmail.com')
group by b.state_code

-------

select b.state_code,sum(total_registration_count) from [data_sharing_reference_detail] a
left join [users_asnc_datasharing] b on a.user_name = b.user_name
where insert_date_time between   '2025-01-01 00:00:00.000' AND '2025-02-28 00:00:00.000' and b.department_code = 2 and a.status = 1 and 
a.user_name not in ('bhanu.prakash@psquickit.com','bparkash854@gmail.com')
group by b.state_code

-----------
--BULK API prod
------------
select a.state_id,b.State_Name,sum(client_record_count) as registration_count from [state_district_reg_log] a
left join ref_state b on a.state_id = b.State_lg_Code where insert_datetime 
BETWEEN '2021-08-26 00:00:00.000' AND '2025-02-28 00:00:00.000'
group by a.state_id,b.State_Name


--select State_lg_Code,State_Name from ref_state