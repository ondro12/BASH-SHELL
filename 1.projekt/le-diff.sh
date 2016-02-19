#!/bin/sh
# Skript le-diff.sh

#cat .parametre
#exp=`pwd` # aktualna cesta do exp
#file=`wc .parametre -c|sed 's/ .*//'`



projdir=`cat .le/.config|grep ^projdir |sed 's/projdir //'`

if [ -z "$@" ]; then
	for i in `ls -p | egrep -v /$`; do
		test -e $i >/dev/null
		test1=$?
		test -e $projdir/$i >/dev/null
		test2=$?

		#echo "$test1--$test2"
		if [ $test1 -ne 0 -a $test2 -ne 0 ]; then
			echo "OKK"
		elif [ $test1 -ne 0 ]; then
			echo "D: $i"
		elif [ $test2 -ne 0 ]; then
			echo "C: $projdir/$i"
		else
			res=`diff -e $projdir/$i $i`
			if [ -z "$res" ]; then
				echo ".: $i"
			else
				echo "$res"
			fi
		fi
	done
else
	for i in $@ ; do
		test -e $i >/dev/null
		test1=$?
		test -e $projdir/$i >/dev/null
		test2=$?

		#echo "$test1--$test2"
		if [ $test1 -ne 0 -a $test2 -ne 0 ]; then
			echo "OKK"
		elif [ $test1 -ne 0 ]; then
			echo "D: $i"
		elif [ $test2 -ne 0 ]; then
			echo "C: $projdir/$i"
		else
			res=`diff -e $projdir/$i $i`
			if [ -z "$res" ]; then
				echo ".: $i"
			else
				echo "$res"
			fi
		fi
	done
fi

