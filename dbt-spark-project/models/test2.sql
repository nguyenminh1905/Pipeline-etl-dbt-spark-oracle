{{ config(materialized='incremental', incremental_strategy='append') }}

SELECT 
    id,
    name,
    value * 10 AS tripled_value
FROM raw_data 
