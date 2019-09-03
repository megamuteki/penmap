#!/bin/bash

#penmap.sh
dir1=/opt/pentablet/penmap/; [ ! -d $dir1 ] && sudo  mkdir -p $dir1
sudo cp -f ./penmap*.sh  $dir1
sudo chmod +x /opt/pentablet/penmap/penmap.sh
sudo chmod +x /opt/pentablet/penmap/penmapmod.sh

#penmap.desktop
if [ -e /usr/share/applications/penmap.desktop ]; then
  # fileが存在した場合
sudo cp -f ./penmap.desktop /usr/share/applications/
sudo chmod +x /usr/share/applications/penmap.desktop

else 
  # fileが存在しなかった場合
sudo cp  ./penmap.desktop /usr/share/applications/
sudo chmod +x /usr/share/applications/penmap.desktop

fi

exit