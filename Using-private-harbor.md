# Using Local Harbor for registry

1. Setup Harbor on the Sup cluster. 


## Downloading nginx image and transport it.

`docker pull nginx`

`docker save -o nginx.tar nginx:latest`

`docker load -i nginx.tar`

`docker login https://192.168.10.167 -u "administrator@vsphere.local" -p Passw0rd!`

`docker tag nginx:latest docker 192.168.10.167/demo1/nginx:latest`

`docker push 192.168.10.167/demo1/nginx:latest`


```
kubectl create secret docker-registry harbor \
    --docker-server=192.168.10.167 \
    --docker-username=administrator@vsphere.local \
    --docker-password=Passw0rd!
```

```yaml
# nginx-lbsvc.yaml
---
apiVersion: v1
kind: Service
metadata:
  labels:
    name: nginx
  name: nginx
spec:
  ports:
    - port: 80
  selector:
    app: nginx
  type: LoadBalancer
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx
  labels:
    app: nginx
spec:
  replicas: 2
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      imagePullSecrets:
      - name: harbor
      containers:
      - name: nginx
        image: 192.168.10.167/demo1/nginx:latest
        ports:
        - containerPort: 80
```

`kubectl apply -f nginx-lbsvc.yaml`
