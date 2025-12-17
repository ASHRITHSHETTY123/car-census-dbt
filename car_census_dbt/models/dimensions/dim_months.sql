{{ config(materialized='table') }}

WITH base AS (
    SELECT
        date AS month_start_date,
        DATE_SUB(DATE_ADD(date, INTERVAL 1 MONTH), INTERVAL 1 DAY) AS month_end_date
    FROM UNNEST(
        GENERATE_DATE_ARRAY('2023-01-01', CURRENT_DATE(), INTERVAL 1 MONTH)
    ) AS date
),

filtered AS (
    SELECT *
    FROM base
    WHERE
        CURRENT_DATE() NOT BETWEEN month_start_date AND month_end_date
        AND month_end_date >
            DATE_SUB(
                DATE_SUB(DATE_ADD(CURRENT_DATE(), INTERVAL 1 MONTH), INTERVAL 1 DAY),
                INTERVAL 13 MONTH
            )
),

final AS (
    SELECT
        LPAD(
            CAST(ROW_NUMBER() OVER (ORDER BY month_end_date) AS STRING),
            2,
            '0'
        ) AS month_precedence,
        month_start_date,
        month_end_date
    FROM filtered
    WHERE month_start_date < month_end_date
)

SELECT * FROM final
