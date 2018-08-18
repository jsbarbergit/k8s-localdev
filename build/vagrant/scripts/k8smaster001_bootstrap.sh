#!/bin/bash

echo "Copying conf files into place..."
sudo cp -f /vagrant/files/k8s.config /etc/kubernetes/config
sudo cp -f /vagrant/files/k8s.apiserver /etc/kubernetes/apiserver
sudo cp -f /vagrant/files/flanneld.conf /etc/sysconfig/flanneld
sudo cp -f /vagrant/files/k8s.controller /etc/kubernetes/controller-manager

#Starting k8s services
for SERVICES in etcd kube-apiserver kube-controller-manager kube-scheduler flanneld; do
  echo "Restarting service:  $SERVICES"
  sudo systemctl restart $SERVICES
  sudo systemctl enable $SERVICES
done
