
  
    
        create table default.source_oracle
      
      
      
      
      
      
      
      

      as
      

-- Tạo bảng tạm thời thay vì view
CREATE TABLE default.source_oracle_test
USING jdbc
OPTIONS (
  url 'jdbc:oracle:thin:@10.14.223.202:1521/R18',
  dbtable 'metadata.test',
  user 'tafj',
  password 't24tafj'
)
  