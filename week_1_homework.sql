--Question 1:  Knowing docker tags  ( Multiple choice)
--Which tag has the following text? - Write the image ID to the file
$ docker build --help
--> --iidfile string          Write the image ID to the file

--Question 2:  Understanding docker first run  (Multiple choice)
--How many python packages/modules are installed?
$ docker run -it python:3.9 bash
root@4d02cfb94d4c:/# pip list
-->Package    Version
-->pip        22.0.4
-->setuptools 58.1.0
-->wheel      0.38.4

--Question 3: Count records  (Multiple choice)
--How many taxi trips were totally made on January 15?
SELECT COUNT(1)
FROM PUBLIC.GREEN_TAXI_DATA G
WHERE LPEP_PICKUP_DATETIME BETWEEN '2019-01-15' AND '2019-01-15 23:59:59'
	AND LPEP_DROPOFF_DATETIME BETWEEN '2019-01-15' AND '2019-01-15 23:59:59'

--Question 4: Largest trip for each day (Multiple choice)
--Which was the day with the largest trip distance?
SELECT CAST(G.LPEP_PICKUP_DATETIME AS DATE) AS DAY,
	G.TRIP_DISTANCE
FROM PUBLIC.GREEN_TAXI_DATA G
WHERE G.TRIP_DISTANCE =
		(SELECT MAX(G.TRIP_DISTANCE)
			FROM PUBLIC.GREEN_TAXI_DATA G)

--Question 5: The number of passengers  (Multiple choice)
--In 2019-01-01 how many trips had 2 and 3 passengers?
SELECT G.PASSENGER_COUNT,
	COUNT(1)
FROM PUBLIC.GREEN_TAXI_DATA G
WHERE LPEP_PICKUP_DATETIME BETWEEN '2019-01-01' AND '2019-01-01 23:59:59'
	AND G.PASSENGER_COUNT in (2, 3)
GROUP BY 1

--Question 6: Largest tip (Multiple choice)
--For the passengers picked up in the Astoria Zone which was the drop up zone that had the largest tip?
SELECT G.INDEX,
	G.TIP_AMOUNT,
	Z."Zone",
	Z2."Zone"
FROM GREEN_TAXI_DATA G,
	ZONES Z,
	ZONES Z2
WHERE G."DOLocationID" = Z2."LocationID"
	AND G.TIP_AMOUNT =
		(SELECT MAX(G.TIP_AMOUNT)
			FROM GREEN_TAXI_DATA G
			WHERE G."PULocationID" = Z."LocationID"
				AND Z."LocationID" = 7)