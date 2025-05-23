remote_file '/tmp/wordpress.tar.gz' do
  source 'https://wordpress.org/latest.tar.gz'
  action :create
end

bash 'extract-wordpress' do
  cwd '/tmp'
  code <<-EOH
    tar -xzf wordpress.tar.gz
    cp -r wordpress/* #{node['wordpress']['web_root']}
    chown -R www-data:www-data #{node['wordpress']['web_root']}
  EOH
end

file "#{node['wordpress']['web_root']}/index.html" do
  action :delete
end

template "#{node['wordpress']['web_root']}/wp-config.php" do
  source 'wp-config.php.erb'
  variables(
    db_name: node['wordpress']['db_name'],
    db_user: node['wordpress']['db_user'],
    db_password: node['wordpress']['db_password'],
    db_host: node['wordpress']['db_host']
  )
end

remote_file '/usr/local/bin/wp' do
  source 'https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar'
  mode '0755'
  action :create
end

bash 'install-wordpress-core' do
  cwd node['wordpress']['web_root']
  code <<-EOH
    wp core install --url="http://localhost:8042" \\
      --title="Mi Sitio WordPress" \\
      --admin_user="admin" \\
      --admin_password="admin123" \\
      --admin_email="admin@example.com" \\
      --allow-root
  EOH
  environment({
    'PATH' => '/usr/local/bin:/usr/bin:/bin',
    'HOME' => '/root'
  })
  not_if "wp core is-installed --allow-root --path=#{node['wordpress']['web_root']}"
end

cookbook_file '/tmp/index-unir.html' do
  source 'index-unir.html'
  owner 'root'
  group 'root'
  mode '0644'
end

bash 'create-home-page' do
  cwd node['wordpress']['web_root']
  code <<-EOH
    CONTENT=$(cat /tmp/index-unir.html | sed 's/\"/\\\\\"/g')
    wp post create --post_type=page --post_title="Actividad 02" --post_status=publish \\
      --post_content="$CONTENT" --allow-root
  EOH
  environment({
    'PATH' => '/usr/local/bin:/usr/bin:/bin',
    'HOME' => '/root'
  })
  not_if "wp post list --post_type=page --allow-root --format=csv --fields=post_title | grep '^Actividad 02$'"
end

bash 'set-home-page' do
  cwd node['wordpress']['web_root']
  code <<-EOH
    wp option update show_on_front 'page' --path=#{node['wordpress']['web_root']} --allow-root
    wp option update page_on_front 4 --path=#{node['wordpress']['web_root']} --allow-root
  EOH
  environment({
    'PATH' => '/usr/local/bin:/usr/bin:/bin',
    'HOME' => '/root'
  })
  not_if "wp option get page_on_front --path=#{node['wordpress']['web_root']} --allow-root | grep -w 4"
end

