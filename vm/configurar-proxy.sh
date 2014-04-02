#!/bin/bash
# Author: Paulo Jerônimo (@paulojeronimo, pj@paulojeronimo.info)
#
# Obs: esse script está configurado, até o momento, para trabalhar 
# com proxies que não solicitam usuário/senha (meu caso)
set +x

# Configure os parâmetros default para seu proxy nas linhas abaixo:
PROXY_IP=${PROXY_IP:-10.196.19.41}
PROXY_PORT=${PROXY_PORT:-3128}
PROXY="proxy:$PROXY_PORT"

confirma() {
  read -r -p "Confirma? (s/N) " resposta
  resposta=${resposta,,}
  if [[ $resposta =~ ^(sim|s)$ ]]
  then
    true
  else
    false
  fi
}

while true
do
  [ "$PROXY_IP" ] || read -p "Informe o IP do proxy: " PROXY_IP
  echo -n "IP informado para o proxy: \"$PROXY_IP\". "
  confirma && break
  unset PROXY_IP
done

f=/etc/hosts
grep -v '[[:space:]]proxy$' $f | sudo tee $f > /dev/null
echo -e "$PROXY_IP\tproxy" | sudo tee -a $f > /dev/null
echo "Proxy configurado em $f!"

f=/etc/profile.d/proxy.sh
sudo tee "$f" > /dev/null <<EOF
#!/bin/bash

export http_proxy=http://$PROXY
export https_proxy=http://$PROXY
export ftp_proxy=http://$PROXY
export RSYNC_PROXY=$PROXY
export no_proxy="localhost,127.0.0.1"
EOF
echo "Proxy configurado em $f!"

f=/etc/yum.conf
grep -v '^proxy=' $f | sudo tee $f > /dev/null
echo -e "proxy=http://$PROXY" | sudo tee -a $f > /dev/null
echo "Proxy configurado em $f!"

echo -e "\nRefaça seu login!"
