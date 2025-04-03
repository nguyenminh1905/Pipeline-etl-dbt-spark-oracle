{{ config(materialized='table') }}

SELECT 
    id, 
    name, 
    value * 5 as quintupled_value
FROM raw_data