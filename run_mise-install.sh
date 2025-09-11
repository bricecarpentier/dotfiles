#!/bin/sh

which mise > /dev/null 2> /dev/null
if [ "$?" = "1" ];
then
	curl https://mise.run | sh
fi

mise install

