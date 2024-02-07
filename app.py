from fastapi import FastAPI
from pyspark.sql import SparkSession

app = FastAPI()

@app.get("/")
async def run_spark_job():
    # Initialize a SparkSession
    spark = SparkSession.builder.appName("HelloWorldApp").getOrCreate()

    # Parallelize the 'Hello World' data and collect it
    data = ["Hello World"]
    rdd = spark.sparkContext.parallelize(data)
    result = rdd.collect()

    # Stop the SparkSession
    spark.stop()

    # Return the result to the web page
    return {"message": result}