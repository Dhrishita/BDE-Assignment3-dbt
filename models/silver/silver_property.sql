/*
  silver_property
  Property configuration of each listing per month.
  Source for property_snapshot (SCD2). Captures Airbnb's Jul-Aug 2020
  property-type rename (e.g. 'Apartment' -> 'Entire apartment').
*/
select
    listing_id,
    property_type,
    room_type,
    accommodates,
    month_year
from {{ ref('silver_listings') }}
