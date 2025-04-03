
  
    
        create table default.transformed_data4
      
      
      
      
      
      
      
      

      as
      

SELECT 
    id, 
    name, 
    value * 5 as quintupled_value
FROM raw_data
  