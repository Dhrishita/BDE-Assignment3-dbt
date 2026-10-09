/*
  dim_date
  Calendar dimension at month grain for every reporting month loaded.
*/
select distinct
    month_year,
    extract(year from month_year)::int      as year,
    extract(month from month_year)::int     as month,
    to_char(month_year, 'Mon YYYY')         as month_label
from {{ ref('silver_listings') }}
