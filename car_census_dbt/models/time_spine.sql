{{ 
  config(
    materialized = 'table',
    metricflow_time_spine = {
      "time_column": "date_day",
      "time_granularity": "day"
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
