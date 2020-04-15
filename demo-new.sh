#!/bin/bash

########################
# include the magic
########################
. envvariable
. demo-magic.sh

rm ~/.kube/config
# hide the evidence
clear

# Put your stuff here

################################### INITAL LOGIN AND ACCESS ##########################################
pe "kubectl vsphere login --insecure-skip-tls-verify --server ${SUPIPADDR} -u administrator@vsphere.local"
pe "cat ~/.kube/config"
pe "clear"
pe "kubectl config get-contexts"
pe "kubectl config use-context demo2"
pe "clear"
pe "kubectl get all"
pe "clear"
################################### DEPLOY VM ########################################################
pe "cat ./vm.yml"
pe "kubectl apply -f ./vm.yml"
pe "clear"
################################## INTERACT WITH HARBOR #############################################
pe "sudo mkdir -p /etc/docker/certs.d/${HARBORIPADDR}"
pe "pushd /etc/docker/certs.d/${HARBORIPADDR}"
pe "sudo wget https://${HARBORIPADDR}/api/systeminfo/getcert -O ca.crt --no-check-certificate"
pe "ls -ltr"
pe "clear"
pe "docker login ${HARBORIPADDR}"
pe "docker pull ghost:latest"
pe "clear"
pe "docker tag ghost:latest ${HARBORIPADDR}/demo2/ghost:v1"
pe "docker push ${HARBORIPADDR}/demo2/ghost:v1"
pe "clear"
pe "popd"
pe "pwd"
################################## DEPLOY PODVM AND PVC ###############################################
pe "cat ./ghost-claim.yml"
pe "clear"
pe "kubectl apply -f ./ghost-claim.yml"
pe "kubectl get pvc"
pe "clear"
pe "cat ./ghost.yml"
pe "clear"
pe "kubectl apply -f ./ghost.yml"
pe "kubectl get all"
pe "kubectl get all"
pe "clear"
pe "kubectl get svc -o wide"
pe "clear"
################################### ENABLE NW POLICY /FIREWALL #######################################
pe "cat ./enable-nw-policy.yml"
pe "clear"
pe "kubectl apply -f ./enable-nw-policy.yml"
pe "kubectl get all -o wide"
#pe "echo 'TKG Clusters'"
pe "clear"
################################### DEPLOY GUEST CLUSTER ############################################
pe "kubectl config use-context demo3"
pe "cat ./guest-cluster.yml"
pe "clear"
pe "kubectl apply -f ./guest-cluster.yml"
pe "clear"
pe "kubectl get managedcluster,clusters.cluster.x-k8s.io,machine.cluster.x-k8s.io,virtualmachines"
pe "clear"
pe "kubectl describe managedcluster demo-workload-cluster3"
pe "clear"
#################################### LOGIN AS A DEV USER ############################################
pe "kubectl vsphere logout"
pe "rm -rf ~/.kube/config"
pe "kubectl vsphere login --insecure-skip-tls-verify --server ${SUPIPADDR} -u ${USER}"
pe "kubectl config get-contexts"
pe "kubectl get pods -A"
pe "kubectl config use-context demo2"
pe "kubectl get pods,managedcluster -o wide"
##################################### ACCESS WORKLOAD CLUSTER TO DEPLOY APP ########################
pe "kubectl vsphere login --server ${SUPIPADDR} --vsphere-username ${USER} --managed-cluster-namespace demo2 --managed-cluster-name demo-workload-cluster2 --insecure-skip-tls-verify"
pe "kubectl config use-context demo-workload-cluster2"
pe "kubectl get pods -A -o wide"
pe "cat ./nginx-lbsvc.yml"
pe "kubectl apply -f ./nginx-lbsvc.yml"
pe "kubectl get all"
pe "kubectl get service/nginx"
