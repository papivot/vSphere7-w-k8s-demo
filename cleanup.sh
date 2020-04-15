#!/bin/bash

kubectl config use-context demo-workload-cluster2
kubectl delete -f nginx-lbsvc.yml
kubectl config use-context demo3
kubectl delete -f ./guest-cluster.yml
kubectl config use-context demo2
kubectl delete -f ./enable-policy.yml
kubectl delete -f ./ghost.yml
kubectl delete -f ./ghost-claim.yml
kubectl delete -f ./vm.yml
sudo rm -rf /etc/docker/certs.d/
