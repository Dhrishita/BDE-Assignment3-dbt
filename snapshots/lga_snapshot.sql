/*
  lga_snapshot (SCD Type 2, timestamp strategy)
  LGA reference data has no change timestamp in the source, so every row is
  stamped as effective from the start of time (1900-01-01). If the mapping
  file is ever reloaded with a later date, changes become new versions.
*/
{% snapshot lga_snapshot %}

{{
    config(
        target_schema='silver',
        unique_key='lga_code',
        strategy='timestamp',
        updated_at='updated_at'
    )
}}

select
    lga_code,
    lga_name,
    '1900-01-01'::timestamp as updated_at
from {{ ref('silver_lga') }}

{% endsnapshot %}
