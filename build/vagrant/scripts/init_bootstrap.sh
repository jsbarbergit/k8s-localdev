#!/bin/bash
sudo setenforce 0
#sudo systemctl disable firewalld
#sudo systemctl stop firewalld


sudo cp -f /vagrant/files/etcd.conf /etc/etcd/


#Configure etcd.conf for local env
HOST_NAME=`hostname -s`
IP_ADDR=`ip addr show dev enp0s8 scope 0 |grep inet|awk '{print $2}'|awk -F / '{print $1}'`
sudo sed -i "s/HOST_NAME/$HOST_NAME/g" /etc/etcd/etcd.conf
sudo sed -i "s/IP_ADDR/$IP_ADDR/g" /etc/etcd/etcd.conf
export ETCDCTL_ENDPOINTS=http://$IP_ADDR:2379
sudo ETCDCTL_ENDPOINTS=http://$IP_ADDR:2379  etcdctl ls /kube-centos/network

if [ $? != 0 ]; then
  echo "starting etcd first time"
  SVC_START=`sudo systemctl start etcd --no-block`
  sleep 5
  sudo ETCDCTL_ENDPOINTS=http://$IP_ADDR:2379 etcdctl mkdir /kube-centos/network
  sudo ETCDCTL_ENDPOINTS=http://$IP_ADDR:2379 etcdctl mk /kube-centos/network/config "{ \"Network\": \"172.30.0.0/16\", \"SubnetLen\": 24, \"Backend\": { \"Type\": \"vxlan\" } }"
  echo "Complete"
else
  echo "Existing network key found"
fi

if [ "$HOST_NAME" != "k8smaster001" ]; then
  #Print etcd status
  echo "etcd cluster members..."
  ETCDCTL_API=3; etcdctl member list
fi
