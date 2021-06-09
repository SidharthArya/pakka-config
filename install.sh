#!/bin/sh


install() {
	i=$1;
if ! [ -f $i.tar.gz ];
then
	wget https://aur.archlinux.org/cgit/aur.git/snapshot/$i.tar.gz
	tar -zxvf $i.tar.gz
	cd $i/
	if [ -d ../config/$i/srcpatch ];
	then
		echo "Patching..."
		for j in $(ls "../config/$i/srcpatch");
		do
			patch < "../config/$i/srcpatch/$j" &&
				echo "Patched $j !" || echo "Failed Patch $j !"
		done
	fi
else
	tar -zxvf $i.tar.gz
	cd $i/
	if [ -d ../config/$i/srcpatch ];
	then
		echo "Patching..."
		for j in $(ls "../config/$i/srcpatch");
		do
			patch < "../config/$i/srcpatch/$j" &&
				echo "Patched $j !" || echo "Failed Patch $j !"
		done
	fi
fi
if [ -d ../config/$i/copy ];
then
	cp -rv ../config/$i/copy/* ./
fi

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
