{{ config(materialized='table') }}

SELECT
  month_end AS month_end_date,
  branch_id,
  stage,
  car_count
FROM {{ ref('int_monthly_car_census') }}
WHERE branch_id IS NOT NULL
