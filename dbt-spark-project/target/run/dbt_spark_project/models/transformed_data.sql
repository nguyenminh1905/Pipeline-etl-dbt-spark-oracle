
  
    
        create table default.transformed_data
      
      
      
      
      
      
      
      

      as
      

SELECT 
    id, 
    name, 
    value * 2 as doubled_value
FROM raw_data
  