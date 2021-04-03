#!/bin/sh


install() {
	i=$1;
if ! [ -f $i.tar.gz ];
then
wget https://aur.archlinux.org/cgit/aur.git/snapshot/$i.tar.gz
tar -zxvf $i.tar.gz
fi
cp -rv config/$i/* $i/
cd $i/
makepkg -sci || {
	read -p "Do you want to disable verify checks? " prompt;
	if [[ $prompt == "y" ]];
	then
	makepkg -sci --skipinteg;
	fi
}
}

ARGS=$*
if [[ -z $ARGS ]]
then
for i in $(cat Packages);
do
	install $i
done
else
	for i in $ARGS;
	do
		install $i;
	done
fi
