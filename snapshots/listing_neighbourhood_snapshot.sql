/*
  listing_neighbourhood_snapshot (SCD Type 2, timestamp strategy)
  The LGA each listing belongs to, versioned by month.
*/
{% snapshot listing_neighbourhood_snapshot %}

{{
    config(
        target_schema='silver',
        unique_key='listing_id',
        strategy='timestamp',
        updated_at='updated_at'
    )
}}

select distinct on (listing_id)
    listing_id,
    listing_neighbourhood,
    month_year::timestamp as updated_at
from {{ ref('silver_listing_neighbourhood') }}
order by listing_id, month_year desc

{% endsnapshot %}
