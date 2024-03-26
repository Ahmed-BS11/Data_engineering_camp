-- Create a non partitioned table from external table
CREATE OR REPLACE TABLE data-engineering-417912.ny_taxi.yellow_tripdata_non_partitioned AS
SELECT * FROM data-engineering-417912.ny_taxi.yellow_taxi_data;

-- Create a partitioned table from external table
CREATE OR REPLACE TABLE data-engineering-417912.ny_taxi.yellow_tripdata_partitioned 
PARTITION BY 
  DATE(tpep_pickup_datetime) AS
SELECT * FROM data-engineering-417912.ny_taxi.yellow_taxi_data;

-- QUERY THE NON PARTITIONED TABLE 
-- This query will process 18.99 MB when run.
SELECT DISTINCT(VendorID)
FROM data-engineering-417912.ny_taxi.yellow_tripdata_non_partitioned
WHERE DATE(tpep_pickup_datetime) BETWEEN '2021-01-01' AND '2021-01-15';

-- QUERY THE PARTITIONED TABLE 
-- This query will process 8.99 MB when run.
SELECT DISTINCT(VendorID)
FROM data-engineering-417912.ny_taxi.yellow_tripdata_partitioned
WHERE DATE(tpep_pickup_datetime) BETWEEN '2021-01-01' AND '2021-01-15';

-- Let's take a look into the partitions
SELECT table_name, partition_id, total_rows
FROM `ny_taxi.INFORMATION_SCHEMA.PARTITIONS`
WHERE table_name = 'yellow_tripdata_partitioned'
ORDER BY total_rows DESC;

-- Create a clustered table 
CREATE OR REPLACE TABLE data-engineering-417912.ny_taxi.yellow_tripdata_clustered
PARTITION BY 
  DATE(tpep_pickup_datetime) 
CLUSTER BY VendorID AS
SELECT * FROM data-engineering-417912.ny_taxi.yellow_taxi_data;

# PARTITIONED ONLY
-- This query will process 8.99mb when run.
SELECT count(*) as trips
FROM data-engineering-417912.ny_taxi.yellow_tripdata_partitioned 
WHERE DATE(tpep_pickup_datetime) BETWEEN '2021-01-01' AND '2021-01-15'
  AND VendorID=1;

# PARTITIONED AND CLUSTERED
-- Query scans 8.51 MB
SELECT count(*) as trips
FROM data-engineering-417912.ny_taxi.yellow_tripdata_clustered
WHERE DATE(tpep_pickup_datetime) BETWEEN '2021-01-01' AND '2021-01-15'
  AND VendorID=1;


