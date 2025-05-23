class mysql {
  package {
    'mysql-server': ensure => installed,
  }
    
  service { 
    'mysql': ensure => true,
    enable => true,
    require => Package['mysql-server'],
    restart => "/etc/init.d/mysql restart",
  }

 
  file { '/etc/mysql/database-wordpress.sql':
    ensure  => present, 
    content => template('mysql/database-wordpress.sql.erb'), 
    require => Package['mysql-server'], 
  }

  exec { 'create-wordpress-db':
    command => '/usr/bin/mysql < /etc/mysql/database-wordpress.sql', 
    unless  => "/usr/bin/mysql -e 'USE ${db_name};'", 
    require => File['/etc/mysql/database-wordpress.sql'], 
  }
}
