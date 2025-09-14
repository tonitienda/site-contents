#! /bin/bash

echo "Preparing the VM..."
./scripts/prepare.sh



echo "Deploying the new version..."
multipass exec bluegreen-demo -- ./apply.sh