Cài đặt airflow:
`pip3 install apache-airflow`

Thiết lập biến môi trường:
`export AIRFLOW_HOME=~/airflow`

Khỏi tạo DB:
`airflow db init`

Khỏi tạo người dùng, webserver và scheduler
```
airflow webserver --port 8080
airflow users create     --username admin     --firstname Admin     --lastname User     --role Admin     --email abc@example.com
airflow webserver -D
```

Dags nằm ở $AIRFLOW_HOME/dags -> tạo dags ở folder này

Cài đặt dbt-spark
```
pip install dbt-spark
dbt init dbt_spark_project
```

-> chọn adapter spark

giải nén spark và di chuyển thư mục opt/spark

```
wget https://downloasparkds.apache.org/spark/sparsparkk-3.5.5/spark-3.5.5-bin-hadoop3.tgz
tar -xzf spark-3.5.5-bin-hadoop3.tgz
sudo mv spark-3.5.5-bin-hadoop3 /opt/spark
```


Tải và giải nén ojdbc17 vào /opt/spark

```
wget https://download.oracle.com/otn-pub/otn_software/jdbc/237/ojdbc17.jar
sudo cp ojdbc17.jar /opt/spark/jars/
```

Chạy thrift server

`/opt/spark/sbin/start-thriftserver.sh --master local[*] --hiveconf hive.metastore.warehouse.dir=/opt/spark/spark-warehouse --hiveconf javax.jdo.option.ConnectionURL="jdbc:derby:;databaseName=/opt/spark/metastore_db;create=true"`

Viết models trên dbt -> tạo các bảng mới với dữ liệu được transform trên thrift
Chạy mô hình dbt

`dbt run`

![Description](https://github.com/nguyenminh1905/Pipeline-etl-dbt-spark-oracle/blob/main/images/Pasted%20image%2020250326145057.png?raw=true)

Đăng nhập airflow qua
`http://localhost:8080/home`

Tìm trigger dag etl_dbt_spark_oracle, dags bao gồm 2 tasks run dbt, và load_to oracle, chạy bằng BashOperator

![Description](https://github.com/nguyenminh1905/Pipeline-etl-dbt-spark-oracle/blob/main/images/Pasted%20image%2020250326152012.png?raw=true)

Tạo folder spark viết code spark để load dữ liệu lên các bảng tại oracle

`mkdir -p ~/Desktop/spark`

Dừng thrift server để chạy code spark

`/opt/spark/sbin/stop-thriftserver.sh

Chạy code spark để load dữ liệu lên các bảng trên oracle: 

`cd /opt/spark && spark-submit ~/Desktop/spark/etl_to_oracle.py`

Dữ liệu table trên thrift sẽ được xóa và dữ liệu được load lên oracle, các bảng test -> test6 có các dữ liệu

![Description](https://github.com/nguyenminh1905/Pipeline-etl-dbt-spark-oracle/blob/main/images/Pasted%20image%2020250326150634.png?raw=true)

Các bảng transform được  xóa đi trên thrift

![[Pasted image 20250326150821.png]]


Tạo một bảng trên thrift server có kết nối với oracle db -> khi dữ liệu được sửa trên thrift -> dữ liệu trên oracle cũng được sửa và ngược lại

```
CREATE TABLE default.test2
USING jdbc
OPTIONS (
url 'jdbc:oracle:thin:@10.14.223.202:1521/R18',
dbtable 'metadata.test2',
user 'tafj',
password 't24tafj',
driver 'oracle.jdbc.OracleDriver'
)
```

Insert giá trị vào bảng test2 trên thrift
![Description](https://github.com/nguyenminh1905/Pipeline-etl-dbt-spark-oracle/blob/main/images/Pasted%20image%2020250326151258.png?raw=true)
Khi query trên oracle

![Description](
https://github.com/nguyenminh1905/Pipeline-etl-dbt-spark-oracle/blob/main/images/Pasted%20image%2020250326151339.png?raw=true)
