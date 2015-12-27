package 'mysql-server mysql-devel' do
  action :install
end

execute 'mysql permittion' do
  command <<-EOL
  chown -R mysql:mysql /var/log/mysql
  chown -R mysql:mysql /var/lib/mysql
  EOL
end

execute 'my.cnf backup' do
  command 'mv /etc/my.cnf{,.org}'
  not_if "test -f /etc/my.cnf.org"
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
  mysqladmin -u root password "root"
  mysql -u root -proot -e "DELETE FROM mysql.user WHERE User='';"
  mysql -u root -proot -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1');"
  mysql -u root -proot -e "DROP DATABASE test;"
  mysql -u root -proot -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';"
  mysql -u root -proot -e "FLUSH PRIVILEGES;"
  EOL
end
