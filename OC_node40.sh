#!/bin/sh
dnf config-manager --enable powertools
nvidia-xconfig --cool-bits=31 --allow-empty-initial-configuration
systemctl set-default multi-user.target
# systemctl set-default graphical.target
# start up X
xinit &
export DISPLAY=:0.0

# configure the card
nvidia-smi -pm 1                                                      # enable persistent mode
nvidia-smi -i 0 -pl 125
nvidia-settings -a "[gpu:0]/GpuPowerMizerMode=2"                    # set performance level 2 (high performance)
nvidia-settings -a '[gpu:0]/GPUFanControlState=1'                     # set manually controlled fan speed
#Fan_anchor
nvidia-settings -a "[fan:0]/GPUTargetFanSpeed=85"
##GRA_anchor                     
#nvidia-settings -a '[gpu:0]/GPUGraphicsClockOffset[4]=-200'           # set the GPU clock offset to -200 MHz (underclock)
##MEM_anchor
#nvidia-settings -a '[gpu:0]/GPUMemoryTransferRateOffset[4]=+200'     # set the RAM clock offset to +2200 MHz (overclock)
## shut down x
ps -ef | grep /usr/libexec/Xorg | grep -v grep | awk '{print $2}' | xargs kill