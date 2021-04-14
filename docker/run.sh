#!/usr/bin/env sh
if [ ! -n "$LOKI_YAML_BASE64" ]; then
  echo "Expecting loki.yaml base64 encoded in LOKI_YAML_BASE64"
  exit 1
fi

echo "$LOKI_YAML_BASE64" | base64 -d > /loki/loki.yaml

/usr/bin/loki -config.file=/loki/loki.yaml
