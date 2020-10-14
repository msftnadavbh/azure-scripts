#!/bin/bash

RESOURCEGROUP=rg-aks-neu
LOCATION=northeurope
AKS=aks-neu
VNET=vnet-aks-neu


az group create -l $LOCATION -n $RESOURCEGROUP

az network vnet create \
--resource-group $RESOURCEGROUP \
--name $VNET \
--address-prefixes 172.16.0.0/16

az network vnet subnet create \
--resource-group $RESOURCEGROUP \
--vnet-name $VNET \
--name aks-vnet-subnet \
--address-prefixes 172.16.0.0/16 \
--service-endpoints Microsoft.ContainerRegistry


SUBNET_ID=$(az network vnet subnet show -n aks-vnet-subnet -g $RESOURCEGROUP --vnet-name $VNET --query id)

az aks create \
    --resource-group $RESOURCEGROUP \
    --name $AKS \
    --load-balancer-sku standard \
    --enable-private-cluster \
    --network-plugin azure \
    --vnet-subnet-id $SUBNET_ID \
    --node-count 2 \
    --kubernetes-version 1.17.9 \
    --docker-bridge-address 172.17.0.1/16 \
    --dns-service-ip 10.2.0.10 \
    --service-cidr 10.2.0.0/24 \
    --no-wait
