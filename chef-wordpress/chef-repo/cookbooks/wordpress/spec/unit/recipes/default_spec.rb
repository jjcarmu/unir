require_relative 'spec_helper'

# apache_spec
describe 'wordpress::apache' do
  context 'con atributos por defecto' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '20.04').converge('wordpress::apache')
    end

    it 'ejecuta la instalación de apache2 con apt' do
      expect(chef_run).to run_execute('install apache2 without prompt')
    end

    it 'declara el servicio apache2 sin acción por defecto' do
      expect(chef_run).to_not start_service('apache2')
    end
  end
end

# mysql_spec
describe 'wordpress::mysql' do
  context 'con atributos por defecto' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '20.04').converge('wordpress::mysql')
    end

    it 'instala el paquete mysql-server' do
      expect(chef_run).to install_package('mysql-server')
    end

    it 'habilita el servicio mysql' do
      expect(chef_run).to enable_service('mysql')
    end
  end
end

# php_spec
describe 'wordpress::php' do
  context 'con atributos por defecto' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '20.04').converge('wordpress::php')
    end

    it 'instala php y módulos necesarios' do
      %w[php php-mysql libapache2-mod-php].each do |pkg|
        expect(chef_run).to install_package(pkg)
      end
    end
  end
end

# wordpress_spec
describe 'wordpress::wordpress' do
  context 'con atributos por defecto' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '20.04').converge('wordpress::wordpress')
    end

    it 'descarga WordPress desde la web oficial' do
      expect(chef_run).to create_remote_file('/tmp/wordpress.tar.gz')
    end

  end
end

# common_spec
describe 'wordpress::default' do
  context 'con inclusión de recetas' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '20.04').converge('wordpress::default')
    end

    it 'incluye la receta de apache' do
      expect(chef_run).to include_recipe('wordpress::apache')
    end

    it 'incluye la receta de mysql' do
      expect(chef_run).to include_recipe('wordpress::mysql')
    end

    it 'incluye la receta de php' do
      expect(chef_run).to include_recipe('wordpress::php')
    end

    it 'incluye la receta de wordpress' do
      expect(chef_run).to include_recipe('wordpress::wordpress')
    end
  end
end
