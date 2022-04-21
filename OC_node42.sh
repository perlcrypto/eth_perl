#!/bin/sh
#dnf config-manager --enable powertools
nvidia-xconfig --cool-bits=31 --allow-empty-initial-configuration
#systemctl set-default multi-user.target
# systemctl set-default graphical.target
# start up X
xinit &
export DISPLAY=:0.0

# configure the card
nvidia-smi -pm 1                                                      # enable persistent mode
nvidia-smi -i 0 -pl 170
nvidia-settings -a "[gpu:0]/GpuPowerMizerMode=2"                    # set performance level 2 (high performance)
nvidia-settings -a '[gpu:0]/GPUFanControlState=1'                     # set manually controlled fan speed
#Fan_anchor
nvidia-settings -a "[fan:0]/GPUTargetFanSpeed=85"
##GRA_anchor                     
nvidia-settings -a "[gpu:0]/GPUGraphicsClockOffset[4]=+100"
##MEM_anchor
nvidia-settings -a "[gpu:0]/GPUMemoryTransferRateOffset[4]=+1300"
## shut down x
ps -ef | grep /usr/libexec/Xorg | grep -v grep | awk '{print $2}' | xargs kill