{{ config(materialized='table') }}

SELECT
  cal.month_end,
  b.branch_id,
  c.stage,
  COUNT(*) AS car_count
FROM {{ ref('int_month_calendar') }} cal
LEFT JOIN {{ ref('stg_report_carcensus') }} c
  ON c.census_date BETWEEN cal.month_start AND cal.month_end
LEFT JOIN {{ ref('stg_branches') }} b
  ON c.program_name = b.branch_name
GROUP BY
  cal.month_end,
  b.branch_id,
  c.stage
