#!/bin/bash

########################################################################
########################################################################
########################################################################
########################################################################
########################################################################
########################################################################
###Autor: Matus Ondris  ################################################
###Datum: 28.3.2014     ################################################
###Login:xondri04       ################################################
########################################################################
########################################################################
########################################################################
########################################################################
########################################################################
########################################################################

#Nastavenie docastneho suboru pre vypis

FILE=$(mktemp /tmp/$USER.XXXXX)

# Pomocne premenne indikatory , ci boli zadane prepinace g d r alebo p
gflag=false
dflag=false
rflag=false
pflag=false

#Pomodne premenne a FUNKCION_ID
some=${!#}
fncid=""

#HElp resp pouzitie

hlp() { echo "Usage: $0 [-g] [-r|-d OBJECT_ID] FILE" 1>&2; exit 1; }

# spracovanie argumentov skriptu

while getopts ':gpr:d:' params; do
		case "$params" in
		#testovanie zadania flagov (parametrov skriptu)
			g) gflag=true;; 
			p) pflag=true;;
			d) dflag=true
				if [ "$rflag" = true ] || [ "$OPTARG" = '-r' ]; then
					echo "Error: -r and -d used together"
					hlp
				fi
				fncid="$OPTARG";; #ulozenie argumentu FUNKCION_ID zadaneho za parametrom d
 			r) rflag=true
				if [ "$dflag" = true ] || [ "$OPTARG" = '-d' ]; then
					echo "Error: -r and -d used together"
					hlp
				fi
				fncid="$OPTARG";; #ulozenie argumentu FUNKCION_ID zadaneho za parametrom r
			\?) echo "Error: Wrong parameter: -$OPTARG"
				hlp;;
			:) echo "Error: -$OPTARG parameter needed"
				hlp;;
		esac
done

# Zistenie volania funkcii pomocou objdump + selekcia zadanej funkcie

	objdump -d -j .text $some | grep '>:\|call\|callq' | grep '[<>]' \
	| awk '{ print $NF }' | if [ "$pflag" = false ]; then grep -v '@';else \
	sed 's/[^a-zA-z_:@]//g';  fi | sed 's/[^a-zA-z_:@]//g' \

# Spracovanie suboru

	| while read args
		do
			if [[ "$args" =~ [:] ]]; then
				make=$args
			else
				echo "$make -> $args;" | sed 's/://g' | sed 's/__/_/g' 
			fi
		done >$FILE
	if [ "$gflag" = true ]; then
		echo "digraph CG {"
	fi

# AK bol zadany parameter d skrypt postupuje podla zadania

	if [ "$dflag" = true ]; then
		if [ "$gflag" = false ]; then 
			cat $FILE | sort -u | sed 's/;//g' | awk -v vn="$fncid" '$1 == vn'
		else
			cat $FILE | sort -u | awk -v vn="$fncid" '$1 == vn' | sed 's/@\([a-z]*\)/_\U\1/g'
		fi
	else

# AK bol zadany parameter r skrypt postupuje podla zadania

		if [ "$rflag" = true ]; then
			if [ "$gflag" = false ]; then 
				cat $FILE | sort -u | sed 's/;//g' | awk -v vn="$fncid" '$NF == vn'
			else
				cat $FILE | sort -u | awk -v vn="$fncid" '$NF == vn' | sed 's/@\([a-z]*\)/_\U\1/g'
			fi
		else
			if [ "$gflag" = false ]; then 
				cat $FILE | sed 's/;//g' | sort -u 
			else
				cat $FILE | sort -u | sed 's/@\([a-z]*\)/_\U\1/g'
			fi
		fi
	fi 
	if [ "$gflag" = true ]; then
		echo "}"
	fi
trap "rm -f $FILE" EXIT

###############KONIEC SKRYPTU###########################################
########################################################################
########################################################################
########################################################################
########################################################################
########################################################################
########################################################################
########################################################################
########################################################################
########################################################################
########################################################################
########################################################################
########################################################################
########################################################################
########################################################################
########################################################################
########################################################################
########################################################################
########################################################################
########################################################################
########################################################################
########################################################################
########################################################################
########################################################################
