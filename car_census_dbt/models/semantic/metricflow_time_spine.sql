{{ config(materialized='table') }}

WITH date_spine AS (
  SELECT
    date_day
  FROM UNNEST(
    GENERATE_DATE_ARRAY(
      '2020-01-01',  -- Adjust start date to your earliest data
      CURRENT_DATE(),
      INTERVAL 1 DAY
    )
  ) AS date_day
)

SELECT
  date_day AS date_day
FROM date_spine