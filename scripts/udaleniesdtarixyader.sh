#!/bin/bash
KERNELS=$(dpkg --list | grep linux-image | awk '{print $2}')
LATEST_KERNEL=$(echo $KERNELS | tr ' ' '\n' | sort -V | tail -n 1)
for KERNEL in $KERNELS; do    if [[ $KERNEL != $LATEST_KERNEL ]]; then
        sudo apt-get remove $KERNEL -y    fi
done
echo "Удаленные ядра:" > report.txtecho "================" >> report.txt
echo "" >> report.txt
for KERNEL in $KERNELS; do    if [[ $KERNEL != $LATEST_KERNEL ]]; then
        echo $KERNEL >> report.txt    fi
done
echo "" >> report.txtecho "Оставленное ядро: $LATEST_KERNEL" >> report.txt
