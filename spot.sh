#!/bin/bash
if test -e POTCAR; then
   echo " "
   echo -e "\033[1;31m  -------------replaced-------------"
   echo " "
   echo -e "\033[1;31m  $k/ : POTCAR is replaced by new one \033[0m"
   rm POTCAR ;
   python /home/aracho/for_a_happy_life/ara/POTCAR.py ;
else   
   echo -e "\033[93m  -------------generated-------------"
   echo " "
   echo -e "\033[93m  $k/ : POTCAR is generated ... \033[0m"
   python /home/aracho/for_a_happy_life/ara/POTCAR.py ;
fi
