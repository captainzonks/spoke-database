#!/bin/sh
set -e

# ==============================================================================
# DATABASE MODULE - INFLUXDB3 ENTRYPOINT
# ==============================================================================
# Description: Reads Docker secrets and configures auth for influxdb3 v3.8.0+
# Author: Matt Barham
# Created: 2026-02-13
# Modified: 2026-04-21
# Version: 2.0.1
# Host: Your Server
# ==============================================================================
# Type: Shell Script (entrypoint)
# Component: module: database / service: influxdb3
# ==============================================================================
# influxdb3 v3.8.0 changed auth model:
#   - Old: INFLUXDB3_AUTH_TOKEN env var (no longer supported)
#   - New: --admin-token-file flag / INFLUXDB3_ADMIN_TOKEN_FILE env var
#          --disable-authz health,ping for unauthenticated health checks
# ==============================================================================

EXTRA_ARGS=""

# Configure auth from Docker secret
# influxdb3 v3.8.0+ expects --admin-token-file with JSON format
# TODO: Generate proper JSON token file format for v3.8.0+ auth
# For now, run without auth until token migration is done
if [ -f "/run/secrets/influxdb3_auth_token" ]; then
  echo "INFO: found secret 'influxdb3_auth_token'"
  echo "WARNING: influxdb3 v3.8.0+ requires JSON token format"
  echo "WARNING: running with --without-auth until token is migrated"
  EXTRA_ARGS="--without-auth"
else
  echo "WARNING: secret 'influxdb3_auth_token' not found at /run/secrets/"
  echo "Running without auth"
  EXTRA_ARGS="--without-auth"
fi

# Execute the InfluxDB3 binary with arguments from CMD + extra args
exec influxdb3 "$@" ${EXTRA_ARGS}
