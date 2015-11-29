include_recipe '../ruby/ruby.rb'

RBENV_SCRIPT = "/etc/profile.d/rbenv.sh"

directory '/var/itamae' do
  action :create
  mode '755'
  owner 'vagrant'
  group 'vagrant'
end

remote_file '/var/itamae/Gemfile' do
  source 'remote_files/Gemfile'
  mode '644'
  owner 'vagrant'
  group 'vagrant'
end

execute "install rails by bundle" do
  command "source #{RBENV_SCRIPT}; bundle install --gemfile=/var/itamae/Gemfile --path /var/itamae/vendor/bundle; rbenv rehash"
  not_if "test -f /var/itamae/Gemfile.lock"
end

#[
#  {
#    name: "rails",
#    version: node["rails"] ? node["rails"]["version"] : nil
#  }
#].each do |gem_|
#  execute "gem install #{gem_[:name]}" do
#    command "source #{RBENV_SCRIPT}; gem install #{gem_[:name]} #{gem_[:version] ? "-v "+gem_[:version] : ""}; rbenv rehash"
#    not_if "gem list | grep #{gem_[:name]}"
#  end
#end
