{{ config(materialized='table') }}

WITH rc AS (
    SELECT
        date,
        stage,
        CASE
            WHEN program LIKE 'FHV%' THEN REPLACE(TRIM(program), 'FHV', 'Buggy FHV')
            WHEN program LIKE 'Mi Nave%' THEN 'MI NAVE'
            ELSE program
        END AS program
    FROM {{ source('operational_layer', 'op_report_carcensus') }}
),

joined AS (
    SELECT
        m.month_end_date,
        ob.id AS branch_id,
        rc.stage
    FROM {{ ref('dim_months') }} m
    LEFT JOIN rc
        ON rc.date BETWEEN m.month_start_date AND m.month_end_date
    LEFT JOIN {{ source('operational_layer', 'op_bos_organization_branch') }} ob
        ON rc.program = ob.name
)

SELECT
    month_end_date,
    branch_id,

    SUM(CASE WHEN stage = 6 THEN 1 ELSE 0 END) AS cars_in_stage6,
    SUM(CASE WHEN stage = 8 THEN 1 ELSE 0 END) AS cars_in_stage8,
    SUM(CASE WHEN stage = 9 THEN 1 ELSE 0 END) AS cars_in_stage9,
    SUM(CASE WHEN stage = 10 THEN 1 ELSE 0 END) AS cars_in_stage10,
    SUM(CASE WHEN stage = 11 THEN 1 ELSE 0 END) AS cars_in_stage11,
    SUM(CASE WHEN stage = 12 THEN 1 ELSE 0 END) AS cars_in_stage12,
    SUM(CASE WHEN stage = 13 THEN 1 ELSE 0 END) AS cars_in_stage13

FROM joined
GROUP BY month_end_date, branch_id
