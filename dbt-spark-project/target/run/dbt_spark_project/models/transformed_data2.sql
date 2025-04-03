
  
    
        create table default.transformed_data2
      
      
      
      
      
      
      
      

      as
      

SELECT 
    id, 
    name, 
    value * 3 as tripled_value
FROM raw_data
  