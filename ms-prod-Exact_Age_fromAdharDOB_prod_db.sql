WITH AgeCalculationFromNow AS (
SELECT 
    aadhaar_doB, 
    DATEDIFF(YEAR, aadhaar_doB, GETDATE()) 
    - CASE 
        WHEN FORMAT(GETDATE(), 'MM-dd') < FORMAT(aadhaar_doB, 'MM-dd') 
        THEN 1 
        ELSE 0 
      END AS ExactAge
FROM uw_registrations)

SELECT ExactAge ,
CASE 
                WHEN ExactAge BETWEEN 1 AND 18 THEN '16-18 years'
                WHEN ExactAge BETWEEN 19 AND 29 THEN '19-29 yrs'
                WHEN ExactAge BETWEEN 30 AND 40 THEN '30-40 yrs'
                WHEN ExactAge BETWEEN 41 AND 50 THEN '41-50 yrs'
                ELSE 'Above 50 yrs' 
 end as AgeGroup
	 from AgeCalculationFromNow 

---------------------------------------------------------------------
--Used case for exactage worker
---------------------------------------------------------------------
SELECT 
    ExactAge,
    CASE 
        WHEN ExactAge BETWEEN 1 AND 18 THEN '1-18 years'
        WHEN ExactAge BETWEEN 19 AND 29 THEN '19-29 yrs'
        WHEN ExactAge BETWEEN 30 AND 40 THEN '30-40 yrs'
        WHEN ExactAge BETWEEN 41 AND 50 THEN '41-50 yrs'
        ELSE 'Above 50 yrs'
    END AS AgeGroup
FROM (
    SELECT 
        DATEDIFF(YEAR, aadhaar_doB, GETDATE())
        - CASE 
            WHEN FORMAT(GETDATE(), 'MM-dd') < FORMAT(aadhaar_doB, 'MM-dd')
            THEN 1
            ELSE 0
          END AS ExactAge
    FROM uw_registrations
) AS A;

-----------------------------------------------------------------
--used case for question for Age-Group 18-39 with unique mobile number
------------------------------------------------------------------
WITH Deduped AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY mobile_number ORDER BY date_of_registration DESC) AS rn
    FROM uw_registrations
),
AgeCalculationFromNow AS (
    SELECT 
        mobile_number,
        aadhaar_doB,
        date_of_registration,
        current_district,
        DATEDIFF(YEAR, aadhaar_doB, GETDATE()) 
        - CASE 
            WHEN FORMAT(GETDATE(), 'MM-dd') < FORMAT(aadhaar_doB, 'MM-dd') 
            THEN 1 
            ELSE 0 
          END AS ExactAge
    FROM Deduped
    WHERE rn = 1
)

SELECT 
    current_district,
    CASE 
        WHEN ExactAge BETWEEN 18 AND 39 THEN '18-40 Years'
        ELSE 'others'
    END AS AgeGroup,
    COUNT(1) AS Total
FROM AgeCalculationFromNow
WHERE date_of_registration < '2026-03-18 00:00:00.000'
GROUP BY 
    current_district,
    CASE 
        WHEN ExactAge BETWEEN 18 AND 39 THEN '18-40 Years'
        ELSE 'others'
    END;