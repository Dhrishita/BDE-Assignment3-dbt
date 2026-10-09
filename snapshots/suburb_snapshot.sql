/*
  suburb_snapshot (SCD Type 2, timestamp strategy)
  Suburb to LGA reference mapping; effective from 1900-01-01 (no source timestamp).
*/
{% snapshot suburb_snapshot %}

{{
    config(
        target_schema='silver',
        unique_key='suburb_name',
        strategy='timestamp',
        updated_at='updated_at'
    )
}}

select
    suburb_name,
    lga_name,
    '1900-01-01'::timestamp as updated_at
from {{ ref('silver_suburb') }}

{% endsnapshot %}
