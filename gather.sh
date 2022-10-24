#!/bin/bash

if [[ $1 == 'p' ]] || [[ $1 == 'pos' ]]; then
    pattern='POSCAR'
    read -p "filename starts with? " filename
elif [[ $1 == 'c' ]] || [[ $1 == 'con' ]]; then
    pattern='CONTCAR'
    read -p "filename starts with? " filename
else
    pattern=$1
fi

for i in {0..9}
do
    if [[ -d $i ]]; then
        cd $i
        for file in *
        do
            if [[ $file =~ $pattern ]]; then
                if [[ $pattern == 'POSCAR' ]] || [[ $pattern == 'CONTCAR' ]]; then
                    cp $file ../$filename$i.vasp
                else
                    extension="${file##*.}"
                    filename="${file%.*}"
                    cp $file ../$filename$i.$extension
                fi
            fi
        done
        cd ..
    fi
done