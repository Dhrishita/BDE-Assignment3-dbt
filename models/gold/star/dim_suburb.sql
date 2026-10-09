/*
  dim_suburb (SCD Type 2)
  Suburb to LGA mapping, from suburb_snapshot. Used to derive host_neighbourhood_lga.
*/
select
    suburb_name,
    lga_name,
    dbt_valid_from                                      as valid_from,
    coalesce(dbt_valid_to, '9999-12-31'::timestamp)     as valid_to
from {{ ref('suburb_snapshot') }}
