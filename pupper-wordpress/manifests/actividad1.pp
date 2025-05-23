#$document_root = '/vagrant'
$document_root = '/var/www/html'
$db_user = 'wordpressuser'
$db_password = 'wordpress123ABC'
$db_name = 'wordpress'

include apache
exec { 'Intall apache2':
  command => "echo ‘Este mensaje sólo se muestra si no se ha copiado el fichero index.html'",
  unless => "test -f ${document_root}/index.html",
  path => "/bin:/sbin:/usr/bin:/usr/sbin",
}

notify { 'Install apache':
  message => "Success",
}

include mysql
notify { 'Install mysql':
  message => "Success",
}

include php
exec { 'Intall php':
  command => "echo ‘Este mensaje sólo se muestra si no se ha copiado el fichero info.php'",
  unless => "test -f ${document_root}/info.php",
  path => "/bin:/sbin:/usr/bin:/usr/sbin",
}
notify { 'Install php':
  message => "Seccess",
}

include wordpress
notify { 'Install wordpress':
  message => "Seccess",
}

#$ipv4_address = $facts['networking']['ip']
$ipv4_address = '192.168.10.106'
$url_wordpress_hosts = 'http://localhost:8080/wordpress/'
notify { 'Showing machine Facts':
  message => "Machine with ${::memory['system']['total']} of memory and ${::processorcount} processor/s.
              Please check access to http://${ipv4_address} y wordpress -> ${url_wordpress_hosts}",
}
