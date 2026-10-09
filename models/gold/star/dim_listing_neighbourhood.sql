/*
  dim_listing_neighbourhood (SCD Type 2)
  The LGA each listing belongs to, with its LGA code for joining to census data.
*/
select
    s.listing_id,
    s.listing_neighbourhood,
    l.lga_code,
    case
        when row_number() over (partition by s.listing_id order by s.dbt_valid_from) = 1
            then '1900-01-01'::timestamp
        else s.dbt_valid_from
    end                                                 as valid_from,
    coalesce(s.dbt_valid_to, '9999-12-31'::timestamp)   as valid_to
from {{ ref('listing_neighbourhood_snapshot') }} s
left join {{ ref('silver_lga') }} l
    on s.listing_neighbourhood = l.lga_name
