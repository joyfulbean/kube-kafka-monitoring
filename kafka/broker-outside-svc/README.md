## Explanation of Network for kafka and kubernetes

### Kafka Network Setting

For kafka external access, set as below
In "kafka-config.yml", 
listeners=PLAINTEXT://:9092,OUTSIDE://:9094
advertised.listeners=PLAINTEXT://:9092,OUTSIDE://(minikube-ip):9094

Need to understand what listeners and advertised.listeners are.
[Helpful page for understanding kafka network](advertised.listeners=PLAINTEXT://${ADVERTISE_ADDR}:9092,OUTSIDE://${OUTSIDE_HOST}:${OUTSIDE_PORT})

listeners are for internal kafka communication 
advertised.listeners are for external kafka communiation

### Explanation of default setting

default set is listeners=PLAINTEXT://:9092.
If you do not set advertised.listeners, it will set the same as listeners which means advertised.listeners=PLAINTEXT://:9092.
Default set allows internal communication of kafka only. 
container should open 9092 port. 
In this repo, there is service called bootstrap which selected all 9092 port. 
This works here. since, // stands for localhost, 0.0.0.0, and specifically in kubernetes cluster ip. 
which means, // stands for different cluster ip so the port can be the same.
you can simply access kafka cluster using bootstrap.kafka.svc.cluster.local inside kafka broker. 

### Explanation of external kafka network

advertised.listeners cannot be the same for each kafka broker. 
In minikube env, all broker gets the same ip address.
Therefore, each broker must have different port, which means you must create node port for each broker. 
nodeport 32400 is mapped to 32400 with its cluster ip and mapped to 9094 with its container ip. 
At this point, container port 9094 should be opened when you create the container. 
therefore, you use 32400 to access the kafka cluster from outside and use 9094 port to communicate with each broker. 

### DNS set
To do DNS Set, use headless service.
headless service help internal broker to communicate each other. 
kafka broker pod can dye any time. 
If pod restarts, cluster ip change. Therefore, for internal communication of kafka you must use dns service. 
In kubernetes, headless service map (each podname).(headless-service-name).(namespace).svc.cluster.local to each pod's cluster ip.

To check it, Use Command below inside kubernetes cluster, 

```
kubectl -n kafka logs kafka-0 | grep "Registered broker"
```


