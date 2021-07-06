az vm show \
  --name myVM \
  --resource-group f31193bc-7f3e-4509-b17f-2f56b4c75420 \
  --show-details \
  --query [publicIps] \
  --output tsv
