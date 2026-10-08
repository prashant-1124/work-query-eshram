declare  @from_year VARCHAR (20)='2021'
  declare  @to_year VARCHAR (20)='2022'

    SET @from_year = CAST (@from_year + '-04-01' AS DATE);
    SET @to_year = CAST (@to_year + '-03-31' AS DATE);
    SELECT   CASE WHEN MONTH(date_of_registration) IN (4, 5, 6) THEN 'Q1' WHEN MONTH(date_of_registration) IN (7, 8, 9) THEN 'Q2' WHEN MONTH(date_of_registration) IN (10, 11, 12) THEN 'Q3' WHEN MONTH(date_of_registration) IN (1, 2, 3) THEN 'Q4' END AS FinancialQuarter,
             CASE WHEN MONTH(date_of_registration) IN (1, 2, 3) THEN YEAR(date_of_registration) - 1 ELSE YEAR(date_of_registration) END AS FinancialYear,
             social_category,current_state,
             COUNT(*) AS TotalRegistrations
    FROM     uw_registrations
    WHERE    
            date_of_registration >= @from_year
             AND date_of_registration <= @to_year
    GROUP BY CASE WHEN MONTH(date_of_registration) IN (4, 5, 6) THEN 'Q1' WHEN MONTH(date_of_registration) IN (7, 8, 9) THEN 'Q2' WHEN MONTH(date_of_registration) IN (10, 11, 12) THEN 'Q3' WHEN MONTH(date_of_registration) IN (1, 2, 3) THEN 'Q4' END, CASE WHEN MONTH(date_of_registration) IN (1, 2, 3) THEN YEAR(date_of_registration) - 1 ELSE YEAR(date_of_registration) END, social_category,current_state
    ORDER BY FinancialYear, FinancialQuarter, social_category,current_state;