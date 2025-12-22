{{ config(materialized='view') }}

SELECT
  DATE(date) AS census_date,
  stage,
  CASE
    WHEN program LIKE 'FHV%' THEN 'Buggy FHV'
    WHEN program LIKE 'Mi Nave%' THEN 'MI NAVE'
    ELSE program
  END AS program_name
FROM {{ source('operational_layer', 'op_report_carcensus') }}
