/*
  dm_property_type
  KPIs per property_type, room_type, accommodates and month, using SCD2
  point-in-time joins to dim_property and dim_host.
*/
with base as (
    select
        p.property_type,
        p.room_type,
        p.accommodates,
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
    join {{ ref('dim_property') }} p
        on  f.listing_id = p.listing_id
        and f.month_year >= p.valid_from
        and f.month_year <  p.valid_to
    left join {{ ref('dim_host') }} h
        on  f.host_id = h.host_id
        and f.month_year >= h.valid_from
        and f.month_year <  h.valid_to
),

agg as (
    select
        property_type,
        room_type,
        accommodates,
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
    group by property_type, room_type, accommodates, month_year
)

select
    property_type,
    room_type,
    accommodates,
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
window w as (partition by property_type, room_type, accommodates order by month_year)
order by property_type, room_type, accommodates, month_year
