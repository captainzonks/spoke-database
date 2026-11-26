#!/bin/sh

# ==============================================================================
# DATABASE MODULE - INFLUXDB3 ENTRYPOINT
# ==============================================================================
# Description: Starts influxdb3 with token authentication from a Docker secret
# Author: Matt Barham
# Created: 2026-02-13
# Modified: 2026-11-26
# Version: 3.0.0
# Host: Your Server
# ==============================================================================
# Type: Shell Script (entrypoint)
# Component: module: database / service: influxdb3
# ==============================================================================
# The influxdb3_auth_token secret holds one admin token (apiv3_...). It is
# written to the JSON format --admin-token-file expects, in a 0600 temp file.
# InfluxDB loads it only while the catalog has no admin token. The server
# refuses to start without the secret; it never runs unauthenticated.
# /health and /ping stay open for health checks.
# https://docs.influxdata.com/influxdb3/core/admin/tokens/admin/
# ==============================================================================

set -eu

SECRET_FILE=/run/secrets/influxdb3_auth_token
if [ ! -r "${SECRET_FILE}" ]; then
  echo "ERROR: ${SECRET_FILE} is missing or unreadable; refusing to start without authentication" >&2
  exit 1
fi
TOKEN=$(tr -d '\r\n' < "${SECRET_FILE}")
case "${TOKEN}" in
  apiv3_*) ;;
  *) echo "ERROR: the admin token must start with apiv3_" >&2; exit 1 ;;
esac
case "${TOKEN#apiv3_}" in
  ''|*[!A-Za-z0-9_-]*) echo "ERROR: the admin token contains unexpected characters" >&2; exit 1 ;;
esac
TOKEN_FILE=$(mktemp /tmp/influxdb3_admin_token.XXXXXX)
printf '{"token":"%s","name":"_admin"}\n' "${TOKEN}" > "${TOKEN_FILE}"
unset TOKEN
exec influxdb3 "$@" --admin-token-file "${TOKEN_FILE}" --disable-authz health,ping
