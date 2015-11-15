#!/bin/bash

while read line
do
	if [ "${line//END}" != "$line" ]; then
		txt="$txt$line\n"
		printf -- "$txt" | openssl x509 -text
		txt=""
	else
		txt="$txt$line\n"
	fi
done
