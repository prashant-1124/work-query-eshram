
--Fetch full Address with UAN 
-SELECT 
    u.uan_no,
    u.aadhaar_name,
    u.Father_name,
    u.husband_name,
    u.aadhaar_doB,
    u.aadhaar_gender,
    b.Name AS blood_group,
    n.family_name,
    u.mobile_number,
    CONCAT(
        s.State_Name, ', ',
        d.District_name, ', ',
        sd.Subdistrict_Name, ', ',
        u.current_pincode
    ) AS Full_Address
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
WHERE u.uan_no = '711288779276';
  
  