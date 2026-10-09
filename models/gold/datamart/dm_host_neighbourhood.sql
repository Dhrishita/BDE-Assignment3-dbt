/*
  dm_host_neighbourhood
  Host metrics per host_neighbourhood_lga and month.
  host_neighbourhood (a suburb) is translated to its LGA through dim_suburb;
  if it is already an LGA name it is matched to dim_lga directly. Hosts with a
  missing or unmappable neighbourhood (e.g. 'OVERSEAS') are grouped as
  'UNKNOWN' so totals reconcile with the fact table.
*/
with base as (
    select
        coalesce(s.lga_name, l.lga_name, 'UNKNOWN')    as host_neighbourhood_lga,
        f.month_year,
        f.host_id,
        f.has_availability = 't'                        as is_active,
        f.estimated_revenue
    from {{ ref('fact_listings') }} f
    left join {{ ref('dim_host') }} h
        on  f.host_id = h.host_id
        and f.month_year >= h.valid_from
        and f.month_year <  h.valid_to
    left join {{ ref('dim_suburb') }} s
        on  h.host_neighbourhood = s.suburb_name
        and f.month_year >= s.valid_from
        and f.month_year <  s.valid_to
    left join {{ ref('dim_lga') }} l
        on  h.host_neighbourhood = l.lga_name
        and f.month_year >= l.valid_from
        and f.month_year <  l.valid_to
)

select
    host_neighbourhood_lga,
    month_year,
    count(distinct host_id)                                                     as distinct_hosts,
    round(sum(estimated_revenue) filter (where is_active), 2)                   as total_estimated_revenue,
    round(avg(estimated_revenue) filter (where is_active), 2)                   as avg_estimated_revenue_per_active_listing,
    round(sum(estimated_revenue) filter (where is_active)
          / nullif(count(distinct host_id), 0), 2)                              as estimated_revenue_per_host
from base
group by host_neighbourhood_lga, month_year
order by host_neighbourhood_lga, month_year
