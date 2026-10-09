/*
  silver_suburb
  Suburb to LGA mapping, upper-cased and trimmed. Used to translate
  host_neighbourhood (a suburb) into an LGA.
*/
select
    upper(trim(suburb_name))    as suburb_name,
    upper(trim(lga_name))       as lga_name
from {{ source('bronze', 'raw_lga_suburb') }}
where nullif(trim(suburb_name), '') is not null
