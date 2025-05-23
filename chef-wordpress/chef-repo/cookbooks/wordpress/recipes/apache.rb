apt_update 'Update the apt cache daily' do
    frequency 86_400
    action :periodic
  end
  
  # package 'apache2'
  execute 'install apache2 without prompt' do
    command 'DEBIAN_FRONTEND=noninteractive apt-get install -y apache2'
  end
  
  service 'apache2' do
    supports status: true
    action :nothing
  end
  
  file '/etc/apache2/sites-enabled/000-default.conf' do
    action :delete
  end
  
  template '/etc/apache2/sites-available/wordpress.conf' do
    source 'virtual-hosts.conf.erb'
    notifies :restart, 'service[apache2]'
  end
  
  link '/etc/apache2/sites-enabled/wordpress.conf' do
    to '/etc/apache2/sites-available/wordpress.conf'
    notifies :restart, 'service[apache2]'
  end
  