
--**State/District

select s.State_lg_Code,d.District_LG_code, s.State_Name,d.District_name from ref_district d
left join ref_state s on d.State_LG_Code=s.State_lg_Code 

--**State/District/sub-district
select sb.Subdistrict_Name,d.District_name,s.State_Name from ref_subdistrict sb
left join ref_district d on d.District_LG_code=sb.District_LG_code
left join ref_state s on sb.State_lg_Code=s.State_lg_Code

--**Occupation
select occupation,name,family_name,job_role from ref_NCO_Occupation
---------------------------------
--verify data for scheme in ETL scheme incremental load
--------------------------------
SELECT DISTINCT
    dim.AadhaarHash512,count(d.LocationStateCode as SchemeCode)
FROM [bsm2m].[MemberScheme_Matrix_Dim] dim
INNER JOIN [bsm2m].[MemberScheme_Matrix_Fact] f
    ON f.DWH_MemberId = dim.DWH_MemberId
LEFT JOIN [bsm].[MemberScheme_Lookup_Location_Dim] d
    ON d.LocationID = f.CurrentLocationID
WHERE dim.Status_Of_ONORC = 'Y'
AND d.LocationStateCode IN (4,37)
group by d.LocationStateCode