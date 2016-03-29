#!/bin/sh

curl -v -X POST \
  -H "Authorization: Bearer ${ACCESS_TOKEN}" \
  -H "Content-Type: application/json" \
  "https://${APP_HOST}/thing-if/apps/${APP_ID}/targets/thing:${THING_ID}/commands" \
  -d "{\"schemaVersion\":1,\"schema\":\"SmartLightDemo\",\"issuer\":\"user:${USER_ID}\",\"actions\":[{\"turnPower\":{\"power\":true}},{\"setBrightness\":{\"brightness\":50}},{\"setColor\":{\"color\":[0,255,255]}}]}"

