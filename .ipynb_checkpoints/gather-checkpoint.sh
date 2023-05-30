#!/bin/bash

if [[ $1 == '-n' ]] || [[ $1 == 'neb' ]]; then
    # usage: sh gather.sh -n IMAGES
    read -p "files starts with: " f
    for i in $(seq 1 $2)
    do
        cp 0$i/POSCAR $f-p$i.vasp
        cp 0$i/CONTCAR $f-c$i.vasp
    done
    cp 00/POSCAR $f-p0.vasp
    cp 0$(($2+1))/POSCAR $f-p$(($2+1)).vasp
    cp 00/POSCAR $f-c0.vasp
    cp 0$(($2+1))/POSCAR $f-c$(($2+1)).vasp
    exit 1
elif [[ $1 == '-c' ]] || [[ $1 == '-s' ]]; then
    if [[ -z $2 ]]; then
        read -p 'which files? ' f
    else
        f=$2
    fi
elif [[ -z $1 ]]; then
    read -p 'which files? ' f
else
    f=$1
fi

if [[ $1 == '-s' ]]; then
    dirs='*/*/'
    destination='../../'
else
    dirs='*/'
    destination='../'
fi
    
if [[ $f == 'p' ]] || [[ $f == 'pos' ]]; then
    pattern='POSCAR'
    read -p "filename starts with? " filename
elif [[ $f == 'c' ]] || [[ $f == 'con' ]]; then
    pattern='CONTCAR'
    read -p "filename starts with? " filename
else
    pattern=$f
fi

list=''
read -p 'vaspsend destination (enter for skip): ' send

for dir in $dirs
do
    cd $dir
    if [[ $1 == '-c' ]] || [[ $1 == '-s' ]]; then
        numb=$(echo $dir | cut -c 1)
    else
        numb=${dir%/}
    fi
    for file in *
    do
        if [[ $file =~ $pattern ]]; then
            if [[ $pattern == 'POSCAR' ]] || [[ $pattern == 'CONTCAR' ]]; then
                if [[ $pattern == 'POSCAR' ]] && [[ -e initial.vasp ]]; then
                    cp initial.vasp $destination$filename$numb.vasp
                    echo "$dir'initial.vasp' $filename$numb.vasp"
                elif [[ $pattern == 'CONTCAR' ]] && [[ ! -s $file ]]; then
                    cp POSCAR $destination$filename$numb.vasp
                    echo "$dir'POSCAR' $filename$numb.vasp"
                else
                    cp $pattern $destination$filename$numb.vasp
                    echo "$dir$pattern $filename$numb.vasp"
                fi
                list+="$filename$numb.vasp "
            elif [[ $pattern == 'CHGCAR' ]]; then
                cp $file $destination'chgcar'$numb.vasp
                echo "$dir$file 'chgcar'$numb.vasp"
                list+="chgcar$numb.vasp "
            elif [[ "${file##*.}" == "${pattern##*.}" ]]; then
                filename="${file%.*}"
                extension="${file##*.}"
                if [[ $filename == $extension ]]; then
                    cp $file $destination$filename$numb
                    echo "$dir$file $filename$numb"
                    list+="$filename$numb "
                else
                    cp $file $destination$filename$numb.$extension
                    echo "$dir$file $filename$numb.$extension"
                    list+="$filename$numb.$extension "
                fi
            fi
        fi
    done
    cd $destination
done

if [[ $send == 'port' ]]; then
    cp $list ~/port/
# elif [[ $send =~ 'window' ]]; then
#     echo "scp $list jhyeo@192.168.1.251:~/Desktop/$send"
#     scp $list jhyeo@192.168.1.251:~/Desktop/$send
elif [[ $send =~ 'x2658' ]]; then
    echo "scp $list x2658a09@nurion-dm.ksc.re.kr:~/vis"
    scp $list x2431a10@nurion.ksc.re.kr:~/vis
elif [[ $send =~ 'x2347' ]]; then
    echo "scp $list x2347a10@nurion-dm.ksc.re.kr:~/vis"
    scp $list x2347a10@nurion.ksc.re.kr:~/vis
elif [[ $send =~ 'x2431' ]]; then
    echo "scp $list x2431a10@nurion-dm.ksc.re.kr:~/vis"
    scp $list x2431a10@nurion.ksc.re.kr:~/vis
elif [[ $send =~ 'x2421' ]]; then
    echo "scp $list x2421a04@nurion-dm.ksc.re.kr:~/vis"
    scp $list x2431a10@nurion.ksc.re.kr:~/vis
elif [[ $send =~ 'cori' ]]; then
    echo "scp $list jiuy97@cori.nersc.gov:~/vis"
    scp $list jiuy97@cori.nersc.gov:~/vis
elif [[ $send =~ 'mac' ]]; then
    echo "scp $list hailey@172.30.1.14:~/Desktop/$send"
    scp $list hailey@172.30.1.14:~/Desktop/$send
elif [[ $send =~ 'mini' ]]; then
    echo "scp $list hailey@192.168.0.241:~/Desktop/$send"
    scp $list hailey@192.168.0.241:~/Desktop/$send
fi