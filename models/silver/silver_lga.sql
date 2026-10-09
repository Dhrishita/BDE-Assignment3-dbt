/*
  silver_lga
  LGA code to name mapping. Codes as integers; names upper-cased so they
  join to listing_neighbourhood and to the suburb mapping.
*/
select
    nullif(trim(lga_code), '')::int     as lga_code,
    upper(trim(lga_name))               as lga_name
from {{ source('bronze', 'raw_lga_code') }}
where nullif(trim(lga_code), '') is not null
