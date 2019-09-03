#!/bin/bash


#-------ペンとモニタのリストを＄HOMEに作成する。----------------
xinput_calibrator --list | sed -e '/Pad/d' -e  '/pad/d' -e '/Mouse/d' -e '/mouse/d' -e '/Keyobard/d' -e '/keyboard/d' >  $HOME/penlist.txt
xrandr --listmonitors | awk -F'[ ]'  'NR>1' >  $HOME/monlist.txt


#--------使用するペン入力を変数にする。---------------
penfile=$HOME/penlist.txt
penlines=()
while IFS= read -r penlines; do

penlines=("${penlines[@]}" "$penlines")

done <"$penfile"

#--------使用するモニタ入力を変数にする。-----------------

monfile=$HOME/monlist.txt
monlines=()
while IFS= read -r monlines; do

monlines=("${monlines[@]}" "$monlines")

done <"$monfile"

 
#-------使用するPENMAPINIを変数にする。--------------
#-------PENMAPINIがなかった時空ファイルを作成する。
touch $HOME/penmapini.txt
penmapfile=$HOME/penmapini.txt
#-------Cancel用のバックアップを作成する------------

#cp  $HOME/penmapini.txt   $HOME/penmapback.txt


penmaplines=()
while IFS= read -r penmaplines; do

penmaplines=("${penmaplines[@]}"  "$penmaplines")
done <"$penmapfile"

#-------一時ファイルを削除する。----------
rm  $HOME/penlist.txt
rm  $HOME/monlist.txt

#-------Penmapを実行する。
penmapout=$(yad  --title="Penmap実行" \
--geometry=400x400+512+384 \
--form \
--field="PENList:CB" \
"${penlines[1]} !${penlines[2]} !${penlines[3]} !${penlines[4]} " \
--field="MonitorList:CB" \
"${monlines[1]} !${monlines[2]} !${monlines[3]} !${monlines[4]} " \
--field="この組み合わせで実行":FBTN 'bash -c " echo 10 ; kill -USR1 $YAD_PID"' \
--field="この組み合わせを登録":FBTN 'bash -c " echo 12 ; kill -USR1 $YAD_PID"' \
--field="PenMapキーの再編成":FBTN 'bash -c " echo 14  ; kill -USR1 $YAD_PID"' \
--field="登録PENMAP1":LBL 'bash -c ""' \
--field="${penmaplines[1]}----PENMAP実行":FBTN 'bash -c " echo 21 ; kill -USR1 $YAD_PID"' \
--field="登録PENMAP2":LBL 'bash -c ""' \
--field="${penmaplines[2]}----PENMAP実行":FBTN 'bash -c " echo 22 ; kill -USR1 $YAD_PID"' \
--field="登録PENMAP3":LBL 'bash -c ""' \
--field="${penmaplines[3]}----PENMAP実行":FBTN 'bash -c " echo 23 ; kill -USR1 $YAD_PID"' \
--field="登録PENMAP4":LBL 'bash -c ""' \
--field="${penmaplines[4]}----PENMAP実行":FBTN 'bash -c " echo 24 ; kill -USR1 $YAD_PID"' \
--field="登録PENMAP5":LBL 'bash -c ""' \
--field="${penmaplines[5]}----PENMAP実行":FBTN 'bash -c " echo 25 ; kill -USR1 $YAD_PID"' \
--field="登録PENMAP6":LBL 'bash -c " "' \
--field="${penmaplines[6]}----PENMAP実行":FBTN 'bash -c " echo 26 ; kill -USR1 $YAD_PID"' \
--button="gtk-ok":100 )



#------BottunのIDを使用する時に、使用する。奇数の時は、IDのみが出力される。偶数の時は、yadの出力も出る。
#--------penmapout から余計な文字列を削除して、penmapinfoとする。
#--------penmapinforからAwkで必要なデータを取り出す。

penmapinfo=$(echo $penmapout  |  awk '{$NF="";print $0}') 

#--------penmopinforからAwkでpenmapとmomapに必要なデータを取り出す。
penmoninfo=$(echo $penmapinfo  | awk '{print substr($0,4,length($0))}' )

#--------penmoninforからAwkでmoninfoに必要なデータを取り出す。
moninfo=$(echo $penmoninfo  | awk '{print substr($0,index($0,"|")+2,length($0))}' )

