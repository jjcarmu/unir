class wordpress {

  $wordpress_url = 'https://wordpress.org/latest.tar.gz'

  $url           = 'http://localhost:8080'
  $wp_title      = 'Actividad 1 : Jhon Javier Cardona Muñoz'
  $admin_user    = 'admin'
  $admin_password = 'admin'
  $admin_email   = 'admin@gmail.com'
  $path          = "${document_root}/wordpress"
  $allow_root    = true
  
  exec { 'download-wordpress':
    command => "/usr/bin/wget -q -O /opt/wordpress.tar.gz ${wordpress_url}", 
    creates => '/opt/wordpress.tar.gz', 
    path    => '/usr/bin:/bin:/usr/sbin:/sbin', 
    require => Package['apache2'], 
  }

  exec { 'extract-wordpress':
    command => "/bin/tar -xzvf /opt/wordpress.tar.gz -C ${document_root}",
    creates => "${document_root}/wordpress", 
    require => Exec['download-wordpress'], 
    path    => '/bin:/usr/bin:/sbin:/usr/sbin',
  }

  exec { 'generate-auth-keys':
    command => 'curl -s https://api.wordpress.org/secret-key/1.1/salt/ > /tmp/wp-keys.php',
    creates => '/tmp/wp-keys.php', 
    path    => '/usr/bin:/bin:/usr/sbin:/sbin',
  }

  file { "${document_root}/wordpress/wp-config.php":
      ensure  => file,
      content => template('wordpress/wp-config.php.erb'),
      require => [Exec['generate-auth-keys'], Exec['extract-wordpress']],
  }

  exec { 'set-wordpress-permissions':
    command => '/bin/chown -R www-data:www-data /var/www/html/wordpress',
    require => Exec['extract-wordpress'], 
    path    => '/bin:/usr/bin:/sbin:/usr/sbin', 
  }

  exec { 'install-wp-cli':
      command => 'curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp',
      creates => '/usr/local/bin/wp', 
      path    => '/usr/bin:/bin:/usr/sbin:/sbin', 
      require => Exec['create-wordpress-db'], 
  }

  exec { 'wordpress-install':
      command => "wp core install --url=\"${url}\" --title=\"${wp_title}\" --admin_user=\"${admin_user}\" --admin_password=\"${admin_password}\" --admin_email=\"${admin_email}\" --path=${path} --allow-root=${allow_root}",
      path    => '/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin', 
      require => [File["${document_root}/wordpress/wp-config.php"], Exec['install-wp-cli']], 
    }

  file { '/etc/mysql/wordpress-content.sql':
    ensure  => present,
    content => template('wordpress/wordpress-content.sql.erb'), 
    require => Exec['wordpress-install'], 
  }

  exec { 'initialize-wordpress-content':
    command => '/usr/bin/mysql < /etc/mysql/wordpress-content.sql', 
    unless  => "/usr/bin/mysql -e 'SELECT * FROM ${db_name}.wp_posts WHERE post_title=\"Bienvenido\";'", 
    require => File['/etc/mysql/wordpress-content.sql'], 
  }  

}
