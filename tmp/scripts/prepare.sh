#! /bin/bash

# Cross-compile for Linux ARM64 (typical for multipass VMs)
GOOS=linux GOARCH=arm64 go build -o bluegreendemo cmd/main.go

# Transfer files to the VM
multipass transfer ./bluegreendemo bluegreen-demo:bluegreendemo
multipass transfer ./nginx/* bluegreen-demo:.
multipass transfer ./scripts/apply.sh bluegreen-demo:apply.sh
