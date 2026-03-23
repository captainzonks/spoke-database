# spoke-database

Spoke module for time series, object storage, and document databases.

## Services

| Service          | Description                | Port | Network |
|------------------|----------------------------|------|---------|
| influxdb3        | Time series database       | 8181 | troxy   |
| minio            | S3-compatible object store | 9000/9090 | troxy |
| couchdb          | Document database          | 5984 | troxy   |
| victoria-metrics | Time series database       | 8428 | troxy   |

## Prerequisites

- Spoke hub deployed with `troxy` network
- Traefik available as a hub service
- Required secrets: `influxdb3_auth_token`, `minio_root_password`

## Quick Start

```bash
cp .env.example .env
# Edit .env — set data paths and ports
docker compose up -d
```

## Custom InfluxDB3 Build

InfluxDB3 uses a custom Dockerfile at `dockerfiles/influxdb3/Dockerfile` that adds:
- Custom user/group mapping for host filesystem permissions
- Docker secrets support via entrypoint script

Build with: `docker compose build influxdb3`

## Module Environment Variables

| Variable                | Default                                           | Description                |
|-------------------------|---------------------------------------------------|----------------------------|
| `INFLUXDB3_TAG`         | `3.8.0-core-custom`                              | InfluxDB3 build tag        |
| `INFLUXDB3_IMAGE`       | `spoke/influxdb3:${INFLUXDB3_TAG}`               | InfluxDB3 image            |
| `MINIO_IMAGE`           | `minio/minio:RELEASE.2025-09-07T16-13-09Z`       | MinIO image                |
| `COUCHDB_IMAGE`         | `couchdb:3.5.1`                                  | CouchDB image              |
| `VICTORIA_METRICS_IMAGE`| `victoriametrics/victoria-metrics:v1.134.0`       | VictoriaMetrics image      |
| `INFLUXDB3_IP`          | `192.168.35.45`                                  | InfluxDB3 static IP        |
| `MINIO_IP`              | `192.168.35.46`                                  | MinIO static IP            |
| `COUCHDB_IP`            | `192.168.35.44`                                  | CouchDB static IP          |
| `VICTORIA_METRICS_IP`   | `192.168.35.48`                                  | VictoriaMetrics static IP  |

## References

- [InfluxDB3](https://docs.influxdata.com/influxdb/v3/)
- [MinIO](https://min.io/docs/)
- [CouchDB](https://docs.couchdb.org/)
- [VictoriaMetrics](https://docs.victoriametrics.com/)
