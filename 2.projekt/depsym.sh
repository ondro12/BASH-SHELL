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

#nastavenie flagov(parametrov skriptu zadanych na prikazovom riadku) pre kontrolu ci boli zadane korektne

rflag=false
dflag=false
counter=1

#HELP resp navod ako maju vyzerat vstupne parametre

hlp() { echo "Usage: $0 [-g] [-r|-d OBJECT_ID] FILEs" 1>&2; exit 1; }

# spracovanie argumentov skriptu

while getopts "gr:d:" params
 do 
		case "$params" in
			g)shift

					# Ak je zadany parameter g, nasledne kontrolujem ci je zadany parameter d alebo r

					for i in $@; do
						if [ $i = "-d" ]; then
							dflag=true
						fi
						if [ $i = "-r" ]; then
							rflag=true
						fi

					# Ak bol zadany parameter -r a -d sucastne koncim chybov . nekorektne voci zadaniu

						if [ $rflag = true ] && [ $dflag = true ]; then
							echo "Error: -r and -d used together"
							hlp
						fi
					done

					#Postupujem podla zadania pridavam vypis potrebny pre spracovanie grafu

					echo "digraph GSYM {"
					$0 $@ | sed 's_(_\[label=\"_' | sed 's_+_P_' \
					| sed 's_)_\"\];_' | sed 's_\._D_g' | sed 's_\^->_\__' >"$FILE"
					cat $FILE
					sed -i -r 's/\S+//2' $FILE && sed -i -r 's/\S+//3' $FILE
 					sort -u -o $FILE $FILE

					# Spracovanie vstupu

					while read argumnts; do
						for files in $argumnts; do
							echo "$files [label=\"$files\"];" | sed 's/D/\./g' \
							| sed 's/\./D/' 
						done
					done <$FILE | sort -u  
					echo '}'
					trap "rm -f $FILE" EXIT
					exit 0 ;;

			r)	if [ "$dflag" = true ] || [ $OPTARG = "-d" ]; then
						echo "Error: -r and -d used together"
						hlp
					else 
						shift

						# spracovanie a ulozenie OBJECT_ID		

						nm $OPTARG | awk -F' ' '{ print $(NF-1)" "($NF) }' > $FILE
						while IFS=' ' read use lst
							do
								if [ "$use" == "B" ] || [ "$use" == "T" ] \
								|| [ "$use" == "C" ] || [ "$use" == "D" ] \
								|| [ "$use" == "G" ]; then
									for i in $@; do
										if [ $i = $OPTARG ]; then
											i+=1
										else
											nm $i | awk -F' ' '{ print $(NF-1)" "($NF) }' \
											| grep '^U' | grep -q " $lst" && \
											echo "$i -> $OPTARG ($lst)"
										fi
									done
								fi 
							done < $FILE 
						trap "rm -f $FILE" EXIT
						rflag=true
					fi 
				exit 0;;
			d)	if [ "$rflag" = true ] || [ $OPTARG = "-r" ]; then 
						echo "Error: -r and -d used together"
						hlp
					else
						shift

						# spracovanie a ulozenie OBJECT_ID

						nm $OPTARG | awk -F' ' '{ print $(NF-1)" "($NF) }' > $FILE

						# spracovanie ulozenie a vypis zo zadanych Files

						while IFS=' ' read use lst
							do
							if [ "$use" == "U" ]; then
								for i in $@; do
									if [ $i = $OPTARG ]; then
										i+=1
									else
										nm $i | awk -F' ' '{ print $(NF-1)" "($NF) }' \
										| grep '^T' | grep -q "$lst" && \
										echo "$OPTARG -> $i ($lst)"
									fi
								done
							fi 
						done < $FILE 
						trap "rm -f $FILE" EXIT
						dflag=true
					fi 
					exit 0;;

			# Dalsie mozne chybove stavy

			:)	if [ "$rflag" = true ] && [ "$dflag" = true ]; then 
						echo "Error: -r and -d used together"
						hlp
					fi;
					echo "-$OPTARG is necessary type parameter"
					hlp;;
			\?)	echo "Wrong argument: -$OPTARG"
					hlp;;
		esac
done

#Kontrola ci boli zadane subory spravneho formatu (podla zadania s priponou .o)

for i in $@; do
	if [[ $i != *.o ]]; then
		echo "Wrong format of FILEs"
		hlp
	fi
done

#Spracovanie a vypis zadanych files

for i in $@; do
	nm $i | awk -F' ' '{ print $(NF-1)" "($NF) }' > $FILE
	while IFS=' ' read use lst
		do
			if [ "$use" = "U" ]; then
				for j in $@; do
					if [ $j == $i ]; then
						j+=1
					else
						nm $j | awk -F' ' '{ print $(NF-1)" "($NF) }' \
						| grep '^[TBCDG]' | grep -q $lst \
						&& echo "$i -> $j ($lst)"
					fi
				done
			fi 
		done < $FILE 
	i+=1	 
done
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

