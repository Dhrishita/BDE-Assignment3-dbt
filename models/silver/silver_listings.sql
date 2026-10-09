/*
  silver_listings
  Cleaned, typed version of bronze.raw_listings: one row per listing per month.
  - IDs and numerics cast from TEXT; blanks become NULL.
  - host_since parsed from D/M/YYYY (no leading zeros).
  - month_year comes from the source file name (MM_YYYY.csv), NOT scraped_date,
    because some scrape dates fall outside their file's month
    (e.g. 07_2020.csv contains dates up to 2020-09-05).
  - Neighbourhood names upper-cased and trimmed to match the LGA/suburb mappings.
*/
with src as (
    select * from {{ source('bronze', 'raw_listings') }}
)

select
    nullif(trim(listing_id), '')::bigint                        as listing_id,
    nullif(trim(scrape_id), '')::bigint                         as scrape_id,
    nullif(trim(scraped_date), '')::date                        as scraped_date,
    to_date(left(source_file, 7), 'MM_YYYY')                    as month_year,
    nullif(trim(host_id), '')::bigint                           as host_id,
    nullif(trim(host_name), '')                                 as host_name,
    to_date(nullif(trim(host_since), ''), 'DD/MM/YYYY')         as host_since,
    lower(nullif(trim(host_is_superhost), ''))                  as host_is_superhost,
    upper(nullif(trim(host_neighbourhood), ''))                 as host_neighbourhood,
    upper(nullif(trim(listing_neighbourhood), ''))              as listing_neighbourhood,
    nullif(trim(property_type), '')                             as property_type,
    nullif(trim(room_type), '')                                 as room_type,
    nullif(trim(accommodates), '')::numeric::int                as accommodates,
    nullif(trim(price), '')::numeric(12, 2)                     as price,
    lower(nullif(trim(has_availability), ''))                   as has_availability,
    nullif(trim(availability_30), '')::numeric::int             as availability_30,
    nullif(trim(number_of_reviews), '')::numeric::int           as number_of_reviews,
    nullif(trim(review_scores_rating), '')::numeric(5, 1)       as review_scores_rating,
    source_file
from src
where nullif(trim(listing_id), '') is not null
