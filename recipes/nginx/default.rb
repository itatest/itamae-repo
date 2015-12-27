node.validate! do
  {
    nginx: {
      upstreamIp: string,
      upstreamPort: string,
    },
  }
end

package 'nginx' do
  action :install
end

service "nginx" do
  action [:enable, :restart]
  subscribes :reload, "template[/etc/nginx/conf.d/app.conf]"
end

#file "/etc/nginx/conf.d/default.conf.org" do
#  content_file "/etc/nginx/conf.d/default.conf"
#end

execute "backup default.conf" do
  command "mv /etc/nginx/conf.d/default.conf{,.org}"
  only_if "test -f /etc/nginx/conf.d/default.conf"
end

#file "delete default.conf" do
#  path "/etc/nginx/conf.d/default.conf"
#  action :delete
#end

template "/etc/nginx/conf.d/app.conf" do
  source "templates/etc/nginx/conf.d/app.conf.erb"
  mode "644"
  owner "root"
  group "root"
end
