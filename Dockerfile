# Base Image OpenJDK 11 JRE Slim as Spark need OpenJDK 8+
FROM openjdk:11-jre-slim

# Install Python, wget, and procps
RUN apt-get update && \
    apt-get install -y python3 python3-pip wget procps && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Create symbolic links to ensure that it will use pip3
RUN ln -s /usr/bin/python3 /usr/local/bin/python && \
    ln -s /usr/bin/pip3 /usr/local/bin/pip

#Variables for Spark Installation
ENV APACHE_SPARK_VERSION=3.3.4 \
    HADOOP_VERSION=3 \
    SPARK_HOME=/usr/local/spark

# Download and install Apache Spark
RUN wget -q https://dlcdn.apache.org/spark/spark-$APACHE_SPARK_VERSION/spark-$APACHE_SPARK_VERSION-bin-hadoop$HADOOP_VERSION.tgz -O /tmp/spark.tgz && \
    tar xzf /tmp/spark.tgz -C /usr/local && \
    rm /tmp/spark.tgz && \
    ln -s /usr/local/spark-$APACHE_SPARK_VERSION-bin-hadoop$HADOOP_VERSION $SPARK_HOME

# Add Spark to PATH
ENV PATH $PATH:$SPARK_HOME/bin

# Install PySpark and complementary modules
RUN pip install pyspark==$APACHE_SPARK_VERSION pyspark[sql] pyspark[pandas_on_spark] plotly pyspark[connect] flask gunicorn

# Creation of the working directory app
RUN mkdir -p /app
    
# Set of the working directory
WORKDIR /app

# Copy the current directory contents into the container at /home/p2r/studi2
COPY . .

#Give permissions
RUN chmod +x app.py

# Make port 4040 available to the world outside this container
EXPOSE 4040

#Exec python app and wrap it
CMD ["gunicorn", "--bind", ":4040", "--workers", "3", "app:app" ]
