from fastapi.testclient import TestClient
from unittest.mock import patch
import pytest
from app import app  # Here, we're importing 'app' from 'app.py'

client = TestClient(app)

def test_run_spark_job():
    """
    Test the API endpoint `/` to ensure it returns the expected response.
    """
    response = client.get("/")
    assert response.status_code == 200
    assert response.json() == {"message": ["Hello World"]}

def test_spark_session_initialization():
    """
    Mock the SparkSession builder to ensure it's called as expected without actually initializing a Spark session.
    """
    with patch('pyspark.sql.SparkSession.builder.getOrCreate') as mock_spark:
        response = client.get("/")
        assert response.status_code == 200  # Ensures the mock was used in processing the request
        mock_spark.assert_called_once()
