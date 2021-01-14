#!/bin/bash

## Optional - using a user delegated SAS [more secure] 

## Run one time :

# az role assignment create --role "Storage Blob Data Contributor" --assignee [email or principal] --scope "/subscriptions/subID/resourcegroups/resourcegroup/providers/Microsoft.Storage/storageAccounts/storageaccount"


# Then change the "SAS_TOKEN" parameter below to this :

# SAS_TOKEN=$(az storage container generate-sas --account-name $ACCOUNT_NAME --name $CONTAINER --permissions acdlrw --expiry 2021-01-14T07:00:00Z --auth-mode login --as-user)

# Main Script

ACCOUNT_NAME="storagename"
SAS_TOKEN="SASTOKEN"
CONTAINER="storagecontainer"

# Create a directory to store all the blobs
mkdir ~/downloaded-container && cd ~/downloaded-container

# Download all blobs

az storage blob download-batch -d . --account-name $ACCOUNT_NAME -s $CONTAINER --sas-token $SAS_TOKEN