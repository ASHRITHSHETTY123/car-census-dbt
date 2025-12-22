{{ config(materialized='table') }}

WITH last_day_of_months AS (
  SELECT
    month_end,
    month_start
  FROM {{ ref('int_month_calendar') }}
),

census_snapshot AS (
  SELECT
    c.census_date,
    b.branch_id,
    b.branch_name,
    c.stage,
    c.program_name
  FROM {{ ref('stg_report_carcensus') }} c
  LEFT JOIN {{ ref('stg_branches') }} b
    ON c.program_name = b.branch_name
),

monthly_snapshot AS (
  SELECT
    lm.month_end,
    cs.branch_id,
    cs.stage,
    COUNT(*) AS car_count
  FROM last_day_of_months lm
  INNER JOIN census_snapshot cs
    ON cs.census_date = lm.month_end  -- ✅ Only last day of month
  WHERE cs.branch_id IS NOT NULL
  GROUP BY
    lm.month_end,
    cs.branch_id,
    cs.stage
)

SELECT
  month_end,
  branch_id,
  stage,
  car_count
FROM monthly_snapshot