# Kafka for Kubernetes

Special thanks to [@Yoolean](https://github.com/Yolean/kubernetes-kafka/issues/82#issuecomment-337532548)

This repository seeks to provide:
 * Production-worthy Kafka setup for reproducing error and loading test 
 * End-to-End monitoring system for Kafka

## Getting started

Only tested in Amazon Linux2 EC2

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
   
Out of Cluster access is possible through [broker-outside-svc](https://github.com/joyfulbean/kube-kafka-monitoring/blob/master/kafka/outside-1.yml)


## Monitoring

```
# total kafka monitoring
kubectl apply -k cmak

# add 
kubectl apply -k linkedin-burrow/

# kafka metric gather
kubectl --namespace kafka apply -f prometheus/metrics-config.yml
kubectl --namespace kafka patch statefulset kafka --patch "$(cat prometheus/kafka-jmx-exporter-patch.yml )"

```

 * [cmak](./cmak/)
   * reference: https://github.com/yahoo/CMAK
 * [cmak](./cmak/)
   * reference: https://github.com/yahoo/CMAK
 * [cmak](./cmak/)
   * reference: https://github.com/yahoo/CMAK
   * http://ec2-ip:32401/metrics

<open-source>
https://github.com/prometheus/jmx_exporter/tree/add7897f513f3981f91f013cd7f3617a532c7b79
https://github.com/solsson/kafka-cluster-metrics

#
## burrow (브로커 config에 추가 필요)
#

https://kubernetes.io/ko/docs/concepts/services-networking/service/

http://54.241.141.202:30031/admin

<opensource>
https://github.com/linkedin/Burrow

#
## kminion
#
kubectl apply -k kminions/
http://54.241.141.202:30077/metrics

<opensource>
https://github.com/redpanda-data/kminion

#
## GRAFANA + Prometheus
# 
https://github.com/giantswarm/prometheus



## Version

 * Kafka
 * Kubernetes
 * Jmeter
