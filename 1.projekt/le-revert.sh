#!/bin/sh
# Skript le-revert.sh

#zistenie [FILE] !!potreba prepracovat hodne


rm -f .parametre
touch .parametre
for i in $@ ; do
echo $i>>.parametre #############################################################!!!!!!!!!!!!!!!!!!!!!!!!!
done

exp=`pwd`
file=`wc .parametre -c|sed 's/ .*//'`

if [ $file -eq 0 ]
 then
	cd .le
	kopirovacie=`ls -p| egrep -v /$`
	cd ..
 else
	kopirovacie=`cat .parametre|tr '\n' ' '|sed 's/$ //'`
fi
cd .le
cp $kopirovacie $exp
#platne=`diff -u pomocna ignorovacie|sed "/^ /d"|sed "/^--- /d"|sed "/^+++ /d"|sed "/^@@ /d" |sed "s/^+//"|sed "s/^-//"|tr '\n' ' '`
cd ..
rm -f .parametre
#if [ $platne != 0 ]
 #then
#	cp $platne $exp
#fi

