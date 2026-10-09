/*
  dm_listing_neighbourhood
  KPIs per listing_neighbourhood and month. Each fact row is joined to the
  dimension version valid in its month (SCD2 point-in-time join), so the
  view shows how the data looked at the time, not the latest version.
*/
with base as (
    select
        n.listing_neighbourhood,
        f.month_year,
        f.listing_id,
        f.host_id,
        h.host_is_superhost,
        f.has_availability = 't'    as is_active,
        f.price,
        f.review_scores_rating,
        f.stays,
        f.estimated_revenue
    from {{ ref('fact_listings') }} f
    join {{ ref('dim_listing_neighbourhood') }} n
        on  f.listing_id = n.listing_id
        and f.month_year >= n.valid_from
        and f.month_year <  n.valid_to
    left join {{ ref('dim_host') }} h
        on  f.host_id = h.host_id
        and f.month_year >= h.valid_from
        and f.month_year <  h.valid_to
),

agg as (
    select
        listing_neighbourhood,
        month_year,
        count(*) filter (where is_active)                                       as active_listings,
        count(*) filter (where not is_active)                                   as inactive_listings,
        round(100.0 * count(*) filter (where is_active) / count(*), 2)          as active_listing_rate,
        min(price) filter (where is_active)                                     as min_price,
        max(price) filter (where is_active)                                     as max_price,
        percentile_cont(0.5) within group (order by price)
            filter (where is_active)                                            as median_price,
        round(avg(price) filter (where is_active), 2)                           as avg_price,
        count(distinct host_id)                                                 as distinct_hosts,
        round(100.0 * count(distinct host_id) filter (where host_is_superhost = 't')
              / nullif(count(distinct host_id), 0), 2)                          as superhost_rate,
        round(avg(review_scores_rating) filter (where is_active), 2)            as avg_review_scores_rating,
        sum(stays)                                                              as total_stays,
        round(avg(estimated_revenue) filter (where is_active), 2)               as avg_estimated_revenue_per_active_listing
    from base
    group by listing_neighbourhood, month_year
)

select
    listing_neighbourhood,
    month_year,
    active_listing_rate,
    min_price,
    max_price,
    median_price,
    avg_price,
    distinct_hosts,
    superhost_rate,
    avg_review_scores_rating,
    round(100.0 * (active_listings - lag(active_listings) over w)
          / nullif(lag(active_listings) over w, 0), 2)                          as pct_change_active_listings,
    round(100.0 * (inactive_listings - lag(inactive_listings) over w)
          / nullif(lag(inactive_listings) over w, 0), 2)                        as pct_change_inactive_listings,
    total_stays,
    avg_estimated_revenue_per_active_listing,
    active_listings,
    inactive_listings
from agg
window w as (partition by listing_neighbourhood order by month_year)
order by listing_neighbourhood, month_year
