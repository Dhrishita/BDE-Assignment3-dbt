/*
  silver_listing_neighbourhood
  The LGA (listing_neighbourhood) each listing belongs to, per month.
  Source for listing_neighbourhood_snapshot (SCD2): some listings are
  re-assigned to a different LGA between scrapes.
*/
select
    listing_id,
    listing_neighbourhood,
    month_year
from {{ ref('silver_listings') }}
