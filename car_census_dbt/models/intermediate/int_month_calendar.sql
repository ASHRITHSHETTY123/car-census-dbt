{{ config(materialized='table') }}

SELECT
  month_start,
  LAST_DAY(month_start) AS month_end
FROM UNNEST(
  GENERATE_DATE_ARRAY(
    DATE_SUB(DATE_TRUNC(CURRENT_DATE(), MONTH), INTERVAL 13 MONTH),
    DATE_TRUNC(CURRENT_DATE(), MONTH),
    INTERVAL 1 MONTH
  )
) AS month_start
WHERE month_start < CURRENT_DATE()
