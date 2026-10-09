/*
  silver_census_g02
  Census 2016 G02 (Selected Medians and Averages) by LGA, typed.
  lga_code: 'LGA10050' -> 10050 so it joins to the LGA mapping.
*/
select
    replace(trim(lga_code_2016), 'LGA', '')::int                    as lga_code,
    nullif(trim(median_age_persons), '')::numeric::int              as median_age_persons,
    nullif(trim(median_mortgage_repay_monthly), '')::numeric::int   as median_mortgage_repay_monthly,
    nullif(trim(median_tot_prsnl_inc_weekly), '')::numeric::int     as median_tot_prsnl_inc_weekly,
    nullif(trim(median_rent_weekly), '')::numeric::int              as median_rent_weekly,
    nullif(trim(median_tot_fam_inc_weekly), '')::numeric::int       as median_tot_fam_inc_weekly,
    nullif(trim(average_num_psns_per_bedroom), '')::numeric(4, 2)   as average_num_psns_per_bedroom,
    nullif(trim(median_tot_hhd_inc_weekly), '')::numeric::int       as median_tot_hhd_inc_weekly,
    nullif(trim(average_household_size), '')::numeric(4, 2)         as average_household_size
from {{ source('bronze', 'raw_census_g02') }}
