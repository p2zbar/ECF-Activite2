from flask import Flask
from pyspark.sql import SparkSession

app = Flask(__name__)

@app.route('/')
def run_spark_job():
    # Initialize a SparkSession
    spark = SparkSession.builder.appName("HelloWorldApp").getOrCreate()

    # Parallelize the 'Hello World' data and collect it
    data = ["Hello World"]
    rdd = spark.sparkContext.parallelize(data)
    result = rdd.collect()

    # Stop the SparkSession
    spark.stop()

    # Return the result to the web page
    return '<br>'.join(result)

if __name__ == '__main__':
    app.run(debug=True)
