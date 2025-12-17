{{ config(materialized='table') }}

SELECT
    month_end_date,
    branch_id,

    cars_in_stage6,
    cars_in_stage8,
    cars_in_stage9,
    cars_in_stage10,
    cars_in_stage11,
    cars_in_stage12,
    cars_in_stage13
FROM {{ ref('int_month_car_census') }}
WHERE branch_id IS NOT NULL
