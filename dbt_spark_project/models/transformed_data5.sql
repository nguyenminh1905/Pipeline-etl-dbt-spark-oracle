{{ config(materialized='table') }}

SELECT 
    id, 
    name, 
    value * 6 as sextupled_value
FROM {{  ref('raw_data' )}}