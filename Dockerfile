# Base Image OpenJDK 11 JRE Slim as Spark needs OpenJDK 8+
FROM openjdk:11-jre-slim

# Install Python, wget, and procps
RUN apt-get update && \
    apt-get install -y python3 python3-pip wget procps && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Variables for Spark Installation
ENV APACHE_SPARK_VERSION=3.5.0 \
    HADOOP_VERSION=3 \
    SPARK_HOME=/usr/local/spark

# Download and install Apache Spark
RUN wget -q https://dlcdn.apache.org/spark/spark-$APACHE_SPARK_VERSION/spark-$APACHE_SPARK_VERSION-bin-hadoop$HADOOP_VERSION.tgz -O /tmp/spark.tgz && \
    tar xzf /tmp/spark.tgz -C /usr/local && \
    rm /tmp/spark.tgz && \
    ln -s /usr/local/spark-$APACHE_SPARK_VERSION-bin-hadoop$HADOOP_VERSION $SPARK_HOME

# Add Spark to PATH
ENV PATH $PATH:$SPARK_HOME/bin

# Install FastAPI, Uvicorn, PySpark, and any other dependencies
RUN pip install fastapi uvicorn pyspark==$APACHE_SPARK_VERSION

# Set the working directory
WORKDIR /app

# Copy the current directory contents into the container
COPY . .

#Add authorisation
RUN chmod +x app.py

# Expose the port FastAPI will run on
EXPOSE 4040

# Command to run the Uvicorn server
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "4040"]

