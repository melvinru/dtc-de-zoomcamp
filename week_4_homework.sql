SELECT COUNT(*) FROM `totemic-guild-375112.dbt_melvin_prod.fact_trips`
WHERE EXTRACT(YEAR FROM pickup_datetime) IN (2019, 2020)
/
{{ config(materialized='view') }}

with tripdata as 
(
  select *,
    row_number() over(partition by dispatching_base_num, pickup_datetime) as rn
  from {{ source('staging','fhv_tripdata') }}
  where dispatching_base_num is not null 
)
select
    -- identifiers
    {{ dbt_utils.surrogate_key(['dispatching_base_num', 'pickup_datetime']) }} as tripid,
    cast(dispatching_base_num as string) as vendorid,
    cast(pulocationid as integer) as  pickup_locationid,
    cast(dolocationid as integer) as dropoff_locationid,

    -- timestamps
    cast(pickup_datetime as timestamp) as pickup_datetime,
    cast(dropoff_datetime as timestamp) as dropoff_datetime,

    -- trip info
    sr_flag,
from {{ source('staging','fhv_tripdata') }}
where dispatching_base_num is not null 

{% if var('is_test_run', default=true) %}

    limit 100

{% endif %}
/
SELECT count(*) FROM `totemic-guild-375112.dbt_melvin_dev.stg_fhv_tripdata`
where extract(year from pickup_datetime) in (2019)
/
{ config(materialized='table') }}

WITH
fhv_data as (
    select * from {{ ref('stg_fhv_tripdata') }}
),

dim_zones as (
    select * from {{ ref('dim_zones') }}
    where borough != 'Unknown'
)
SELECT
    fhv_data.tripid,
    fhv_data.vendorid,
    fhv_data.pickup_locationid,
    pickup_zone.borough as pickup_borough, 
    pickup_zone.zone as pickup_zone,
    fhv_data.dropoff_locationid,
    dropoff_zone.borough as dropoff_borough, 
    dropoff_zone.zone as dropoff_zone,
    fhv_data.pickup_datetime, 
    fhv_data.dropoff_datetime,
    fhv_data.sr_flag
from fhv_data
inner join dim_zones as pickup_zone
on fhv_data.pickup_locationid = pickup_zone.locationid
inner join dim_zones as dropoff_zone
on fhv_data.dropoff_locationid = dropoff_zone.locationid
/
SELECT count(*) FROM `totemic-guild-375112.dbt_melvin_dev.fact_trips`
where extract(year from pickup_datetime) in (2019)
/
