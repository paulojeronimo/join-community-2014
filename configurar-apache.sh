#!/bin/bash
# Author: Paulo Jerônimo (@paulojeronimo, pj@paulojeronimo.info)

THIS_DIR=`cd $(dirname $0); echo -n $PWD`
CONFIG=join-community-2014.conf

verifica_var() {
    local nome_var=$1
    local var=${!nome_var}
    [ "$var" ] || echo "A variável \"$nome_var\" não está configurada em \"~/$CONFIG\"!"
}

if [ -r ~/$CONFIG ]
then
   source ~/$CONFIG
else
   echo "O arquivo \"~/$CONFIG\" não existe ou não pode ser lido!"
   exit 1
fi

verificar_var FEDORA_MIRROR || exit 1
verificar_var APACHE_CONF_DIR || exit 1
verificar_var APACHE_RELOAD_CMD || exit 1

VM_DIR=$THIS_DIR/vm

cat > /tmp/$CONFIG <<EOF
Alias /Fedora/                "$FEDORA_MIRROR/"
Alias /ks                     "$VM_DIR/ks"
Alias /local-mirror.repo      "$VM_DIR/local-mirror.repo"
Alias /configurar-proxy.sh    "$VM_DIR/configurar-proxy.sh"

<Directory "$FEDORA_MIRROR">
  Options Indexes MultiViews
  AllowOverride None
  Require all granted
</Directory>

<Directory "$VM_DIR">
  Options Indexes MultiViews
  AllowOverride None
  Require all granted
</Directory>
EOF

sudo cp /tmp/$CONFIG $APACHE_CONF_DIR/
sudo $APACHE_RELOAD_CMD
