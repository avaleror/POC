#
# Description: This method is used to Customize the VMware, RHEV, RHEV PXE, and RHEV ISO Provisioning Request
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

# Get provisioning object
prov = $evm.root["miq_provision"]

# this is only needed if the Foreman code is enabled
#$evm.log("info", "Disabling VM Autostart")
#prov.set_option(:vm_auto_start,[false,0])

dialog_vmname = prov.get_option(:dialog_vmname)
if not dialog_vmname.nil?
  $evm.log("info", "Setting VM name to: #{dialog_vmname}")
  prov.set_option(:vm_target_name,dialog_vmname)
end

# If using a multiple bundle with two VMs, this is the way to get second vm name and override it when
# second VM is provisioning and first one has been provisioned
vm = $evm.vmdb('vm').find_by_name(dialog_vmname)
dialog_vmname2 = prov.get_option(:dialog_vm_name)
if not dialog_vmname2.nil? and not vm.nil?
  $evm.log("info", "Setting VM name to: #{dialog_vmname2}")
  prov.set_option(:vm_target_name,dialog_vmname2)
end
  
dialog_fqdn = prov.get_option(:dialog_fqdn)
if not dialog_fqdn.nil?
  $evm.log("info", "Setting FQDN to: #{dialog_fqdn}")
  prov.set_option(:vm_target_hostname,dialog_fqdn)
end

# Same that in VM name but for FQDN
dialog_fqdn2 = prov.get_option(:dialog_fqdn2)
if not dialog_fqdn.nil? and not vm.nil?
  $evm.log("info", "Setting FQDN2 to: #{dialog_fqdn2}")
  prov.set_option(:vm_target_hostname,dialog_fqdn2)
end


$evm.log("info", "Provisioning ID:<#{prov.id}> Provision Request ID:<#{prov.miq_provision_request.id}> Provision Type: <#{prov.provision_type}>")

# get user specified options from dialog
tshirtsize = prov.get_option(:dialog_tshirtsize)
vm_memory = prov.get_option(:dialog_memory)
vm_cores = prov.get_option(:dialog_cores)
    
case tshirtsize
when "S"
    prov.set_option(:vm_memory,2048)
    prov.set_option(:cores_per_socket,1)
    $evm.log("info", "T-Shirt Size Small: 1 Core, 2 GB RAM")

when "M"
    prov.set_option(:vm_memory,4096)
    prov.set_option(:cores_per_socket,2)
    $evm.log("info", "T-Shirt Size Medium: 2 Cores, 4 GB RAM")

when "L"
    prov.set_option(:vm_memory,4096)
    prov.set_option(:cores_per_socket,4)
    $evm.log("info", "T-Shirt Size Large: 4 Cores, 4 GB RAM")

when "XL"
    prov.set_option(:vm_memory,8192) 
    prov.set_option(:cores_per_socket,4)
    $evm.log("info", "T-Shirt Size Extra Large: 4 Cores, 8 GB RAM")

else 
    $evm.log("warn", "Unkonwn T-Shirt Size!")
end

if vm_memory.to_i > 0
    prov.set_option(:vm_memory,vm_memory.to_i * 1024)
    $evm.log("info", "Memory Override: #{vm_memory}")
end
if vm_cores.to_i > 0
    prov.set_option(:cores_per_socket,vm_cores.to_i)
    $evm.log("info", "Cores Override: #{vm_cores}")
end

# IP manual selection for Redsys
dialog_ip_addr = prov.get_option(:dialog_ip_addr)

if not dialog_ip_addr.nil?
  $evm.log("info", "Selected IP : #{dialog_ip_addr}")
  prov.set_option(:subnet, "255.255.255.0")
  $evm.log("info", "Selected Subnet Mask : 255.255.255.0")
  
  case dialog_ip_addr
  when "1"
  	 prov.set_option(:ip_addr, "10.129.254.201")
     $evm.log("info", "VM´s IP: 10.129.254.201")
  when "2"
  	 prov.set_option(:ip_addr, "10.129.254.202")
     $evm.log("info", "VM´s IP: 10.129.254.202")
  when "3"
  	 prov.set_option(:ip_addr, "10.129.254.203")
     $evm.log("info", "VM´s IP: 10.129.254.203")
  when "4"
  	 prov.set_option(:ip_addr, "10.129.254.204")
     $evm.log("info", "VM´s IP: 10.129.254.204")
  when "5"
  	 prov.set_option(:ip_addr, "10.129.254.205")
     $evm.log("info", "VM´s IP: 10.129.254.205")
  end
else
	$evm.log("warn", "IP unknown or not suministrated")
end

# this is just a fail safe to make sure we have only one socket
prov.set_option(:number_of_sockets, 1)

prov.attributes.sort.each { |k,v| $evm.log("info", "Prov attributes: #{v}: #{k}") }
