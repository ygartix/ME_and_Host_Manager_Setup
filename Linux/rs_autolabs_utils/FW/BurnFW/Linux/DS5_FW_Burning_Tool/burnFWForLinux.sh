#!/bin/bash
echo param1=$1
timeout 30s python /home/administrator/rs_autolabs_utils/FW/BurnFW/Linux/DS5_FW_Burning_Tool/DS5_FW_Burning_Tool.py $1
