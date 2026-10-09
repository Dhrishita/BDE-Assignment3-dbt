/*
  fact_listings
  One row per listing per month. Contains only keys and measures; all
  descriptive attributes live in the SCD2 dimensions and are joined
  point-in-time on month_year.
  - stays             = 30 - availability_30   (active listings only)
  - estimated_revenue = stays * price          (active listings only)
*/
select
    listing_id,
    host_id,
    month_year,
    scraped_date,
    price,
    has_availability,
    availability_30,
    number_of_reviews,
    review_scores_rating,
    case when has_availability = 't' then 30 - availability_30 end              as stays,
    case when has_availability = 't' then (30 - availability_30) * price end    as estimated_revenue
from {{ ref('silver_listings') }}
