#!/bin/bash

numb=$1
if [[ -n ${numb//[0-9]/} ]]; then
    file=${@:1}
    SET='*/'
else
    file=${@:2}
    for i in $(seq 2 $1); do
        SET+='*/'
    done
fi

for dir in $SET; do
    cp $file $dir
    # if [[ ! -e $file ]]; then
    #     name=${file%.*}
    #     ext=${file##*.}
    #     numb=$(echo $dir | cut -c 1)
    #     # echo $name $ext $numb
    #     cp $name$numb.$ext $dir$name.$ext
    # else
    #     cp $file $dir
    # fi
    # if [[ $file == 'run_slurm.sh' ]]
    #     cp .run_conti.sh $dir
    # fi
done