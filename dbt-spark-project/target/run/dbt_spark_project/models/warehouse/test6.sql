
  
    
        create table default.test6
      
      
    using parquet
      
      
      
      
      
      

      as
      -- models/warehouse/test3.sql


SELECT 
    id,
    name,
    doubled_value
FROM default.stg_test
  