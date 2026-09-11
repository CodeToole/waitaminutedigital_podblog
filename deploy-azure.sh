#!/usr/bin/env bash
# ==============================================================================
# Waitaminute Digital - Production Azure Deployment Pipeline
#
# Builds the Linux/AMD64 all-in-one container directly in Azure Container Registry
# and deploys it to Azure App Service with single-port routing via Caddy.
# ==============================================================================

set -euo pipefail

# ------------------------------------------------------------------------------
# 1. Pipeline Configuration
# ------------------------------------------------------------------------------
RESOURCE_GROUP="${AZURE_RESOURCE_GROUP:-WMDpy-Core-RG}"
LOCATION="${AZURE_LOCATION:-eastus2}"
PG_SERVER="${AZURE_PG_SERVER:-waitaminuteserverpod}"
DB_NAME="${AZURE_DB_NAME:-waitaminute_serverpod}"
PG_USER="${AZURE_PG_USER:-dunanhugh}"
ACR_NAME="${AZURE_ACR_NAME:-wmdacr2026}"
PLAN_NAME="${AZURE_PLAN_NAME:-waitaminute-plan}"
APP_NAME="${AZURE_APP_NAME:-waitaminute-web-prod}"
DOCKERFILE="waitaminute_serverpod/waitaminute_serverpod_server/Dockerfile"

# Database password: use environment variable if supplied, or default from production config
DB_PASSWORD="${SERVERPOD_PASSWORD_database:-${AZURE_PG_PASSWORD:-rDLAAJVA1-rCeFY8wcIGzBKAxAAdMHny}}"
SERVICE_SECRET="${SERVERPOD_PASSWORD_serviceSecret:-waitaminutedigital_service_secret_2026_prod}"

echo "======================================================================"
echo " Waitaminute Digital - Azure Deployment Pipeline"
echo " Resource Group:  ${RESOURCE_GROUP}"
echo " Location:        ${LOCATION}"
echo " Postgres Server: ${PG_SERVER}"
echo " Database:        ${DB_NAME}"
echo " Postgres User:   ${PG_USER}"
echo " ACR Registry:    ${ACR_NAME}"
echo " App Service:     ${APP_NAME}"
echo " Service Plan:    ${PLAN_NAME} (Linux B1)"
echo " Dockerfile:      ${DOCKERFILE}"
echo "======================================================================"

# ------------------------------------------------------------------------------
# 2. Azure Environment & Postgres Health Verification
# ------------------------------------------------------------------------------
echo "==> Step 1: Checking Azure authentication..."
az account show --output table

echo "==> Step 2: Verifying PostgreSQL server status (${PG_SERVER})..."
until [ "$(az postgres flexible-server show --resource-group "${RESOURCE_GROUP}" --name "${PG_SERVER}" --query state -o tsv 2>/dev/null || echo 'Unknown')" = "Ready" ]; do
  echo "    Postgres server is provisioning or not yet Ready. Waiting 10s..."
  sleep 10
done
echo "    Postgres server (${PG_SERVER}) is Ready!"

# Get the fully-qualified domain name of the PostgreSQL server
PGHOST=$(az postgres flexible-server show --resource-group "${RESOURCE_GROUP}" --name "${PG_SERVER}" --query fullyQualifiedDomainName -o tsv)
if [ -z "${PGHOST}" ]; then
  PGHOST="${PG_SERVER}.postgres.database.azure.com"
fi
echo "    Resolved Postgres host: ${PGHOST}"

# Ensure database exists
echo "==> Step 3: Ensuring database '${DB_NAME}' exists on Postgres server..."
if ! az postgres flexible-server db show --resource-group "${RESOURCE_GROUP}" --server-name "${PG_SERVER}" --database-name "${DB_NAME}" --output none 2>/dev/null; then
  echo "    Creating database '${DB_NAME}'..."
  az postgres flexible-server db create \
    --resource-group "${RESOURCE_GROUP}" \
    --server-name "${PG_SERVER}" \
    --database-name "${DB_NAME}" \
    --output none
fi
echo "    Database verified."

# ------------------------------------------------------------------------------
# 3. Azure Container Registry (ACR) Setup & Cloud Build
# ------------------------------------------------------------------------------
echo "==> Step 4: Ensuring Azure Container Registry (${ACR_NAME}) exists..."
if ! az acr show --resource-group "${RESOURCE_GROUP}" --name "${ACR_NAME}" --output none 2>/dev/null; then
  echo "    Creating ACR '${ACR_NAME}' in ${LOCATION}..."
  az acr create \
    --resource-group "${RESOURCE_GROUP}" \
    --name "${ACR_NAME}" \
    --sku Basic \
    --admin-enabled true \
    --location "${LOCATION}" \
    --output none
else
  # Ensure admin credentials are enabled for App Service integration
  az acr update --resource-group "${RESOURCE_GROUP}" --name "${ACR_NAME}" --admin-enabled true --output none
