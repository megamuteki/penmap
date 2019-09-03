#!/bin/bash

#penmap.sh
file1=/opt/pentablet/penmap/penmap.sh; [  -e $file1 ] && sudo  rm  $file1
file2=/opt/pentablet/penmap/penmapmod.sh; [  -e $file2 ] && sudo  rm  $file2
file3=/usr/share/applications/penmap.desktop; [  -e $file3 ] && sudo  rm  $file3

#penmap dir
dir1=/opt/pentablet/penmap
if [ -z "$(ls $dir1)" ]; then
    sudo rm -r $dir1
fi

#pentablet dir
dir2=/opt/pentablet/
if [ -z "$(ls $dir2)" ]; then
    sudo rm -r $dir2
fi


exit