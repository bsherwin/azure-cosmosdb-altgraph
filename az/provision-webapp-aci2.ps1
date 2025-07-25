# az CLI script to create an Azure Container Instance (ACI) for the altgraph_web_app
# using Docker image cjoakim/azure-cosmosdb-altgraph-v2 at Docker Hub.
# See https://hub.docker.com/repository/docker/cjoakim/azure-cosmosdb-altgraph-v2
# Chris Joakim, Microsoft, March 2023

# Parameters - change these per your Azure environment
$subscription=$Env:AZURE_SUBSCRIPTION_ID
$resource_group='gbbcjaltgraph'
$resource_name='gbbcjaltgraph2'
$azure_location='eastus'

# Parameters - standard
$container_name="cjoakim/azure-cosmosdb-altgraph-v2:latest"

#echo 'logging in...'
#az login

echo "az account set to subscription: $subscription"
az account set --subscription $subscription

echo 'az account show...'
az account show

echo 'az container create...'
az container create `
    --resource-group $resource_group `
    --name  $resource_name `
    --image $container_name `
    --cpu   2 `
    --memory 8.0 `
    --dns-name-label $resource_name `
    --ports 8080 `
    --os-type Linux `
    --restart-policy Always `
    --environment-variables AZURE_REDISCACHE_HOST=$Env:AZURE_REDISCACHE_HOST  AZURE_REDISCACHE_PORT=$Env:AZURE_REDISCACHE_PORT  AZURE_REDISCACHE_KEY=$Env:AZURE_REDISCACHE_KEY  AZURE_COSMOSDB_NOSQL_URI=$Env:AZURE_COSMOSDB_NOSQL_URI  AZURE_COSMOSDB_NOSQL_RW_KEY1=$Env:AZURE_COSMOSDB_NOSQL_RW_KEY1  AZURE_COSMOSDB_NOSQL_DB=$Env:AZURE_COSMOSDB_NOSQL_DB  AZURE_COSMOSDB_NOSQL_MAX_DEG_PAR=-1  JAVA_OPTS='-Xms4096m -Xmx4096m'  > tmp\aci2_create.json

az container show --resource-group $resource_group --name $resource_name > tmp\aci2_show.json
