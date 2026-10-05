
--**State/District

select s.State_lg_Code,d.District_LG_code, s.State_Name,d.District_name from ref_district d
left join ref_state s on d.State_LG_Code=s.State_lg_Code 

--**State/District/sub-district
select sb.Subdistrict_Name,d.District_name,s.State_Name from ref_subdistrict sb
left join ref_district d on d.District_LG_code=sb.District_LG_code
left join ref_state s on sb.State_lg_Code=s.State_lg_Code

--**Occupation
select occupation,name,family_name,job_role from ref_NCO_Occupation