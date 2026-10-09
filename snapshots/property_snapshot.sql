/*
  property_snapshot (SCD Type 2, timestamp strategy)
  Property type, room type and capacity of each listing, versioned by month.
*/
{% snapshot property_snapshot %}

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
    property_type,
    room_type,
    accommodates,
    month_year::timestamp as updated_at
from {{ ref('silver_property') }}
order by listing_id, month_year desc

{% endsnapshot %}