#--------penmoninforからAwkでpeninfoに必要なデータを取り出す。
peninfo=$(echo $penmoninfo |awk -F '|' '{print $1}' )

#--------penswは、作業項目毎のFlagにする。
pensw=$(echo $penmapinfo | awk  '{print $1}')

#--------penidは、pendiviceのID
penid=$(echo $penmapinfo | sed 's/id=/\n/1;s/^.*\n//' | awk '{print $1}' )

#--------monidは、monitorのID
monid=$(echo $penmapinfo | awk '{print $NF}' )

#-------------以下ケースごとに作業を実施する。----------------


case  $pensw in
 
     10)
         xinput map-to-output $penid $monid
         bash penmap.sh
         ;;

     12) 
          
		penmapnew=$(echo "PenID=" $peninfo "//" "MonitorID="$moninfo) 
		penmapadd=$(yad --title="ペンマップ登録変更" \
				--form \
				--field="PENMAP登録１":CB \
					"${penmaplines[1]} ! "" ! ${penmapnew} " \
				--field="PENMAP登録2":CB \
					"${penmaplines[2]} ! "" ! ${penmapnew} " \
				--field="PENMAP登録3":CB \
					"${penmaplines[3]} ! "" ! ${penmapnew} " \
				--field="PENMAP登録4":CB \
					"${penmaplines[4]} ! "" ! ${penmapnew} " \
				--field="PENMAP登録5":CB \
					"${penmaplines[5]} ! "" ! ${penmapnew} " \
				--field="PENMAP登録6":CB \
					"${penmaplines[6]} ! "" ! ${penmapnew} " \
				--buttons-layout=edge \
				--button="登録して戻る。":32 \
				--button="gtk-cancel":33 \
				--button="gtk-quit":35 )
     
#--------出力をpenmapiniのフォーマットにする。--------

					addsw=$?
						
					case  $addsw in
					32)
					echo ${penmapadd} | tr '|' '\n' |sed -n '$!p' | sed -e 's/^[ ]*//g'  > $HOME/penmapini.txt
					bash penmap.sh
					
					;;
					33)
					bash penmap.sh
					
					;;
					35)
					exit
					;;
					esac         
		;;
                 
     14)
     
		bash penmapmod.sh
		;;


     21)
     
        penid=$(echo  ${penmaplines[1]} | sed 's/id=/\n/1;s/^.*\n//' | awk '{print $1}')
        monid=$(echo  ${penmaplines[1]} | awk '{print $NF}') 
                 
        xinput map-to-output $penid $monid
		bash penmap.sh
		exit  0

         ;;

     22)
     
        penid=$(echo  ${penmaplines[2]} | sed 's/id=/\n/1;s/^.*\n//' | awk '{print $1}' )
		monid=$(echo  ${penmaplines[2]} | awk '{print $NF}') 
 
         
        xinput map-to-output $penid $monid
		bash penmap.sh
		exit  0
         ;;

     23)
     
        penid=$(echo  ${penmaplines[3]} | sed 's/id=/\n/1;s/^.*\n//' | awk '{print $1}' )
		monid=$(echo  ${penmaplines[3]} | awk '{print $NF}') 
 
         
        xinput map-to-output $penid $monid
		bash penmap.sh
		exit  0
         ;;

     24)
     
        penid=$(echo  ${penmaplines[4]} | sed 's/id=/\n/1;s/^.*\n//' | awk '{print $1}' )
		monid=$(echo  ${penmaplines[4]} | awk '{print $NF}') 
 
         
        xinput map-to-output $penid $monid
		bash penmap.sh
		exit  0
         ;;

     25)
     
        penid=$(echo  ${penmaplines[5]} | sed 's/id=/\n/1;s/^.*\n//' | awk '{print $1}' )
		monid=$(echo  ${penmaplines[5]} | awk '{print $NF}') 
 
         
        xinput map-to-output $penid $monid
		bash penmap.sh
		exit  0
         ;;

     26)
          
        penid=$(echo  ${penmaplines[6]} | sed 's/id=/\n/1;s/^.*\n//' | awk '{print $1}' )
		monid=$(echo  ${penmaplines[6]} | awk '{print $NF}') 
                 
        xinput map-to-output $penid $monid
		bash penmap.sh
		exit  0

         ;;

	 * )
	    exit 0
		;;
		
esac         

#---------バックアップファイルを削除する。

exit  0
 
