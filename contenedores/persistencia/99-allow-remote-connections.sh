#!/bin/bash
set -e

# Modificar postgresql.conf para escuchar en todas las interfaces de red
echo "listen_addresses = '*'" >> "$PGDATA/postgresql.conf"

# Modificar pg_hba.conf para permitir conexiones desde cualquier IP con contraseña
# La línea 'host all all all md5' permite a cualquier usuario ('all') conectarse a cualquier base de datos ('all')
# desde cualquier dirección IP ('all' o '0.0.0.0/0') usando autenticación por contraseña (md5).
echo "host all all all md5" >> "$PGDATA/pg_hba.conf"