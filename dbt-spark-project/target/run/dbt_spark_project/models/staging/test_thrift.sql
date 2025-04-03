
  
    
        create table default.test_thrift
      
      
      
      
      
      
      
      

      as
      

CREATE TABLE default.test
USING jdbc
OPTIONS (
  url 'jdbc:oracle:thin:@10.14.223.202:1521/R18',
  dbtable 'metadata.test',
  user 'tafj',
  password 't24tafj',
  driver 'oracle.jdbc.OracleDriver'
)
  