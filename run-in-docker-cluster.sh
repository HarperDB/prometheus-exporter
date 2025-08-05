#!/usr/bin/env bash

# Run a 3-node Harper replication cluster with this plugin installed

function cleanup {
  echo "Stopping and deleting docker compose stack"
  docker compose down
}

trap cleanup EXIT

docker compose pull
docker compose build
docker compose up &

echo
echo -n "Waiting for Harper to be ready..."

until curl -fs localhost:49925/health; do
  sleep 1
done
echo

curl -u admin:foobar -v localhost:49926/prometheus_exporter/PrometheusExporterSettings/forceAuthorization \
  -X PUT -L -H 'Content-Type: application/json' -d '{"value": false}'

echo
echo "Harper replication cluster is now running on port 49925 (operations API) & 49926 (REST API)"
echo "You can access Prometheus metrics at http://localhost:49926/prometheus_exporter/metrics"
echo

wait
