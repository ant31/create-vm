#!/bin/bash
tag=$2
uhome=$3
instance=$1
mkdir -p $instance
cp Dockerfile $instance/
base=`qemu-img info  $uhome/vms/virsh/images/$instance.img |grep 'backing file:' | cut -d':' -f 2`
# cp /home/kadmin/vms/base/k2base.qcow2 base.qcow2
echo $base
echo cp $base $instance/base.qcow2
cp $base $instance/base.qcow2
echo cp $uhome/vms/virsh/images/$instance.img $instance/
cp $uhome/vms/virsh/images/$instance.img $instance/$instance.img
ls $instance
echo qemu-img rebase -b base.qcow2 $instance/$instance.img -F qcow2
sudo qemu-img rebase -b base.qcow2 $instance/$instance.img -F qcow2
echo qemu-img commit $instance/$instance.img
sudo qemu-img commit $instance/$instance.img
echo sudo virt-sysprep --operations machine-id,bash-history,logfiles,tmp-files,net-hostname,net-hwaddr,ssh-userdir,ssh-hostkeys -a $instance/base.qcow2
sudo virt-sysprep --operations machine-id,bash-history,logfiles,tmp-files,net-hostname,net-hwaddr,ssh-userdir,ssh-hostkeys -a $instance/base.qcow2
echo docker build -t quay.io/kubespray/vm-kubespray-ci:$tag --build-arg cloud_image=$instance/base.qcow2 .
docker build -t quay.io/kubespray/vm-kubespray-ci:$tag --build-arg cloud_image=$instance/base.qcow2 . && docker push quay.io/kubespray/vm-kubespray-ci:$tag
