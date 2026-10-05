
------------cscid wise count 1st to 7th
SELECT registered_by_id AS CSC_ID, COUNT(*) AS Registration_Count 
FROM uw_registrations 
WHERE (mode_of_registration=2 or mode_of_registration=7) AND 
date_of_registration between '2026-02-01 00:00:00.000' and '2026-02-08 00:00:00.000'
GROUP BY registered_by_id 
ORDER BY COUNT(*) DESC;

------------cscid wise count 8th to 14th
SELECT registered_by_id AS CSC_ID, COUNT(*) AS Registration_Count 
FROM uw_registrations 
WHERE (mode_of_registration=2 or mode_of_registration=7) AND 
date_of_registration between '2026-02-08 00:00:00.000' and '2026-02-15 00:00:00.000'
GROUP BY registered_by_id 
ORDER BY COUNT(*) DESC;

------------cscid wise count 15th to 21st
SELECT registered_by_id AS CSC_ID, COUNT(*) AS Registration_Count 
FROM uw_registrations 
WHERE (mode_of_registration=2 or mode_of_registration=7) AND 
date_of_registration between '2026-02-15 00:00:00.000' and '2026-02-22 00:00:00.000'
GROUP BY registered_by_id 
ORDER BY COUNT(*) DESC;

------------cscid wise count 22th to last day of month
SELECT registered_by_id AS CSC_ID, COUNT(*) AS Registration_Count 
FROM uw_registrations 
WHERE (mode_of_registration=2 or mode_of_registration=7) AND 
date_of_registration between '2026-02-22 00:00:00.000' and '2026-03-01 00:00:00.000'
GROUP BY registered_by_id 
ORDER BY COUNT(*) DESC;

------------statewise count
SELECT current_state,b.State_Name, COUNT(*) AS Registration_Count 
FROM uw_registrations a
left join ref_state b on a. current_state = b.State_lg_Code
WHERE (mode_of_registration=2 or mode_of_registration=7) AND 
date_of_registration between '2026-02-01 00:00:00.000' and '2026-03-01 00:00:00.000'
GROUP BY current_state,b.State_Name ORDER BY COUNT(*) DESC;


/*****Below not used **********
SELECT current_state, COUNT(*) AS Registration_Count 
FROM uw_registrations 
WHERE mode_of_registration=2 AND 
date_of_registration between '2023-09-01 00:00:00.000' and '2023-10-01 00:00:00.000'
GROUP BY current_state 
ORDER BY COUNT(*) DESC;*/


