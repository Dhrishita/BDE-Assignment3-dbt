/*
  host_snapshot (SCD Type 2, timestamp strategy)
  One row per host from the latest loaded month. updated_at is the reporting
  month (month_year, derived from scraped_date's source file), so each monthly
  load writes a new version and dbt_valid_from/dbt_valid_to bound the host
  attributes that were in effect for each month.
*/
{% snapshot host_snapshot %}

{{
    config(
        target_schema='silver',
        unique_key='host_id',
        strategy='timestamp',
        updated_at='updated_at'
    )
}}

select distinct on (host_id)
    host_id,
    host_name,
    host_since,
    host_is_superhost,
    host_neighbourhood,
    month_year::timestamp as updated_at
from {{ ref('silver_host') }}
order by host_id, month_year desc, host_is_superhost desc nulls last, host_neighbourhood nulls last

{% endsnapshot %}
