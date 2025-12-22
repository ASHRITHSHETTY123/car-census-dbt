{{ config(materialized='view') }}

SELECT
  id AS branch_id,
  name AS branch_name
FROM {{ source('operational_layer', 'op_bos_organization_branch') }}
