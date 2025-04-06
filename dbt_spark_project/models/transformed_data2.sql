{{ config(materialized='table') }}

SELECT 
    id, 
    name, 
    value * 3 as tripled_value
FROM raw_data