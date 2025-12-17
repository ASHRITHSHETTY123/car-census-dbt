{{ 
  config(
    materialized = 'table',
    meta = {
      'metricflow_time_spine': true
    }
  ) 
}}

select
  date_day
from unnest(
  generate_date_array(
    date '2018-01-01',
    current_date(),
    interval 1 day
  )
) as date_day
