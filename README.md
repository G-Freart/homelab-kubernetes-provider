# homelab-kubernetes-provider

This ansible repo allow the provisioning of a kubernetes cluster running inside a set of KVM VMs.
It allow the settings configuration using files from the folder /vars.

Thanks @ [kubealex](https://github.com/kubealex/libvirt-k8s-provisioner) whose repo inspired me with the basics of my Provider.

I'm aware that ansible files could be improved to avoid some cut/paste using legacy task from external file, etc.
This repo is intended for my homestudy and was not crated with a production mode mindset.

The vars/default-settings.yaml allow to define the cluster name to create, the VM base settings as timezone, local, technical user, ...
Moreover, if your wanna use another libvirt folder location, you could customize target directory using this settings files.

The vars/clusters.yaml file is the one to use in order to define wished clusters :

``` yaml
# ------------------------------------------------------------------------------------------ #
#                                                                                            #
#                Copyright (c) 2021 - Gilles Freart. All right reserved                      #
#                                                                                            #
#  Licensed under the MIT License. See LICENSE in the project root for license information.  #
#                                                                                            #
# ------------------------------------------------------------------------------------------ #

# Within this file, you can define your own cluster definition
#
definition:

  "andromeda":

    guest_os:           'Ubuntu 20.04'
    container_runtime:  crio
    cni_plugin:         flannel
    ingress:            haproxy

    control_planes:
      vms:              3
      vcpu:             2
      mem:              6
      disk:             30

    worker_nodes:
      vms:              3
      vcpu:             3
      mem:              12
      disk:             60

    load_balancers:
      vms:              1
      vcpu:             2
      mem:              4
      disk:             30

    network:
      iface:            ens3
      network_cidr:     192.168.1.0/24
      domain:           homelab
      bridge:           homelab
      pod_cidr:         10.20.0.0/16
      service_cidr:     10.110.0.0/16

```

In this file, andromeda is the name of the cluster.

Guest OS which are defined inside the files /groups_vars_kvm_guest/cloud_images.yaml, could have one of the following value :
* Ubuntu 18.04
* Ubuntu 20.04
* Ubuntu 20.10
* CentOS 7
* CentOS 8.1
* CentOS 8.2
* CentOS 8.3
* CentOS 8 Stream

Container Runtime could have one of the following value :
* crio
* containerd
* docker

CNI plugin could have one of the following value :
* flannel
* calico

Ingress could have one of the following value :
* haproxy
* nginx

In order to create load balancer VMs, you should create more than one control plane. 

For each VMs, settings are :
* vms : the count of VMs to provision
* vcpu : the count of virtual cpu to associate to the related VM
* mem: the RAM (in gigabyte) to associate to the related VM
* disk : the disk size (in gigabyte) to associate to the related VM

The network part of the file allow you to customize either the KVM network or the K8S network :
* 'iface' must contains the name of the interface created during the terraform process of the VM provisionning :
  * eth0 whenever the guest operating system is a red hat based
  * ens3 whenever the guest operating system is a ubuntu based
* 'network_cidr' must contains the wished cidr of the KVM network which will be created using the given 'bridge' name.
* 'domain' contains the network domain towhich all VMs will belong
* 'pod_cidr' and 'service_cidr' are the parameter given as argument when using the kubeadm command to create the k8s cluster.

You will able to find a set of test cluster definition inside the folder /vars/testlab_samples

Have fun with this repo!
