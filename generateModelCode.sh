#!/bin/bash
parserJarLoc=./modelEZ/modelEZtoC.jar
javaCmd=java
CC=gcc
command -v $CC >/dev/null 2>&1 || { echo >&2 "Could not find c compiler. Aborting."; exit 1; }
command -v $javaCmd >/dev/null 2>&1 || { echo >&2 "Could not find java command. Aborting."; exit 1; }
if [ $# -eq 0  ]
then
echo "Usage: `basename $0` modName  <paramFileName>"
exit
fi
if [ $# -gt 2  ]
then
echo "Usage: `basename $0` modName  <paramFileName>"
exit
fi
if [ -e $1 ]
then
echo "found model file"
else
echo  "did not find model file"
echo $1
exit 1
fi
if [ -e $parserJarLoc ]
then
echo "found jar file"
else
echo  "did not find jar file"
echo $parserJarLoc
exit 1
fi

$javaCmd -cp $parserJarLoc gov.frb.ma.msu.toC.AMAtoC $1
rm -f $1_AMA_data.c
if [ -e $1_AMA_matrices.c ]
then
echo "Created .c file for generating sparseAMA hmat. Now trying to compile it."
rm -f $1_AMA_matrices.o
$CC -c $1_AMA_matrices.c
if [ -e $1_AMA_matrices.o ]
then
	echo "Compilation successful."
if [ -z $2 ]
then
	echo "running make MODNAME="$1
	make MODNAME=$1
else
if [ -e $2.f90 ]
then
echo "found param file"
else
echo  "did not find param file"
echo  $2.f90
exit 1
fi
	make MODNAME=$1 PARAMFILENAME=$2
fi
else
	echo "Could not create a compilable h-matrix generator."
	if [ -e $1_AMA_matrices.c ]
		then
		echo "Model file name probably contains illegal characters. No periods please."
	fi
fi
else
echo "parser failed to generate a .c file"
fi
