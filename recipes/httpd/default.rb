#default-value
#node.reverse_merge!({
#  'httpd' => {
#    "serverAdmin"=>"hoge@mana.huga.ne.jp",
#    "serverName"=>"hugaWeb",
#  }
#})

#validate
node.validate! do
  {
    httpd: {
      serverAdmin: string,
      serverName: string,
    },
  }
end

package "httpd" do
  action :install
end

service "httpd" do
  action :start
  subscribes :reload,"template[/etc/httpd/conf/httpd.conf]"
end

template "/etc/httpd/conf/httpd.conf" do
  action :create
  source "templates/httpd.conf.erb"
  owner "root"
  group "root"
  mode "664"
end

execute "chkconfig httpd on" do
  action :run
  only_if "test -n `chkconfig --list | grep 3:on | grep httpd`"
end
