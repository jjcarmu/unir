# Pruebas de Integración con Serverspec y Test Kitchen
# Estas pruebas validan que WordPress esté correctamente instalado y configurado en Ubuntu y CentOS.

# Verifica que el servicio Apache esté habilitado y corriendo (apache2 o httpd).
describe.one do
  describe service('apache2') do
    it { should be_enabled }
    it { should be_running }
  end

  describe service('httpd') do
    it { should be_enabled }
    it { should be_running }
  end
end

# Verifica que el puerto 80 (HTTP) esté en escucha para acceder a la página de WordPress.
describe port(80) do
  it { should be_listening }
end

# Verifica que el servicio MySQL esté habilitado y corriendo (mysql o mysqld).
describe.one do
  describe service('mysql') do
    it { should be_enabled }
    it { should be_running }
  end

  describe service('mysqld') do
    it { should be_enabled }
    it { should be_running }
  end
end

# Verifica que el archivo de configuración de PHP exista.
describe.one do
  describe file('/etc/php/7.4/apache2/php.ini') do
    it { should exist }
  end

  describe file('/etc/php.ini') do
    it { should exist }
  end
end

# Verifica que el archivo wp-config.php esté presente.
describe file('/var/www/html/wp-config.php') do
  it { should exist }
  it { should be_file }
end

# Verifica que el sitio responda correctamente con código HTTP 200.
describe command('curl -L -s -o /dev/null -w "%{http_code}" http://localhost') do
  its(:stdout) { should match(/200|301/) }
end

