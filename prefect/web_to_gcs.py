from pathlib import Path
import os
import pandas as pd
import time
from google.cloud import storage

"""
Pre-reqs: 
1. `pip install pandas pyarrow google-cloud-storage`
2. Set GOOGLE_APPLICATION_CREDENTIALS to your project/service-account key
3. Set GCP_GCS_BUCKET as your bucket or change default value of BUCKET
"""

# services = ['fhv','green','yellow']
init_url = 'https://github.com/DataTalksClub/nyc-tlc-data/releases/download/'
# switch out the bucketname
BUCKET = os.environ.get("GCP_GCS_BUCKET", "dtc_data_lake_totemic-guild-375112")

def fetch(request_url: str) -> pd.DataFrame:
    start = time.time()
    # download it using requests via a pandas df
    os.system('wget ' + request_url)
    end = time.time()
    print(f'download in {end - start} seconds')
    df = pd.read_csv(request_url, compression='gzip')
    return df

def clean(df: pd.DataFrame, service: str) -> pd.DataFrame:
    """Fix dtype issues"""
    if service == "yellow":
        df["tpep_pickup_datetime"] = pd.to_datetime(df["tpep_pickup_datetime"])
        df["tpep_dropoff_datetime"] = pd.to_datetime(df["tpep_dropoff_datetime"])
    if service == "green":
        df["lpep_pickup_datetime"] = pd.to_datetime(df["lpep_pickup_datetime"])
        df["lpep_dropoff_datetime"] = pd.to_datetime(df["lpep_dropoff_datetime"])
        df["trip_type"] = df["trip_type"].astype('Int64')
    if service == "yellow" or service == "green":
        df["VendorID"] = df["VendorID"].astype('Int64')
        df["RatecodeID"] = df["RatecodeID"].astype('Int64')
        df["PULocationID"] = df["PULocationID"].astype('Int64')
        df["DOLocationID"] = df["DOLocationID"].astype('Int64')
        df["passenger_count"] = df["passenger_count"].astype('Int64')
        df["payment_type"] = df["payment_type"].astype('Int64')
    print(df.head(2))
    print(f"columns: {df.dtypes}")
    print(f"rows: {len(df)}")
    return df

def write_local(service: str, df: pd.DataFrame, dataset_file: str) -> Path:
    """Write DataFrame out locally as csv file"""
    # read it back into a parquet file
    df = pd.read_csv(dataset_file)
    dataset_file = dataset_file.replace('.csv.gz', '.parquet')
    df.to_parquet(dataset_file, compression="gzip", engine='pyarrow')
    print(f"Parquet: {dataset_file}")
    return dataset_file

def upload_to_gcs(bucket, object_name, local_file):
    """Ref: https://cloud.google.com/storage/docs/uploading-objects#storage-upload-object-python"""
    # # WORKAROUND to prevent timeout for files > 6 MB on 800 kbps upload speed.
    # # (Ref: https://github.com/googleapis/python-storage/issues/74)
    # storage.blob._MAX_MULTIPART_SIZE = 5 * 1024 * 1024  # 5 MB
    # storage.blob._DEFAULT_CHUNKSIZE = 5 * 1024 * 1024  # 5 MB

    client = storage.Client()
    bucket = client.bucket(bucket)
    blob = bucket.blob(object_name)
    blob.upload_from_filename(local_file)

def web_to_gcs(service, year):
    for i in range(12):
        # sets the month part of the file_name string
        month = '0'+str(i+1)
        month = month[-2:]
        dataset_file = service + '_tripdata_' + year + '-' + month + '.csv.gz'
        print(f"Local: {dataset_file }")
        dataset_url = init_url + service + '/' + dataset_file 
        print(f"Link: {dataset_url}")    

        df = fetch(dataset_url)
        df_clean = clean(df, service)

        dataset_file = write_local(service, df_clean, dataset_file)

        upload_to_gcs(BUCKET, f"data/{service}/{dataset_file}", dataset_file )
        print(f"GCS: data/{service}/{dataset_file }") 

# web_to_gcs('green', '2019')
# web_to_gcs('green', '2020')
web_to_gcs('yellow', '2019')
# web_to_gcs('yellow', '2020')