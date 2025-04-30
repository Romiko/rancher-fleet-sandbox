#!/bin/bash
set -e

EXPECTED_CONTEXT="rancher-desktop"

echo "🔍 Checking current kubectl context..."
CURRENT_CONTEXT=$(kubectl config current-context)

if [[ "$CURRENT_CONTEXT" != "$EXPECTED_CONTEXT" ]]; then
  echo "You are not connected to the expected Kubernetes context: '$EXPECTED_CONTEXT'"
  echo "   Current context is: '$CURRENT_CONTEXT'"
  echo "Run 'kubectl config use-context $EXPECTED_CONTEXT' to switch."
  exit 1
fi

echo "Connected to expected context: '$CURRENT_CONTEXT'"


kubectl get clusters.management.cattle.io -A
kubectl label cluster.management.cattle.io/local env=dev
kubectl get cluster.management.cattle.io/local --show-labels

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
