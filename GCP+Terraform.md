#### Now we need to point it to correct Python installation. Assuming you use Anaconda:
> export CLOUDSDK_PYTHON=c:/Soft/Python/python
#### Now let's check that it works:
> gcloud version
#### Google Cloud SDK Authentication
> export GOOGLE_APPLICATION_CREDENTIALS=C:/Projects/dtc-de-zoomcamp/google-cloud-sdk/totemic-guild-ny-taxi.json
#### Authentication
- Now authenticate:
> gcloud auth activate-service-account --key-file $GOOGLE_APPLICATION_CREDENTIALS
- Alternatively, you can authenticate using OAuth like shown in the video
> gcloud auth application-default login


Hi there. I had the same problem doing
>conda install -c conda-forge opencv

It gave the error:
Solving environment: failed with initial frozen solve. Retrying with flexible solve,
and loaded forever. I managed to fix the problem. First, I created an environment called opencv using
>conda create -n opencv

I then activated it:
>conda activate opencv

and downloaded an earlier version using a different command:
>conda install -c anaconda opencv

This gave me opencv 3, not the most recent 4. I then created a second environment called opencv4. Use above code to create and activate. I finally did the standard download:
>conda install -c conda-forge opencv

 pgcli -h localhost -p 5432 -u root -d ny_taxi
 
