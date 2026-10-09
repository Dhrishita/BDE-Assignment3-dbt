/*
  silver_host
  Host entity decomposed from listings: one row per host per listing-month.
  Source for host_snapshot (SCD2).
*/
select
    host_id,
    host_name,
    host_since,
    host_is_superhost,
    host_neighbourhood,
    month_year
from {{ ref('silver_listings') }}
where host_id is not null
