-----------------------------
--if sql hang then find out the session and request id from below query and kill the session using below command
--------------------------------
SELECT
    r.session_id,
    r.request_id,
    r.status,
    r.command,
    r.start_time,
    r.total_elapsed_time,
    s.login_name
FROM sys.dm_pdw_exec_requests r
JOIN sys.dm_pdw_exec_sessions s
    ON r.session_id = s.session_id
WHERE r.status IN ('Running', 'Suspended')
ORDER BY r.start_time DESC;
------------------------------
---kill 'SID20110518'
------------------------------

--identify columns and data type of table 

select * from information_schema.columns where table_name='sftp_aggregator_26032025'
and table_schema='dbo'