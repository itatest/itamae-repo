remote_file '/etc/yum.repos.d/mariadb.repo' do
  source 'remote_files/etc/yum.repos.d/mariadb.repo'
  mode '644'
  owner 'vagrant'
  group 'vagrant'
end

package 'MariaDB-devel MariaDB-client MariaDB-server' do
  action :install
end

execute 'mariadb permition' do
  command <<-EOL
  chown -R mysql:mysql /var/log/mariadb
  chown -R mysql:mysql /var/lib/mysql
  EOL
end

execute 'my.cnf backup' do
  command 'mv /etc/my.cnf /etc/my.cnf.org'
end

remote_file "/etc/my.cnf" do
  owner "root"
  group "root"
  source "remote_files/etc/my.cnf"
end

service 'mysql' do
  action [:start, :enable]
end

execute "mysql_secure_installation" do
  user "root"
  only_if "mysql -u root -e 'show databases' | grep information_schema" # パスワードが空の場合
  command <<-EOL
  mysqladmin -u root password "password"
  mysql -u root -ppassword -e "DELETE FROM mysql.user WHERE User='';"
  mysql -u root -ppassword -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1');"
  mysql -u root -ppassword -e "DROP DATABASE test;"
  mysql -u root -ppassword -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';"
  mysql -u root -ppassword -e "FLUSH PRIVILEGES;"
  EOL
end
