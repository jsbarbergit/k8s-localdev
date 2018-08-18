#!/bin/bash

echo "Copying conf files into place..."
sudo cp -f /vagrant/files/k8s.config /etc/kubernetes/config
sudo cp -f /vagrant/files/k8s.apiserver /etc/kubernetes/apiserver
sudo cp -f /vagrant/files/flanneld.conf /etc/sysconfig/flanneld
sudo cp -f /vagrant/files/k8s.kubelet /etc/kubernetes/kubelet


#Setup kubectl config
kubectl config set-cluster default-cluster --server=http://k8smaster001.local:8080
kubectl config set-context default-context --cluster=default-cluster --user=default-admin
kubectl config use-context default-context
# Configure k8s services
for SERVICES in kube-proxy kubelet flanneld docker; do
  echo "Restarting service:  $SERVICES"
  sudo systemctl restart $SERVICES
  sudo systemctl enable $SERVICES
done

# Install matching version of dashboard
kubectl apply -f /vagrant/files/tasks/kubernetes-dashboard.yaml

# Install kube-dns
kubectl apply -f /vagrant/files/tasks/core-dns.yaml

# Install Traefik
kubectl apply -f /vagrant/files/tasks/traefik/traefik-deploy.yaml

# Install nginx
kubectl apply -f /vagrant/files/tasks/nginx.yml
