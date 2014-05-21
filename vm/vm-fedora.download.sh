#!/bin/bash
# Author: Paulo Jerônimo (@paulojeronimo, pj@paulojeronimo)
#
# Faz o download e verifica o SHA1SUM dos arquivos baixados
# Uso comum: $ bash <(http://j.mp/vm-fedora-download)

host=https://googledrive.com/host/0B_tTlCk55SmjZGlNckhCRldUUDQ

for f in 00{1..COUNT}
do
    f=vm-fedora.7z.$f
    echo -e "\nBaixando $f ..."
    curl -C - -O $host/$f
done

case `uname` in
    Darwin) sha1sum=shasum;;
    Linux) sha1sum=sha1sum;;
esac

f=vm-fedora.sha1sum
if [ -f $f ]
then
    echo -e "\nVerificando o download ..."
    $sha1sum -c $f
    [ $? = 0 ] && { echo -e "\nOk! Download concluído com sucesso!"; exit 0; }
fi
echo -e "\nErro no download! :( Tente novamente!"
exit 1
