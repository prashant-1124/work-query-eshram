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
------------------------------------------------
--Multiple with calculation for SQL Pool query
------------------------------------------------
WITH UniqueAdHash AS (
    SELECT AadhaarHash512
    FROM bsm2m.onorc_raw
    GROUP BY AadhaarHash512
    HAVING COUNT(1) = 1
),
AgeCalculation AS (
    SELECT
        Gender,
        CurrentStateCode,
        AadhaarHash512,
        CASE
            WHEN TRY_CONVERT(DATE, DOB) IS NULL THEN NULL
            ELSE
                DATEDIFF(YEAR, TRY_CONVERT(DATE, DOB), GETDATE())
                - CASE
                    WHEN MONTH(GETDATE()) < MONTH(TRY_CONVERT(DATE, DOB))
                      OR (
                          MONTH(GETDATE()) = MONTH(TRY_CONVERT(DATE, DOB))
                          AND DAY(GETDATE()) < DAY(TRY_CONVERT(DATE, DOB))
                      )
                    THEN 1
                    ELSE 0
                  END
        END AS ExactAge
    FROM bsm2m.onorc_raw
    WHERE AadhaarHash512 IN (
        SELECT AadhaarHash512
        FROM UniqueAdHash
    )
)
SELECT
    Gender,
    CurrentStateCode,
    CASE
        WHEN ExactAge BETWEEN 1 AND 17 THEN 'Below 18'
        WHEN ExactAge BETWEEN 18 AND 20 THEN '18-20 yrs'
        WHEN ExactAge BETWEEN 21 AND 25 THEN '21-25 yrs'
        WHEN ExactAge BETWEEN 26 AND 30 THEN '26-30 yrs'
        WHEN ExactAge BETWEEN 31 AND 35 THEN '31-35 yrs'
        WHEN ExactAge BETWEEN 36 AND 40 THEN '36-40 yrs'
        WHEN ExactAge BETWEEN 41 AND 50 THEN '41-50 yrs'
        WHEN ExactAge BETWEEN 51 AND 55 THEN '51-55 yrs'
        WHEN ExactAge BETWEEN 56 AND 60 THEN '56-60 yrs'
        WHEN ExactAge > 60 THEN 'Above 60 yrs'
        ELSE 'Unknown'
    END AS AgeGroup,
    COUNT(1) AS total
FROM AgeCalculation
GROUP BY
    Gender,
    CurrentStateCode,
    CASE
        WHEN ExactAge BETWEEN 1 AND 17 THEN 'Below 18'
        WHEN ExactAge BETWEEN 18 AND 20 THEN '18-20 yrs'
        WHEN ExactAge BETWEEN 21 AND 25 THEN '21-25 yrs'
        WHEN ExactAge BETWEEN 26 AND 30 THEN '26-30 yrs'
        WHEN ExactAge BETWEEN 31 AND 35 THEN '31-35 yrs'
        WHEN ExactAge BETWEEN 36 AND 40 THEN '36-40 yrs'
        WHEN ExactAge BETWEEN 41 AND 50 THEN '41-50 yrs'
        WHEN ExactAge BETWEEN 51 AND 55 THEN '51-55 yrs'
        WHEN ExactAge BETWEEN 56 AND 60 THEN '56-60 yrs'
        WHEN ExactAge > 60 THEN 'Above 60 yrs'
        ELSE 'Unknown'
    END
ORDER BY
    Gender,
    CurrentStateCode,
    AgeGroup;
