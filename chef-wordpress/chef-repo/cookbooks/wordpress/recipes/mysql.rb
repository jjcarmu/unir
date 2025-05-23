package 'mysql-server' do
  action :install
end

service 'mysql' do
  action [:enable, :start]
end

execute 'create-wordpress-db' do
  command <<-EOH
    mysql -u root -e "CREATE DATABASE IF NOT EXISTS #{node['wordpress']['db_name']};"
    mysql -u root -e "CREATE USER IF NOT EXISTS '#{node['wordpress']['db_user']}'@'localhost' IDENTIFIED BY '#{node['wordpress']['db_password']}';"
    mysql -u root -e "GRANT ALL PRIVILEGES ON #{node['wordpress']['db_name']}.* TO '#{node['wordpress']['db_user']}'@'localhost';"
    mysql -u root -e "FLUSH PRIVILEGES;"
  EOH
  not_if "mysql -u root -e 'SHOW DATABASES LIKE \"#{node['wordpress']['db_name']}\";' | grep #{node['wordpress']['db_name']}"
end
