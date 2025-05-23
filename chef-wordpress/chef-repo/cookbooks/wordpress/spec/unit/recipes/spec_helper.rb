# spec/spec_helper.rb

require 'chefspec'

# Stubs para comandos ejecutados en recetas
RSpec.configure do |config|
  config.before(:each) do
    stub_command("mysql -u root -e 'SHOW DATABASES LIKE \"wordpress\";' | grep wordpress").and_return(false)
    stub_command("wp core is-installed --allow-root --path=/var/www/html").and_return(false)
    stub_command("wp post list --post_type=page --allow-root --format=csv --fields=post_title | grep '^Actividad 02$'").and_return(false)
    stub_command("wp option get page_on_front --path=/var/www/html --allow-root | grep -w 4").and_return(false)
  end
end