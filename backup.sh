#/bin/bash

#Script to check to see if there are .sav files. Then backs them up. 

cd /roms2
if [ ! -d backupsavs ] then;
    mkdir backupsavs
fi

echo "Finding .sav files and copying them to backupsavs..."
find /roms2 -name '*.sav' -exec cp /roms2/backupsavs {} \;
echo "Finding .state files and copying them to backupsavs..."
find /roms2 -name '*.state*' -exec cp /roms2/backupsavs/states {} \;
echo "All done"