#!/bin/sh
# Skript le-checkout.sh 

#for i in $@ ; do
#echo $2>>a #############################################################!!!!!!!!!!!!!!!!!!!!!!!!! v a mam ulozenu cestu projdir


projdir=$1  #cat a|tr '\n' ' '|
#ulozenie adries adresarov
exp=`pwd`

#zistenie ci uz existuje .le a . config
test -d .le
a=$?
 if [ $a -eq 0 ]; then
	cd .le

#.le existuje zmazanie vsetkych suborov co niesu skryte v nej
	sub=`ls -p| egrep -v /$|tr '\n' ' '`
	rm -r $sub
	test -f .le/.config
	b=$?
		if [ $b -eq 0 ]	
			then
#nahradenie riadku projdir cesta k projektu 
			cat .config|sed "/^projdir /d" >a
			echo $projdir>>a
			cp a .config
			rm -r a
#ziskanie to co sa nachadza v configu pod ignore , odstranenie ignore a ten zoznam suborov nech mi ulozi
			cat .config|grep ^ignore" "|sed 's/ignore //'>ignorovacie
		else  #ak.config neexistuje vytvor ho s tymito argumentami
			echo -e "projdir $projdir\nignore le-checkout.sh\nignore le-update.sh\nignore le-revert.sh\nignore le-diff.sh" >.config
			cat .config|grep ^ignore" "|sed 's/ignore //'>ignorovacie
			cd ..
		fi		
 else
	mkdir \ .le 
	cd .le
	echo -e "projdir $projdir\nignore .config\nignore le-checkout.sh\nignore le-update.sh\nignore le-revert.sh\nignore le-diff.sh" >.config
	cat .config|grep ^ignore" "|sed 's/ignore //'>ignorovacie
	cd ..
 fi

#konecne praca s projdir
#z nazvov v adresari projdir filtracia suborov a ich nasledna filtracia iba nazvy okrem ignore, ktore sa maju kopirovat
cd $projdir
ls -p| egrep -v /$>pomocna

#z adresara projdir vyfiltrujem subory, porovnam ich s ignore odstranim tie co su zhodne a ostatne nakopirujem do exp a ref
	cd $exp
	platne=`diff -u $projdir/pomocna .le/ignorovacie|sed "/^ /d"|sed "/^--- /d"|sed "/^+++ /d"|sed "/^@@ /d" |sed "/^+/d"|sed "s/^-//"`
	#	echo `diff -u pomocna .le/ignorovacie`
	
if [ $? -eq 0 ]
 then
# echo $platne
	cd $projdir
	cp $platne $exp
	cp $platne $exp/.le
	#cp "Untitled Document 1" $exp/.le
	rm -r $projdir/pomocna $exp/.le/ignorovacie

fi










	
		

	

