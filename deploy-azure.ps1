# ==============================================================================
# Waitaminute Digital - Production Azure Deployment Pipeline (PowerShell)
# ==============================================================================

$ErrorActionPreference = "Stop"

$RESOURCE_GROUP = if ($env:AZURE_RESOURCE_GROUP) { $env:AZURE_RESOURCE_GROUP } else { "WMDpy-Core-RG" }
$LOCATION = if ($env:AZURE_LOCATION) { $env:AZURE_LOCATION } else { "eastus2" }
$PG_SERVER = if ($env:AZURE_PG_SERVER) { $env:AZURE_PG_SERVER } else { "waitaminuteserverpod" }
$DB_NAME = if ($env:AZURE_DB_NAME) { $env:AZURE_DB_NAME } else { "waitaminute_serverpod" }
$PG_USER = if ($env:AZURE_PG_USER) { $env:AZURE_PG_USER } else { "dunanhugh" }
$ACR_NAME = if ($env:AZURE_ACR_NAME) { $env:AZURE_ACR_NAME } else { "wmdacr2026" }
$PLAN_NAME = if ($env:AZURE_PLAN_NAME) { $env:AZURE_PLAN_NAME } else { "waitaminute-plan" }
$APP_NAME = if ($env:AZURE_APP_NAME) { $env:AZURE_APP_NAME } else { "waitaminute-web-prod" }
$DOCKERFILE = "waitaminute_serverpod/waitaminute_serverpod_server/Dockerfile"

$DB_PASSWORD = if ($env:SERVERPOD_PASSWORD_database) { $env:SERVERPOD_PASSWORD_database } else { "rDLAAJVA1-rCeFY8wcIGzBKAxAAdMHny" }
$SERVICE_SECRET = if ($env:SERVERPOD_PASSWORD_serviceSecret) { $env:SERVERPOD_PASSWORD_serviceSecret } else { "waitaminutedigital_service_secret_2026_prod" }

Write-Host "======================================================================" -ForegroundColor Cyan
Write-Host " Waitaminute Digital - Azure Deployment Pipeline" -ForegroundColor Cyan
Write-Host " Resource Group:  $RESOURCE_GROUP"
Write-Host " Location:        $LOCATION"
Write-Host " Postgres Server: $PG_SERVER"
Write-Host " Database:        $DB_NAME"
Write-Host " Postgres User:   $PG_USER"
Write-Host " ACR Registry:    $ACR_NAME"
Write-Host " App Service:     $APP_NAME"
Write-Host " Service Plan:    $PLAN_NAME (Linux B1)"
Write-Host " Dockerfile:      $DOCKERFILE"
Write-Host "======================================================================" -ForegroundColor Cyan

# 1. Check Azure authentication
Write-Host "==> Step 1: Checking Azure authentication..." -ForegroundColor Yellow
az account show --output table

# 2. Verify Postgres Server Status
Write-Host "==> Step 2: Verifying PostgreSQL server status ($PG_SERVER)..." -ForegroundColor Yellow
$pgState = az postgres flexible-server show --resource-group $RESOURCE_GROUP --name $PG_SERVER --query state -o tsv
Write-Host "    Postgres server ($PG_SERVER) is $pgState!"

$PGHOST = az postgres flexible-server show --resource-group $RESOURCE_GROUP --name $PG_SERVER --query fullyQualifiedDomainName -o tsv
if (-not $PGHOST) {
    $PGHOST = "$PG_SERVER.postgres.database.azure.com"
}
Write-Host "    Resolved Postgres host: $PGHOST"

# 3. Ensure database exists
Write-Host "==> Step 3: Ensuring database '$DB_NAME' exists on Postgres server..." -ForegroundColor Yellow
$dbExists = az postgres flexible-server db show --resource-group $RESOURCE_GROUP --server-name $PG_SERVER --database-name $DB_NAME 2>$null
if (-not $dbExists) {
    Write-Host "    Creating database '$DB_NAME'..."
    az postgres flexible-server db create --resource-group $RESOURCE_GROUP --server-name $PG_SERVER --name $DB_NAME --output none
}
Write-Host "    Database verified."

# 4. Ensure Azure Services Firewall Rule exists
Write-Host "==> Step 4: Ensuring Azure services firewall rule exists..." -ForegroundColor Yellow
az postgres flexible-server firewall-rule create --resource-group $RESOURCE_GROUP --server-name $PG_SERVER --name allowazureservices --start-ip-address 0.0.0.0 --output none 2>$null

# 5. Ensure ACR exists
Write-Host "==> Step 5: Ensuring Azure Container Registry ($ACR_NAME) exists..." -ForegroundColor Yellow
$acrExists = az acr show --resource-group $RESOURCE_GROUP --name $ACR_NAME 2>$null
if (-not $acrExists) {
    Write-Host "    Creating ACR '$ACR_NAME' in $LOCATION..."
    az acr create --resource-group $RESOURCE_GROUP --name $ACR_NAME --sku Basic --admin-enabled true --location $LOCATION --output none
} else {
    az acr update --resource-group $RESOURCE_GROUP --name $ACR_NAME --admin-enabled true --output none
}

