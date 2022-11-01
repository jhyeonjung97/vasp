#!/bin/bash

read -p 'Geometry optimization? [y/n] (default: y) ' geo

# default answer/ check input files
if [[ -z $geo ]] || [[ $geo =~ 'y' ]]; then
    if [ ! -e INCAR ] || [ ! -e KPOINTS ] || [ ! -e POTCAR ] || [ ! -e POSCAR ] || [ ! -e run_slurm.sh ]; then
        echo 'you are missing something..'
        exit 8
    fi
    geo='y'
fi

read -p 'CHG? [y/n] (default: y) ' chg
read -p 'DOS? [y/n] (default: y) ' dos

# default answer/ check input files
if [[ -z $chg ]] || [[ $chg =~ 'y' ]]; then
    chg='y'
fi

if [[ -z $dos ]] || [[ $dos =~ 'y' ]]; then
    if [[ $chg != 'y' ]] && [[ ! -s CHGCAR ]]; then
        echo 'you need CHGCAR..'
        exit 6
    fi
    dos='y'
fi

if ( [[ $geo == 'y' ]] && [[ $chg == 'y' ]] && [[ $dos == 'y' ]] ) || ( [[ $geo == 'y' ]] && [[ $chg == 'y' ]] && [[ $dos != 'y' ]] ) || ( [[ $geo != 'y' ]] && [[ $chg == 'y' ]] && [[ $dos == 'y' ]] ) || ( [[ $geo != 'y' ]] && [[ $chg == 'y' ]] && [[ $dos != 'y' ]] ) || ( [[ $geo != 'y' ]] && [[ $chg != 'y' ]] && [[ $dos == 'y' ]] ); then
    mkdir geo
else
    echo 'calculation sequence is wrong..'
    exit 1
fi

# functions
function modify {
    grep $2 $1

    if [[ -z $(grep $2 $1) ]]; then
        echo "#$2"
        echo $2 >> $1
    fi
    
    if [[ -z $3 ]]; then
        sed -i "s/#$2/$2/" $1
        sed -i "s/$2/#$2/" $1
    else
        sed -i "/$2/c\\$2 = $3" $1
    fi
        
    grep $2 $1
}

if [[ $chg == 'y' ]]; then
    mkdir chg
    cp INCAR INCAR_chg
    echo '<INCAR_chg>'
    modify INCAR_chg NSW
    modify INCAR_chg IBRION
    modify INCAR_chg LCHARG
    modify INCAR_chg LAECHG .TRUE.
    modify INCAR_chg LORBIT
fi

if [[ $dos == 'y' ]]; then
    mkdir dos
    cp INCAR INCAR_dos
    echo '<INCAR_dos>'
    modify INCAR_dos ICHARG 11
    modify INCAR_dos NSW
    modify INCAR_dos IBRION
    modify INCAR_dos ISMEAR -5
    modify INCAR_dos ALGO
    modify INCAR_dos LCHARG .FALSE.
    modify INCAR_dos LAECHG
    modify INCAR_dos LORBIT 11
    modify INCAR_dos NEDOS 1000
    modify INCAR_dos EMIN -50
    modify INCAR_dos EMAX 50
fi

#geo, chg, dos
if [[ $chg != 'y' ]]; then
    if [[ ! -e $chg ]]; then
        echo 'please prepare chg directory..'
        exit 2
    fi
elif [[ $geo != 'y' ]]; then
    cp * geo
    echo 'hello'
    sed -i '11,$d' run_slurm.sh
fi

#prepare input files
sed -n '11,$p' run_slurm.sh > temp1

if [[ $chg == 'y' ]]; then
    echo 'cp * geo
cp CONTCAR POSCAR
mv INCAR_chg INCAR' >> run_slurm.sh
    cat run_slurm.sh temp1 >> temp2
    mv temp2 run_slurm.sh
fi

if [[ $dos == 'y' ]]; then
    if ! [[ -e double_k ]]; then
        cp KPOINTS double_k
        echo '#please double k-points' >> double_k
    fi
    
    if [[ -n $(grep ISMEAR INCAR_dos | grep 5) ]]; then
        sed -i '3c\Gamma-only' double_k
    fi
    
    echo 'cp * dos
    cp CONTCAR POSCAR
mv double_k KPOINTS
mv INCAR_dos INCAR' >> run_slurm.sh
    cat run_slurm.sh temp1 >> temp2
    mv temp2 run_slurm.sh
fi

rm temp1 temp2

if [[ $dos == 'y' ]]; then
    more double_k
    read -p 'do you want to double this? [y/n] (default: n) ' double
    if [[ $double =~ 'y' ]]; then
        vi double_k
    fi
fi