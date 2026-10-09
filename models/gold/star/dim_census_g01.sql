/*
  dim_census_g01
  Census 2016 G01 reference data by LGA (population by sex, age band, etc.).
*/
select * from {{ ref('silver_census_g01') }}