# 6. Build Linux/AMD64 Image in ACR
Write-Host "==> Step 6: Building Linux/AMD64 All-in-One Container Image directly in ACR..." -ForegroundColor Yellow
az acr build --registry $ACR_NAME --image waitaminute:latest --platform linux/amd64 --file $DOCKERFILE .

# 7. Ensure App Service Plan exists
Write-Host "==> Step 7: Ensuring App Service Plan ($PLAN_NAME) exists..." -ForegroundColor Yellow
$planExists = az appservice plan show --resource-group $RESOURCE_GROUP --name $PLAN_NAME 2>$null
if (-not $planExists) {
    Write-Host "    Creating Linux B1 plan '$PLAN_NAME'..."
    az appservice plan create --resource-group $RESOURCE_GROUP --name $PLAN_NAME --is-linux --sku B1 --location $LOCATION --output none
}

# 8. Retrieve ACR credentials
$ACR_LOGIN_SERVER = az acr show --name $ACR_NAME --query loginServer -o tsv
$ACR_USERNAME = az acr credential show --name $ACR_NAME --query username -o tsv
$ACR_PASSWORD = az acr credential show --name $ACR_NAME --query "passwords[0].value" -o tsv
$FULL_IMAGE = "$ACR_LOGIN_SERVER/waitaminute:latest"

# 9. Ensure Web App exists
Write-Host "==> Step 8: Ensuring Web App ($APP_NAME) exists..." -ForegroundColor Yellow
$appExists = az webapp show --resource-group $RESOURCE_GROUP --name $APP_NAME 2>$null
if (-not $appExists) {
    Write-Host "    Creating Web App '$APP_NAME'..."
    az webapp create --resource-group $RESOURCE_GROUP --plan $PLAN_NAME --name $APP_NAME --deployment-container-image-name $FULL_IMAGE --output none
}

# 10. Configure container image and registry credentials
Write-Host "==> Step 9: Configuring container image source and credentials..." -ForegroundColor Yellow
az webapp config container set `
    --resource-group $RESOURCE_GROUP `
    --name $APP_NAME `
    --container-image-name $FULL_IMAGE `
    --container-registry-url "https://$ACR_LOGIN_SERVER" `
    --container-registry-user $ACR_USERNAME `
    --container-registry-password $ACR_PASSWORD `
    --output none

# 11. Inject App Settings
Write-Host "==> Step 10: Injecting production environment variables & Serverpod settings..." -ForegroundColor Yellow
az webapp config appsettings set `
    --resource-group $RESOURCE_GROUP `
    --name $APP_NAME `
    --settings `
        WEBSITES_PORT=8080 `
        WEBSITES_CONTAINER_START_TIME_LIMIT=600 `
        SERVERPOD_DATABASE_HOST=$PGHOST `
        SERVERPOD_DATABASE_PORT=5432 `
        SERVERPOD_DATABASE_NAME=$DB_NAME `
        SERVERPOD_DATABASE_USER=$PG_USER `
        SERVERPOD_DATABASE_REQUIRE_SSL=true `
        SERVERPOD_PASSWORD_database=$DB_PASSWORD `
        SERVERPOD_PASSWORD_serviceSecret=$SERVICE_SECRET `
        SERVERPOD_PASSWORD_jwtHmacSha512PrivateKey="24RCC9klKA8Of6Ayao3CXLjsC2VtRMG6" `
        SERVERPOD_PASSWORD_jwtRefreshTokenHashPepper="YPryOI-fAm2ZWKuyugxtG-9889QKs4oA" `
        SERVERPOD_PASSWORD_emailSecretHashPepper="ZN0r8pnNwG7FqCS2WIm6PaClZ-ZpyHOd" `
        runmode=production `
        serverid=default `
        logging=normal `
        role=monolith `
        WEBSITES_ENABLE_APP_SERVICE_STORAGE=false `
    --output none

# 12. Restart Web App
Write-Host "==> Step 11: Restarting Web App ($APP_NAME) to boot new container..." -ForegroundColor Yellow
az webapp restart --resource-group $RESOURCE_GROUP --name $APP_NAME --output none

Write-Host "======================================================================" -ForegroundColor Green
Write-Host " Deployment Complete!" -ForegroundColor Green
Write-Host " Web App URL: https://$APP_NAME.azurewebsites.net/" -ForegroundColor Green
Write-Host " Public Ingress Port: 8080 (handled by Caddy)" -ForegroundColor Green
Write-Host " Streaming initial container boot logs..." -ForegroundColor Green
Write-Host "======================================================================" -ForegroundColor Green

az webapp log tail --resource-group $RESOURCE_GROUP --name $APP_NAME
