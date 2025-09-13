#! /bin/bash

# Cross-compile for Linux ARM64 (typical for multipass VMs)
GOOS=linux GOARCH=arm64 go build -o bluegreendemo cmd/main.go

# Transfer to home directory first (ubuntu user has permissions)
multipass transfer ./bluegreendemo bluegreen-demo:bluegreendemo

# Then move to /app/ with sudo and set permissions
multipass exec bluegreen-demo -- sudo mkdir -p /app/
multipass exec bluegreen-demo -- sudo chown ubuntu:ubuntu /app/
multipass exec bluegreen-demo -- mv bluegreendemo /app/blue
multipass exec bluegreen-demo -- chmod +x /app/blue
multipass exec bluegreen-demo -- /app/blue --port 8081 --color blue &