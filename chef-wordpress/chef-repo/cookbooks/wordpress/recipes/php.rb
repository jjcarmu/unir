%w(php php-mysql libapache2-mod-php php-cli php-curl php-gd php-mbstring php-xml php-xmlrpc).each do |pkg|
  package pkg
end

service 'apache2' do
  action :restart
end
