
# Actividad 02: Instalación de WordPress con Chef y Pruebas Automatizadas

Este proyecto implementa la **automatización del despliegue de WordPress** usando **Chef**, **Vagrant** y pruebas con **ChefSpec** e **InSpec** a través de **Test Kitchen**.

---

## Estructura del Proyecto

```
ACTIVIDAD_02/
├── chef-repo/
│   ├── cookbooks/
│   │   └── wordpress/
│   │       ├── attributes/
│   │       │   └── default.rb
│   │       ├── files/
│   │       │   └── index-unir.html
│   │       ├── recipes/
│   │       │   ├── apache.rb
│   │       │   ├── default.rb
│   │       │   ├── mysql.rb
│   │       │   ├── php.rb
│   │       │   └── wordpress.rb        
│   │       ├── spec/unit/recipes/
│   │       │   ├── default_spec.rb
│   │       │   └── spec_helper.rb
│   │       ├── templates/
│   │       │   ├── virtual-hosts.conf.erb
│   │       │   └── wp-config.php.erb
│   │       └── test/integration/default/
│   │           └── default_test.rb
│   └── kitchen.yml
└── Vagrantfile
```

---

## Requisitos

- [Chef Workstation](https://www.chef.io/products/chef-workstation)
- [Vagrant](https://www.vagrantup.com/)
- [VirtualBox](https://www.virtualbox.org/)

---

## Pasos para Ejecutar el Proyecto

### 1. Iniciar la máquina virtual

Desde la raíz del proyecto donde se encuentra el `Vagrantfile`:

```bash
vagrant up
```

> Esto levantará la máquina virtual base.

---

### 2. Ejecutar pruebas unitarias con ChefSpec

Ubícate en el directorio del cookbook `wordpress`:

```bash
cd .\chef-repo\cookbooks\wordpress
chef exec rspec -p
```

> Ejecuta pruebas de unidades sobre las recetas Chef.

---

### 3. Ejecutar pruebas de integración con Test Kitchen

Ubícate en la carpeta `chef-repo` donde se encuentra el archivo `kitchen.yml`:

```bash
cd .\chef-repo
kitchen test
```

> Este comando ejecuta:
>
> - `kitchen create`: crea la máquina virtual.
> - `kitchen converge`: aplica el cookbook.
> - `kitchen verify`: ejecuta pruebas con InSpec.
> - `kitchen destroy`: elimina la máquina.

---

## Integrantes del equipo

- Juan Angel Ruiz Reyes
- Jhon Javier Cardona Munoz
- Fidel Herney Palacios Cuacialpud