FROM apache/airflow:2.10.5

# Switch to root to install system dependencies
USER root

# Install Java and wget
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget \
    && apt-get clean && rm -rf /var/lib/apt/lists/*


# Download and install OpenJDK 21 
RUN wget -qO /tmp/openjdk-21.tar.gz https://download.java.net/java/GA/jdk21/fd2272bbf8e04c3dbaee13770090416c/35/GPL/openjdk-21_linux-x64_bin.tar.gz \
    && mkdir -p /opt/jdk-21 \
    && tar -xzf /tmp/openjdk-21.tar.gz -C /opt/jdk-21 --strip-components=1 \
    && rm /tmp/openjdk-21.tar.gz \
    && update-alternatives --install /usr/bin/java java /opt/jdk-21/bin/java 1 \
    && update-alternatives --install /usr/bin/javac javac /opt/jdk-21/bin/javac 1

# Set up Spark 3.5.5
ENV SPARK_VERSION=3.5.5
ENV SPARK_HOME=/opt/spark
RUN wget -qO- https://downloads.apache.org/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop3.tgz | tar xvz -C /opt \
    && mv /opt/spark-${SPARK_VERSION}-bin-hadoop3 ${SPARK_HOME} \
    # grant airflow user permissions
    && chown -R 50000:50000 ${SPARK_HOME} \
    && chmod -R 755 ${SPARK_HOME}

# Add Spark to PATH
ENV PATH="${SPARK_HOME}/bin:${SPARK_HOME}/sbin:${PATH}"

# Install Oracle JDBC driver (ojdbc17)
RUN mkdir -p /opt/spark/jars \
    && wget -qO- https://download.oracle.com/otn-pub/otn_software/jdbc/237/ojdbc17.jar -O ${SPARK_HOME}/jars/ojdbc17.jar \
    && chown 50000:50000 /opt/spark/jars/ojdbc17.jar

# Create /home/airflow/.dbt and copy profiles.yml
RUN mkdir -p /home/airflow/.dbt \
&& chown 50000:50000 /home/airflow/.dbt
COPY --chown=50000:50000 profiles.yml /home/airflow/.dbt/profiles.yml

# Switch back to the airflow user
USER airflow

# Install DBT with Spark adapter
RUN pip install dbt-spark[PyHive]

# Copy DBT project and PySpark script
COPY --chown=airflow:airflow dbt-spark-project /dbt/dbt-spark-project
COPY --chown=airflow:airflow etl_to_oracle.py /spark/etl_to_oracle.py