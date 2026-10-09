/*
  dim_property (SCD Type 2)
  Property type, room type and accommodates per listing, from property_snapshot.
*/
select
    listing_id,
    property_type,
    room_type,
    accommodates,
    case
        when row_number() over (partition by listing_id order by dbt_valid_from) = 1
            then '1900-01-01'::timestamp
        else dbt_valid_from
    end                                                 as valid_from,
    coalesce(dbt_valid_to, '9999-12-31'::timestamp)     as valid_to
from {{ ref('property_snapshot') }}
