#!/usr/bin/env bash
if [ -f "/home/etude/tasks/toberestored" ]; then
    BACKUP_TO_RESTORE=$(cat /home/etude/tasks/toberestored)
    if [ -f "$BACKUP_TO_RESTORE" ]; then
        DB_FOLDER=/mnt/ramdisk1/database/
        if test  -f $BACKUP_TO_RESTORE  -a -s $BACKUP_TO_RESTORE -a -d $DB_FOLDER
        then
            echo "I'll restore file $BACKUP_TO_RESTORE into folder $DB_FOLDER"
            cd $DB_FOLDER
            rm -vf *
            7z x -y $BACKUP_TO_RESTORE 
            ls -altr ./
            rm -f /home/etude/tasks/toberestored
            echo "Restore sounds good"
        else
            echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!";
            echo "Bad RESTORE arguments 1: $BACKUP_TO_RESTORE AND 2: $DB_FOLDER";
            echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!";
        fi
    else
        echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!";
        echo "Non existant Restore File $BACKUP_TO_RESTORE !!!";
        echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!";
    fi
    DB_SCRIPT=/mnt/ramdisk1/database/prodDb.script
    if [ -f "$DB_SCRIPT" ]; then
        echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!";
        echo "A database already exists";
        echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!";
    else
        echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!";
        echo "No database exists, let's copy the default one!!";
        echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!";
        cp -v /root/arkilog/database/${ETUDE_DB_TYPE:-vanilla}/prodDb.* /mnt/ramdisk1/database/
    fi
fi

echo "**********************";
echo "Let's start...";
echo "**********************";
env
/usr/local/tomcat/bin/catalina.sh run