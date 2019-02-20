values_hash = {}
values_hash['!'] = '-- select from list --'
hosts_inventory = $evm.vmdb('Host').all

hosts_inventory.each do |this_host|
  next if this_host.type != "ManageIQ::Providers::Vmware::InfraManager::HostEsx"
    this_host.lans.each do |this_host_lans|
      values_hash[this_host_lans.name] = this_host_lans.name + " (" + this_host_lans.switch.name + ")" 

    end
end

list_values = {
   'sort_by'    => :value,
   'data_type'  => :string,
   'required'   => true,
   'values'     => values_hash
}
list_values.each { |key, value| $evm.object[key] = value }

exit MIQ_OK
