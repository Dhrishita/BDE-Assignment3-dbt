/*
  dim_lga (SCD Type 2)
  LGA code and name, from lga_snapshot.
*/
select
    lga_code,
    lga_name,
    dbt_valid_from                                      as valid_from,
    coalesce(dbt_valid_to, '9999-12-31'::timestamp)     as valid_to
from {{ ref('lga_snapshot') }}
