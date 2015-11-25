install_packages = %w(git gcc openssl-devel libyaml-devel libffi-devel
readline-devel zlib-devel gdbm-devel ncurses-devel)

install_packages.each do |p|
  package p
end

git '/usr/local/rbenv' do
  repository 'https://github.com/rbenv/rbenv.git'
end

git '/usr/local/rbenv/plugins/ruby-build' do
  repository 'https://github.com/rbenv/ruby-build.git'
end

template '/etc/profile.d/rbenv.sh' do
  owner 'root'
  group 'root'
  mode '644'
end
