-- Sử dụng External Table để đọc dữ liệu từ Oracle
CREATE EXTERNAL TABLE IF NOT EXISTS metadata.test (
    id INT,
    name STRING,
    doubled_value INT
)
USING JDBC
OPTIONS (
    url 'jdbc:oracle:thin:@10.14.223.202:1521/R18',
    dbtable 'METADATA.TEST',
    user 'tafj',
    password 't24tafj',
    driver 'oracle.jdbc.driver.OracleDriver'
)