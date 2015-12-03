include_recipe 'rbenv::system'

template '/etc/profile.d/rbenv.sh' do
  owner 'root'
  group 'root'
  mode '644'
end
