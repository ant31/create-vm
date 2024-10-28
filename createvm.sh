base=$1
name=$2
./create-vm/create-vm -n $name    -i ~/vms/base/$base.img  -k ~/.ssh/id_ed25519.pub -s 40
ip=`./get-vm-ip $name`
ssh kubespray@$ip
echo virsh destroy $name
echo cd prep-img
echo ./rebase.sh $name $name /root
