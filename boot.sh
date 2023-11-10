#!/bin/sh

# Defina variáveis de ambiente
export STARTUP="firefox http://localhost/index.html"

# Iniciar o Firefox com a URL especificada
$STARTUP

# Inicie o servidor web BusyBox sem a opção -h
/bin/busybox httpd -f -p 80 -h /flash

# Libera o terminal
exec "$@"

