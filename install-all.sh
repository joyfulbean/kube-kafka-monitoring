#!/bin/bash

# DEBUGGER
set -xe

#
# comment lines below if you're not using amazon linux2
#
sudo yum update -y
$SUDO yum -y install git

# 
# start kafka cluster 
#
kubectl apply -k rbac-namespace-default
kubectl apply -k zookeeper/
kubectl apply -k kafka/

#
# install monitoring tools
#
kubectl apply -k cmak
kubectl apply -k linkedin-burrow/
kubectl apply -k prometheus-exporter
kubectl apply -k prometheus/
kubectl --namespace kafka patch statefulset kafka --patch "$(cat prometheus-exporter/jmx-exporter/kafka-jmx-exporter-patch.yml )"
kubectl apply -k grafana/


