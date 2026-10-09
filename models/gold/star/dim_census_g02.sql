/*
  dim_census_g02
  Census 2016 G02 reference data by LGA (median age, mortgage, income, household size).
*/
select * from {{ ref('silver_census_g02') }}
