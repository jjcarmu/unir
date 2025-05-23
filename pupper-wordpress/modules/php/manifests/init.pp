class php {
  package {
    ['php', 'libapache2-mod-php', 'php-mysql', 'php-curl', 'php-gd', 'php-mbstring', 'php-xml', 'php-xmlrpc', 'php-soap', 'php-intl', 'php-zip']: 
    ensure => installed,
    require => Package['apache2']
  }

  file { "${document_root}/info.php":
    ensure  => present,
    source => 'puppet:///modules/php/info.php',
    require => Package['php'],
  } 

}
