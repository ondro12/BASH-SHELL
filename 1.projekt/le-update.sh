#!/bin/sh
# Skript le-update.sh

#zistenie [FILE]
for i in $@ ; do
echo $i>>a
done


#zistenie adries ref exp projdir a ulozenie do premennych
exp=pwd
cd .le
ref=pwd
cat .config|grep ^ignore" "|sed 's/^ignore //'>ignorovacie
projdir=cat .config|grep ^projdir |sed 's/projdir //'
cd ..
#zadanie za 1. subor je rovnaky v projdir exp a ref kopii zistenie 
rozdiel=diff -u $exp/a $ref/a $projdir/a|sed "/^ /d"|sed "/^--- /d"|sed "/^+++ /d"|sed "/^@@ /d" |sed "s/^+//"|sed "s/^-//"|tr '\n' ' '|sed 's/.* .*//'|wc -m
	if $rozdielf==0
		then
		echo \.\: $a #ak je subor rovnaky aj v exp,projdir,.le
		rm -r a
	else 
#otestujem ci su rovnake subory v niektorom z tychto pripadov
		rozdielprojref=diff -u $ref/a $projdir/a|sed "/^ /d"|sed "/^--- /d"|sed "/^+++ /d"|sed "/^@@ /d" |sed "s/^+//"|sed "s/^-//"|tr '\n' ' '|sed 's/.* .*//'|wc -m
		rozdielprojexp=diff -u $exp/a $projdir/a|sed "/^ /d"|sed "/^--- /d"|sed "/^+++ /d"|sed "/^@@ /d" |sed "s/^+//"|sed "s/^-//"|tr '\n' ' '|sed 's/.* .*//'|wc -m
		rozdielrefexp=diff -u $ref/a $exp/a|sed "/^ /d"|sed "/^--- /d"|sed "/^+++ /d"|sed "/^@@ /d" |sed "s/^+//"|sed "s/^-//"|tr '\n' ' '|sed 's/.* .*//'|wc -m

	if $rozdielprojref==0
		then
		echo M\: $a #ak je subor rovnaky aj v exp,projdir,.le
		
	elif $rozdielprojexp==0
		echo UM\: $a
		cp $projdir/a $ref/a
	
	elif $rozdielrefexp==0
		cp $projdir/a $exp/a $ref/a
		echo U\: $a
	else
#zisti zmeny v projdir oproti ref
	diff -u $projdir/a $ref/a|sed "/^ /d"|sed "/^--- /d"|sed "/^+++ /d"|sed "/^@@ /d" |sed "s/^+//"|sed "s/^-//">$exp/a>zmenyvref
	patch $exp/a zmenyvref
	priebeh=echo $
		if $priebeh==0
			then
			cp zmenyvref $exp/a
			echo M\+\: $a
			rm -r zmenyvref
		else
			echo M\!\: $a conflict!
			rm -r zmenyvref
		fi
	cat $projdir/a
		uspech=echo $	
		if $uspech==0
			then 
			cat $exp/a
			vexp=echo $
			if $vexp=!0
				then
				cp $projdir/a $exp/a
				echo C\: $a
			fi
		else
			cat $ref/a
			exref=echo $
			if $exref==0
				then			
				echo D\: $a
				rm -r $exp/a $ref/a
			fi
	fi
