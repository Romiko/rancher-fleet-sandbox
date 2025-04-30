#!/bin/bash
set -e

echo "Creating GitRepo resource to deploy 'grafana' and 'guestbook' via Fleet..."

cat <<EOF | kubectl apply -f -
apiVersion: fleet.cattle.io/v1alpha1
kind: GitRepo
metadata:
  name: sandbox-apps
  namespace: fleet-default
spec:
  repo: https://github.com/Romiko/rancher-fleet-sandbox.git
  branch: main
  paths:
    - ./grafana
    - ./guestbook
EOF

echo "GitRepo 'sandbox-apps' created in fleet-default namespace."
echo "Fleet will now deploy applications based on targetCustomizations."
