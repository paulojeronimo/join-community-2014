#!/bin/bash
# Author: Paulo Jerônimo (@paulojeronimo, pj@paulojeronimo)
#
# Faz o download e verifica o SHA1SUM dos arquivos baixados
# Uso comum: $ bash <(http://j.mp/vm-fedora-download)

host=https://googledrive.com/host/0B_tTlCk55SmjZGlNckhCRldUUDQ

for f in 00{1..COUNT} vm-fedora.sha1sum
do
    case $f in
      *[!0-9]*) :;;
      *) f=vm-fedora.7z.$f;;
    esac
    echo -e "\nBaixando $f ..."
    curl -C - -O $host/$f
done

if [ -f $f ]
then
    echo -e "\nVerificando o download ..."
    case `uname` in
        Darwin) sha1sum=shasum;;
        Linux) sha1sum=sha1sum;;
    esac
    $sha1sum -c $f
    [ $? = 0 ] && { echo -e "\nOk! Download concluído com sucesso!"; exit 0; }
fi
echo -e "\nErro no download! :( Tente novamente!"
exit 1
