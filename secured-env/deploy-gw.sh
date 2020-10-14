#!/bin/bash

RESOURCEGROUP=rg-gw-neu
GATEWAY=gw-neu
LOCATION=northeurope
VNET=vnet-gw-neu
PIP=ip-gw-neu


az group create --name $RESOURCEGROUP --location $LOCATION
az network vnet create \
  -n $VNET \
  -g $RESOURCEGROUP \
  -l $LOCATION \
  --address-prefix 10.1.0.0/16 \
  --subnet-name Frontend \
  --subnet-prefix 10.1.0.0/24
  
az network vnet subnet create \
  --vnet-name $VNET \
  -n GatewaySubnet \
  -g $RESOURCEGROUP \
  --address-prefix 10.1.255.0/27
  az network public-ip create \
  -n $PIP \
  -g $RESOURCEGROUP \
  --allocation-method Dynamic
  
  az network vnet-gateway create \
  -n $GATEWAY \
  -l $LOCATION \
  --public-ip-address $PIP \
  -g $RESOURCEGROUP \
  --vnet $VNET \
  --gateway-type Vpn \
  --sku VpnGw1 \
  --vpn-type RouteBased \
  --no-wait
