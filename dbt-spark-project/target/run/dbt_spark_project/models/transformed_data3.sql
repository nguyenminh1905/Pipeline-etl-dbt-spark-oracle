
  
    
        create table default.transformed_data3
      
      
      
      
      
      
      
      

      as
      

SELECT 
    id, 
    name, 
    value * 4 as quadrupled_value
FROM raw_data
  