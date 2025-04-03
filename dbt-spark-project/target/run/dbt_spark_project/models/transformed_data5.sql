
  
    
        create table default.transformed_data5
      
      
      
      
      
      
      
      

      as
      

SELECT 
    id, 
    name, 
    value * 6 as sextupled_value
FROM raw_data
  