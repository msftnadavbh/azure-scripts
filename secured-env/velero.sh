## Install velero from :
## https://velero.io/
## move velero to /usr/local/bin

# name of the Storage where storage container is
export AZURE_STORAGE_ACCOUNT_ID="velerobackup"
# Name of the storage account's Resource Group
export RG="backup"    
# name of your backup container
export BLOB_CONTAINER="aks-backup"
# AKS Node Resource Group
AZURE_RESOURCE_GROUP=$(az aks show --query nodeResourceGroup --name <AKS-CLUSTER-NAME> --resource-group <AKS-CLUSTERS-RESOURCE-GROUP> --output tsv)
# Azures subscription ID you are working in
AZURE_SUBSCRIPTION_ID=$(az account list --query '[?isDefault].id' -o tsv)
# Azures Tenant ID
AZURE_TENANT_ID=$(az account list --query '[?isDefault].tenantId' -o tsv)


# get service principle password
AZURE_CLIENT_SECRET=$(az ad sp create-for-rbac -n $AZURE_STORAGE_ACCOUNT_ID --role contributor --query password --output tsv)
# get service principles ID
AZURE_CLIENT_ID=$(az ad sp show --id http://$AZURE_STORAGE_ACCOUNT_ID --query appId --output tsv)


echo AZURE_SUBSCRIPTION_ID=$AZURE_SUBSCRIPTION_ID > credentials-velero
echo AZURE_TENANT_ID=$AZURE_TENANT_ID >> credentials-velero
echo AZURE_CLIENT_ID=$AZURE_CLIENT_ID >> credentials-velero
echo AZURE_CLIENT_SECRET=$AZURE_CLIENT_SECRET >> credentials-velero
echo AZURE_RESOURCE_GROUP=$AZURE_RESOURCE_GROUP >> credentials-velero

# Install Velero
velero install \
--provider azure \
--plugins velero/velero-plugin-for-microsoft-azure:v1.0.1 \
--bucket $BLOB_CONTAINER \
--secret-file ./credentials-velero \
--backup-location-config resourceGroup=$RG,storageAccount=$AZURE_STORAGE_ACCOUNT_ID,subscriptionId=$AZURE_SUBSCRIPTION_ID \
--snapshot-location-config resourceGroup=$RG,subscriptionId=$AZURE_SUBSCRIPTION_ID

# Test the backup
velero backup create [name] --selector [label]

# Get existing backups
velero get backup

# Daily Backup
velero create schedule daily --selector backup=yes --schedule="@every 24h"
