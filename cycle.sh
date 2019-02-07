#!/bin/bash

CMD='docker run -d --rm --net host --name nmarzi -v /home/buck/dockerdata/nmarzi/out:/root/.nmarzi/out nmarzi'
BIN='nmarzi'

while [ true ]
do
	$CMD > /dev/null 2>&1
	result=$?
        echo "$BIN exit code: $result"
        if [ $result -eq 0 ]
        then
                sleep 300
        else
                echo "another $BIN instance currently running, wait 60 s ..."
                sleep 60
        fi
done