fi

echo "==> Step 5: Building Linux/AMD64 All-in-One Container Image directly in ACR..."
az acr build \
  --registry "${ACR_NAME}" \
  --image waitaminute:latest \
  --platform linux/amd64 \
  --file "${DOCKERFILE}" \
  .

# ------------------------------------------------------------------------------
# 4. App Service Plan & Web App Configuration
# ------------------------------------------------------------------------------
echo "==> Step 6: Ensuring App Service Plan (${PLAN_NAME}) exists..."
if ! az appservice plan show --resource-group "${RESOURCE_GROUP}" --name "${PLAN_NAME}" --output none 2>/dev/null; then
  echo "    Creating Linux B1 plan '${PLAN_NAME}'..."
  az appservice plan create \
    --resource-group "${RESOURCE_GROUP}" \
    --name "${PLAN_NAME}" \
    --is-linux \
    --sku B1 \
    --location "${LOCATION}" \
    --output none
fi

# Retrieve ACR credentials
ACR_LOGIN_SERVER=$(az acr show --name "${ACR_NAME}" --query loginServer -o tsv)
ACR_USERNAME=$(az acr credential show --name "${ACR_NAME}" --query username -o tsv)
ACR_PASSWORD=$(az acr credential show --name "${ACR_NAME}" --query "passwords[0].value" -o tsv)
FULL_IMAGE="${ACR_LOGIN_SERVER}/waitaminute:latest"

echo "==> Step 7: Ensuring Web App (${APP_NAME}) exists..."
if ! az webapp show --resource-group "${RESOURCE_GROUP}" --name "${APP_NAME}" --output none 2>/dev/null; then
  echo "    Creating Web App '${APP_NAME}'..."
  az webapp create \
    --resource-group "${RESOURCE_GROUP}" \
    --plan "${PLAN_NAME}" \
    --name "${APP_NAME}" \
    --deployment-container-image-name "${FULL_IMAGE}" \
    --output none
fi

echo "==> Step 8: Configuring container image source and credentials..."
az webapp config container set \
  --resource-group "${RESOURCE_GROUP}" \
  --name "${APP_NAME}" \
  --container-image-name "${FULL_IMAGE}" \
  --container-registry-url "https://${ACR_LOGIN_SERVER}" \
  --container-registry-user "${ACR_USERNAME}" \
  --container-registry-password "${ACR_PASSWORD}" \
  --output none

echo "==> Step 9: Injecting production environment variables & Serverpod settings..."
az webapp config appsettings set \
  --resource-group "${RESOURCE_GROUP}" \
  --name "${APP_NAME}" \
  --settings \
    WEBSITES_PORT=8080 \
    WEBSITES_CONTAINER_START_TIME_LIMIT=600 \
    SERVERPOD_DATABASE_HOST="${PGHOST}" \
    SERVERPOD_DATABASE_PORT=5432 \
    SERVERPOD_DATABASE_NAME="${DB_NAME}" \
    SERVERPOD_DATABASE_USER="${PG_USER}" \
    SERVERPOD_DATABASE_REQUIRE_SSL=true \
    SERVERPOD_PASSWORD_database="${DB_PASSWORD}" \
    SERVERPOD_PASSWORD_serviceSecret="${SERVICE_SECRET}" \
    SERVERPOD_PASSWORD_jwtHmacSha512PrivateKey="${SERVERPOD_PASSWORD_jwtHmacSha512PrivateKey:-24RCC9klKA8Of6Ayao3CXLjsC2VtRMG6}" \
    SERVERPOD_PASSWORD_jwtRefreshTokenHashPepper="${SERVERPOD_PASSWORD_jwtRefreshTokenHashPepper:-YPryOI-fAm2ZWKuyugxtG-9889QKs4oA}" \
    SERVERPOD_PASSWORD_emailSecretHashPepper="${SERVERPOD_PASSWORD_emailSecretHashPepper:-ZN0r8pnNwG7FqCS2WIm6PaClZ-ZpyHOd}" \
    runmode=production \
    serverid=default \
    logging=normal \
    role=monolith \
    WEBSITES_ENABLE_APP_SERVICE_STORAGE=false \
  --output none

# ------------------------------------------------------------------------------
# 5. Restart & Log Streaming
# ------------------------------------------------------------------------------
echo "==> Step 10: Restarting Web App (${APP_NAME}) to boot new container..."
az webapp restart \
  --resource-group "${RESOURCE_GROUP}" \
  --name "${APP_NAME}" \
  --output none

echo "======================================================================"
echo " Deployment Complete!"
echo " Web App URL: https://${APP_NAME}.azurewebsites.net/"
echo " Public Ingress Port: 8080 (handled by Caddy)"
echo " Streaming initial container boot logs..."
echo "======================================================================"

az webapp log tail --resource-group "${RESOURCE_GROUP}" --name "${APP_NAME}"
