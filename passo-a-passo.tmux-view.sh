tmux new -d '\
lynx -dont_wrap_pre -dump \
https://github.com/paulojeronimo/join-community-2014/blob/master/passo-a-passo.adoc | \
sed "1,/Guia, passo a passo/d" | tac | sed "1,/Jump to Line/d" | tac | \
view -' \; splitw -d \; attach
