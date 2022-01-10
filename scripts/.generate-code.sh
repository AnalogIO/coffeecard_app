#!/bin/bash
# Generate Models and RestClient code

generateCode() {
	echo "Generate Model and RestClient code"
    flutter pub run build_runner build
}

if [ "$1" == "code" ]; then 
	generateCode 
	exit 0
else 
	echo -e "No arguments provided. Possible arguments:"
	echo "code"
	
	exit 1
fi