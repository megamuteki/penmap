#!/bin/bash


#-------使用するPENMAPを変数にする。
penmapfile=$HOME/penmapini.txt
penmaplines=()
while IFS= read -r penmaplines; do

penmaplines=("${penmaplines[@]}"  "$penmaplines")
done <"$penmapfile"

# ファンクション用にpenmaplinesをコピーする
penmapfunc=()
penmapfunc=("${penmaplines[@]}")

penmapmod=$(yad --title="ペンマップ登録変更" \
 --geometry=400x400+512+384 \
--form \
--field="登録１":CB \
"${penmaplines[1]} ! ${penmaplines[0]}! ${penmaplines[2]} ! ${penmaplines[3]} ! ${penmaplines[4]}  !  \
${penmaplines[5]} ! ${penmaplines[6]} " \
--field="登録2":CB \
"${penmaplines[2]} ! ${penmaplines[0]}! ${penmaplines[1]} ! ${penmaplines[3]} ! ${penmaplines[4]}  !  \
${penmaplines[5]} ! ${penmaplines[6]} " \
--field="登録3":CB \
"${penmaplines[3]} ! ${penmaplines[0]}! ${penmaplines[1]} ! ${penmaplines[2]} ! ${penmaplines[4]}  !  \
${penmaplines[5]} ! ${penmaplines[6]} " \
--field="登録4":CB \
"${penmaplines[4]} ! ${penmaplines[0]}! ${penmaplines[1]} ! ${penmaplines[2]} ! ${penmaplines[3]}  !  \
${penmaplines[5]} ! ${penmaplines[6]} " \
--field="登録5":CB \
"${penmaplines[5]} ! ${penmaplines[0]}! ${penmaplines[1]} ! ${penmaplines[2]} ! ${penmaplines[3]}  !  \
${penmaplines[6]} ! ${penmaplines[6]} " \
--field="登録6":CB \
"${penmaplines[6]} ! ${penmaplines[0]}! ${penmaplines[1]} ! ${penmaplines[2]} ! ${penmaplines[3]}  !  \
${penmaplines[4]} ! ${penmaplines[5]} ! ${penmaplines[0]} ! ${penmaplines[7]} " \
--buttons-layout=edge \
--button="登録して戻る。":12 \
--button="gtk-cancel":13 \
--button="gtk-quit":15 \
--button="gtk-ok":16 )

penfuncsw=$?


case  $penfuncsw in
 
     12)
         echo $penmapmod | tr '|' '\n' |sed -n '$!p' | sed -e 's/^[ ]*//g' > $HOME/penmapini.txt
         bash penmap.sh
         exit 0
         ;;

     13) 
         bash penmap.sh
         exit 0
         ;;

     15)
         exit 0
         ;;

     16)
         echo $penmapmod | tr '|' '\n' |sed -n '$!p' | sed -e 's/^[ ]*//g' > $HOME/penmapini.txt
         exit 0
         ;;


esac         


exit  0
