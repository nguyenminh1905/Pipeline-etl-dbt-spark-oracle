from airflow import DAG
from airflow.operators.bash import BashOperator
from datetime import datetime, timedelta

# Default arguments for the DAG
default_args = {
    'owner': 'airflow',
    'start_date': datetime(2025, 3, 19),
}

# Define the DAG
dag = DAG(
    'etl_dbt_spark_oracle',
    default_args=default_args,
    description='ETL pipeline with DBT and Spark to Oracle',
    schedule_interval='@daily',
    catchup=False,
)

# Task 1: Run DBT to push data to Thrift
dbt_run = BashOperator(
    task_id='dbt_run',
    bash_command="""cd /dbt/dbt-spark-project && /opt/spark/sbin/start-thriftserver.sh --master local[*] --hiveconf hive.metastore.warehouse.dir=/opt/spark/spark-warehouse --hiveconf javax.jdo.option.ConnectionURL="jdbc:derby:;databaseName=/opt/spark/metastore_db;create=true" && dbt seed && sleep 10 && dbt run""",
    dag=dag,
)

# Task 2: Run PySpark script to load data to Oracle
spark_load_to_oracle = BashOperator(
    task_id='spark_load_to_oracle',
    bash_command="""cd /opt/spark && /opt/spark/sbin/stop-thriftserver.sh && spark-submit /spark/etl_to_oracle.py""",
    dag=dag,
)

# Set task dependencies
dbt_run >> spark_load_to_oracle