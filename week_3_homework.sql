-- Question 1: What is count for fhv vehicle records for year 2019?
SELECT
  COUNT(1)
FROM
  `totemic-guild-375112.nytaxi.external_tripdata`;
-- The answer is 43,244,696

-- Question 2: What is the estimated amount of data that will be read when you execute your query on the External Table and the Materialized Table?
-- Query for External taable
SELECT
  COUNT(DISTINCT affiliated_base_number)
FROM
  `totemic-guild-375112.nytaxi.external_tripdata`;
-- External table: 0 B

-- Query for Materialized taable
SELECT
  COUNT(DISTINCT affiliated_base_number)
FROM
  `totemic-guild-375112.nytaxi.material_tripdata`;
-- Materialized table: 317.94 MB

-- Question 3: How many records have both a blank (null) PUlocationID and DOlocationID in the entire dataset?
SELECT
  COUNT(1)
FROM
  'totemic-guild-375112.nytaxi.material_tripdata'
WHERE PUlocationID IS NULL
  AND DOlocationID IS NULL
-- The answer is 717,748

-- Question 4: What is the best strategy to make an optimized table in Big Query if your query will always filter by pickup_datetime and order by affiliated_base_number?
CREATE OR REPLACE TABLE `totemic-guild-375112.nytaxi.partitioned_tripdata`
PARTITION BY DATE( pickup_datetime )
CLUSTER BY affiliated_base_number AS
SELECT * FROM `totemic-guild-375112.nytaxi.material_tripdata`
-- The answer is Partition by pickup_datetime Cluster on affiliated_base_number

-- Question 5:
-- Write a query to retrieve the distinct affiliated_base_number between pickup_datetime
-- 03/01/2019 and 03/31/2019 (inclusive)
-- Use the materialized table you created earlier in your from clause and note the estimated bytes.
-- Now change the table in the from clause to the partitioned table you created for question 4 and note the estimated bytes processed. What are these values?

-- Query for Materialized taable
SELECT
  COUNT(DISTINCT affiliated_base_number)
FROM
  `totemic-guild-375112.nytaxi.material_tripdata`
WHERE DATE(pickup_datetime) BETWEEN '2019-03-01' and '2019-03-31';
-- The answer is 647.87 MB
-- Query for Partitioned taable
SELECT
  COUNT(DISTINCT affiliated_base_number)
FROM
  `totemic-guild-375112.nytaxi.partitioned_tripdata`
WHERE DATE(pickup_datetime) BETWEEN '2019-03-01' and '2019-03-31';
-- The answer is 23.06 MB

-- Question 6: Where is the data stored in the External Table you created?
-- dtc_data_lake_totemic-guild-375112/data
-- The answer is GCP Bucket

-- Question 7: It is best practice in Big Query to always cluster your data.
-- The answer is False