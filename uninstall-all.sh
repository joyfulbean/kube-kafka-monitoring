#!/bin/bash

# DEBUGGER
set -xe

#
# uninstall everything at once
#
kubectl delete namespace kafka
kubectl delete namespace kube-system
kubectl delete namespace monitoring
