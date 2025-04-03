import os
from pyspark.sql import SparkSession

# Load environment variables

# Get variables from .env file
oracle_host = "10.14.223.202"
oracle_port = 1521
oracle_sid = "R18"
oracle_user = "tafj"
oracle_password = "t24tafj"
spark_jars_path = "/opt/spark/jars/ojdbc17.jar"
spark_warehouse_dir = "/opt/spark/spark-warehouse"
spark_catalog_implementation = "hive"

# Initialize SparkSession
spark = SparkSession.builder \
    .appName("ETL Spark to Oracle") \
    .config("spark.jars", spark_jars_path) \
    .config("spark.sql.warehouse.dir", spark_warehouse_dir) \
    .config("spark.sql.catalogImplementation", spark_catalog_implementation) \
    .getOrCreate()

# Construct the JDBC URL
jdbc_url = f"jdbc:oracle:thin:@{oracle_host}:{oracle_port}/{oracle_sid}"
connection_properties = {
    "user": oracle_user,
    "password": oracle_password,
    "driver": "oracle.jdbc.driver.OracleDriver"
}

# Define the table mappings (source -> target)
table_mappings = {
    "default.transformed_data": "METADATA.TEST",
    "default.transformed_data2": "METADATA.TEST2",
    "default.transformed_data3": "METADATA.TEST3",
    "default.transformed_data4": "METADATA.TEST4",
    "default.transformed_data5": "METADATA.TEST5"
}

# Process each table pair
for source_table, target_table in table_mappings.items():
    print(f"Processing table {source_table} to {target_table}")
    
    # Read data from the source table
    df = spark.sql(f"SELECT * FROM {source_table};")
    
    # Write data to the Oracle table
    df.write.jdbc(
        url=jdbc_url,
        table=target_table,
        mode="append",
        properties=connection_properties
    )
    
    print(f"Data successfully written to {target_table}")
    
    # Drop the source table on thrift
    spark.sql(f"DROP TABLE {source_table};")

# Stop the SparkSession
spark.stop()