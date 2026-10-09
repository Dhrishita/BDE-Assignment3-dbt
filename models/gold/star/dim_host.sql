/*
  dim_host (SCD Type 2)
  Built from host_snapshot. valid_from / valid_to give the period each
  version applies to:
  - the first version of each host is back-dated to 1900-01-01 so every
    fact row finds a match;
  - the current version's open-ended valid_to becomes 9999-12-31.
*/
select
    host_id,
    host_name,
    host_since,
    host_is_superhost,
    host_neighbourhood,
    case
        when row_number() over (partition by host_id order by dbt_valid_from) = 1
            then '1900-01-01'::timestamp
        else dbt_valid_from
    end                                                 as valid_from,
    coalesce(dbt_valid_to, '9999-12-31'::timestamp)     as valid_to
from {{ ref('host_snapshot') }}
