# Kafka for Kubernetes

Special thanks to [@Yoolean](https://github.com/Yolean/kubernetes-kafka)

This repository seeks to provide:
 * Production-worthy Kafka setup for reproducing error and loading test 
 * End-to-End monitoring system for Kafka

## Quick Start 

Install all monitoring tools and kafka cluster at once

`./install-all.sh`

Uninstall all at once

`./uninstall-all.sh`


## Getting started

Only tested in Amazon Linux2 EC2

* Recommend t2.xlarge (4CPU, 16GB) at least. 
* [minikube](https://minikube.sigs.k8s.io/docs/drivers/none/) recommend t2.medium but too many pods and load only to use t2.medium. 

#### [Set up for servers](https://github.com/joyfulbean/myset/blob/master/joyful_shell.sh)

```
git clone https://github.com/joyfulbean/myset
cd myset
./joyful_shell.sh
```
>From now, kubectl is shortened to `kp`

#### [Set up for minikube](https://github.com/joyfulbean/myset/blob/master/minikubeset.sh)

```
# install minikube
git clone https://github.com/joyfulbean/myset
./minikubeset.sh

# start minikube
sudo su - 
minikube start --vm-driver=none

# start minikube dashboard
minikube dashboard --url
kubectl proxy --address='0.0.0.0' --disable-filter=true &
```
Minikube Dashboar URL: http://ec2-ip:8001/api/v1/namespaces/kubernetes-dashboard/services/http:kubernetes-dashboard:/proxy/

#### Start Kafka Clusters 

```
git clone https://github.com/joyfulbean/kube-kafka-monitoring.git
cd kube-kafka-monitoring
kubectl apply -k rbac-namespace-default
kubectl apply -k zookeeper/
kubectl apply -k kafka/
```
> Want to start each file? Use `apply -f` and change [kustomization](https://kubectl.docs.kubernetes.io/pages/app_customization/introduction.html) to add new file in the directory

 * [./rbac-namespace-default](./rbac-namespace-default/)
   * create namespace kafka and monitoring and create cluster roles
 * [./zookeeper](./zookeeper/)
   * use persistent volume for zookeeper. change zookeeper.properties in zoo-config.yml and the number of zookeeper in pzoo.yml
 * [./kafka](./kafka/)
   * change broker.properties in broker-config.yml and the number of kafka in kafka.yml
   
Out of Cluster access is possible through [broker-outside-svc](https://github.com/joyfulbean/kube-kafka-monitoring/tree/master/kafka/broker-outside-svc)

## Monitoring

```
kubectl apply -k cmak 
kubectl apply -k linkedin-burrow/
kubectl apply -k prometheus-exporter 
kubectl apply -k prometheus/
kubectl --namespace kafka patch statefulset kafka --patch "$(cat prometheus-exporter/jmx-exporter/kafka-jmx-exporter-patch.yml )"
kubectl apply -k grafana/
```

 * [cmak](./cmak/)
   * [reference for CMAK](https://github.com/yahoo/CMAK)
   * make topic here and manage the cluster 
   * To Add Cluster Use Zookeeper Cluster IP: zookeeper.kafka:2181 
   * Dashboard URL: (ec2-ip):32336
 * [burrow](./burrow/)
   * [reference for burrow](https://github.com/linkedin/Burrow)
   * can monitor the consumer lag
   * [check the rule set here](https://github.com/linkedin/Burrow/wiki/Consumer-Lag-Evaluation-Rules)
   * Dashboard URL: (ec2-ip):32337
   * Metric URL: (ec2-ip):32339/metrics
 * [prometheus](./prometheus/)
   * [reference for proemetheus](https://github.com/prometheus/prometheus)
   * check the metrics here.
   * to add more target, add targets in prometheus-config.yml
   * Dashboard URL: (ec2-ip):32334
 * [prometheus-exporter](./prometheus-exporter/)
   * [reference for kafka-exporter](https://github.com/danielqsj/kafka_exporter)
     * collect kafka metric.  
     * to add more server, add args in kafka-exporter-deploy.yml
     * Metric URL: (ec2-ip):30055/metrics
     * [Grafana Dashboard ID](https://grafana.com/grafana/dashboards/7589): 7589 
   * [reference for node exporter](https://github.com/prometheus/node_exporter)
     * collect host server metric
     * Metric URL: (ec2-ip):30088/metrics
     * [Grafana Dashboard ID](https://grafana.com/grafana/dashboards/1860): 1860
   * [reference for kube-state-metric exporter](https://github.com/kubernetes/kube-state-metrics)
     * collect pods metric
     * [Grafana Dashboard ID](https://grafana.com/grafana/dashboards/6417):6417
   * [reference for kminion](https://github.com/redpanda-data/kminion)
     * collect kafka consumr lag, cluster, topic metric
     * Metric URL: (ec2-ip):30077/metrics
     * [Grafana Dashboard ID for topic](https://grafana.com/grafana/dashboards/14013):14013
     * [Grafana Dashboard ID for consumer group](https://grafana.com/grafana/dashboards/14014):14014
     * [Grafana Dashboard ID for cluster](https://grafana.com/grafana/dashboards/14012):14012
   * [reference for jmx-exporter]
     * collect jmx metric
     * Metric URL: (ec2-ip):32000/metrics
     * [Grafana Dashboard ID for jmx](https://grafana.com/grafana/dashboards/11131):11131
 * [grafana-dashboard](https://github.com/grafana/grafana)
     * visualize metrics collected in prometheus
     * [reference for kube grafana job](https://github.com/giantswarm/prometheus/blob/master/manifests-all.yaml)

## Version

 * Kafka 
 * Kubernetes : latest
 * Jmeter
