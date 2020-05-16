#!/bin/bash
# $1: phrase to find
# $2: phrase to replace $1

open_in_editor() {
  for file in $file_list
  do
    $1 $file
  done
}

if [ -z $1 ]
then
  echo "Usage: replace.sh PHRASE REPLACEMENT"
  echo "Omit REPLACEMENT to edit manually."
  exit 2
fi

file_list=$(grep -lwr --include="*.asm" --exclude-dir="concept" --exclude-dir="tools" --exclude-dir="docs"--exclude-dir=".git" --exclude-dir=".travis" $1)

if [ -z $2 ]
then
  grep -rnw --include="*.asm" --exclude-dir="concept" --exclude-dir="tools" --exclude-dir="docs"--exclude-dir=".git" --exclude-dir=".travis" $1
  read -p "Open these files in a text editor? " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]
  then
    read -p "Use default GUI text editor? " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
      open_in_editor "xdg-open"
    else
      read -p "What editior would you like to use? " -r editor_choice
      open_in_editor $editor_choice
    fi
  fi
else
  sed -i 's/\<'$1'\>/'$2'/' $file_list
fi
