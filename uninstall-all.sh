#!/bin/bash

# DEBUGGER
set -xe

#
# uninstall everything at once
#
kubectl delete namespace kafka
kubectl delete namespace monitoring
kubectl delete namespace test-kafka
