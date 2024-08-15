# github-workload-identity

https://github.com/google-github-actions/auth
https://cloud.google.com/iam/docs/workload-identity-federation
https://cloud.google.com/blog/products/identity-security/enable-keyless-access-to-gcp-with-workload-identity-federation?utm_source=youtube&utm_medium=unpaidsoc&utm_campaign=CDR_ret_security_4vajaxzhn08_WorkloadIdentityFederation_042721&utm_content=description
https://cloud.google.com/iam/docs/workload-identity-federation#mapping




------------------------------------------------------------------------------------------------------------

Step 1: Create a Workload Identity Pool
gcloud iam workload-identity-pools create github-workload-identity-pool \
    --location="global" \
    --description="github workload identity pool" \
    --display-name="gihub workload identity pool"


gcloud iam workload-identity-pools list --location="global"


gcloud iam workload-identity-pools delete github-workload-identity-pool  --location="global" 

gcloud iam workload-identity-pools undelete github-workload-identity-pool  --location="global"

----------------------------------------------------------------------------------------------------------


Step 2: Add an Identity Provider
gcloud iam workload-identity-pools providers create-oidc "github-actions-oidc" \
  --project="raysainiz" \
  --location="global" \
  --workload-identity-pool="github-workload-identity-pool" \
  --display-name="My GitHub repo Provider" \
  --attribute-mapping="google.subject=assertion.sub,attribute.actor=assertion.actor,attribute.repository=assertion.repository,attribute.repository_owner=assertion.repository_owner,attribute.branch=assertion.sub.extract('/heads/{branch}/')" \
  --issuer-uri="https://token.actions.githubusercontent.com" \
  --attribute-condition="assertion.repository_owner=='learnwithray/'"


gcloud iam workload-identity-pools providers list --project="raysainiz" --location="global" --workload-identity-pool="github-workload-identity-pool"



  gcloud iam workload-identity-pools providers update-oidc "github-actions-oidc" \
  --project="raysainiz" \
  --location="global" \
  --workload-identity-pool="github-workload-identity-pool" \
  --attribute-mapping="attribute.actor=assertion.actor,google.subject=assertion.sub,attribute.repository=assertion.repository,attribute.aud=assertion.aud,attribute.repository_owner=assertion.repository_owner" \
  --attribute-condition="assertion.repository=='learnwithray/github-workload-identity'"


gcloud iam workload-identity-pools providers delete "github-actions-oidc" \
  --project="raysainiz" \
  --location="global" \
  --workload-identity-pool="github-workload-identity-pool"



gcloud iam workload-identity-pools providers undelete "github-actions-oidc" \
  --project="raysainiz" \
  --location="global" \
  --workload-identity-pool="github-workload-identity-pool"



------------------------------------------------------------------------------------------------------------

Step 3: Create a service account for each repository and assign them appropriate IAM permissions

### Create 
gcloud iam service-accounts create github-workload-identity-sa --display-name="github workload identity Service Account" --description="github workload identity for application resources"

gcloud projects add-iam-policy-binding raysainiz \
    --member="serviceAccount:github-workload-identity-sa@raysainiz.iam.gserviceaccount.com" \
    --role="roles/storage.admin"

gcloud projects add-iam-policy-binding raysainiz \
    --member="serviceAccount:github-workload-identity-sa@raysainiz.iam.gserviceaccount.com" \
    --role="roles/iam.workloadIdentityUser"


gcloud iam service-accounts add-iam-policy-binding github-workload-identity-sa@raysainiz.iam.gserviceaccount.com \
  --project="raysainiz" \
  --role="roles/iam.workloadIdentityUser" \
  --member="principalSet://iam.googleapis.com/projects/<PROJECT_NUMBER>/locations/global/workloadIdentityPools/github-workload-identity-pool/attribute.repository/learnwithray/github-workload-identity"



### Delete

gcloud projects remove-iam-policy-binding raysainiz \
    --member="serviceAccount:github-workload-identity-sa@raysainiz.iam.gserviceaccount.com" \
    --role="roles/storage.admin"

gcloud projects remove-iam-policy-binding raysainiz \
    --member="serviceAccount:github-workload-identity-sa@raysainiz.iam.gserviceaccount.com" \
    --role="roles/iam.workloadIdentityUser"

gcloud iam service-accounts remove-iam-policy-binding github-workload-identity-sa@raysainiz.iam.gserviceaccount.com \
    --role="roles/iam.workloadIdentityUser" \
    --member="principalSet://iam.googleapis.com/projects/<PROJECT_NUMBER>/locations/global/workloadIdentityPools/github-workload-identity-pool/attribute.repository/learnwithray/github-workload-identity"



gcloud iam service-accounts delete github-workload-identity-sa@raysainiz.iam.gserviceaccount.com

------------------------------------------------------------------------------------------------------------


gcloud iam service-accounts add-iam-policy-binding github-workload-identity-sa@raysainiz.iam.gserviceaccount.com \
  --project="raysainiz" \
  --role="roles/iam.workloadIdentityUser" \
  --member="principalSet://iam.googleapis.com/projects/<PROJECT_NUMBER>/locations/global/workloadIdentityPools/github-workload-identity-pool/attribute.repository/learnwithray/github-workload-identity"




https://iam.googleapis.com/projects/<PROJECT_NUMBER>/locations/global/workloadIdentityPools/github-workload-identity-pool/providers/github-actions-oidc