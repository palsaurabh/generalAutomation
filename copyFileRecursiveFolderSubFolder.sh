#!/bin/bash

if [ $# -ne 2 ]
then
	echo "Usage: copyFileRecursiveFolderSubFolder.sh <fileName> <folderName>"
	exit 1
fi
FILE_NAME=$1
ROOT_FOLDER_NAME=$2

echo "File Name:$1 Folder Name:$2"

for d in $ROOT_FOLDER_NAME/*
do
	echo $d
	if [ -d "$d" ] 		#if it is a directory
	then
		cp $FILE_NAME "$d"
	fi
done
