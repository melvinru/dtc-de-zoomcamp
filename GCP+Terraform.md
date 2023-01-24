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
