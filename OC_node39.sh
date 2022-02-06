#!/bin/sh
# start up X
xinit &
export DISPLAY=:0.0

# configure the card
nvidia-smi -pm 1                                                      # enable persistent mode
nvidia-smi -i 0 -pl 80                                                # set power rate limit at 80 watts
nvidia-settings -a "[gpu:0]/GpuPowerMizerMode=2"                    # set performance level 2 (high performance)
nvidia-settings -a '[gpu:0]/GPUFanControlState=1'                     # set manually controlled fan speed
nvidia-settings -a '[fan:0]/GPUTargetFanSpeed=75'                     # set fan speed to 75%
nvidia-settings -a '[gpu:0]/GPUGraphicsClockOffset[2]=-200'           # set the GPU clock offset to -200 MHz (underclock)
nvidia-settings -a '[gpu:0]/GPUMemoryTransferRateOffset[2]=+200'     # set the RAM clock offset to +2200 MHz (overclock)
# shut down x
ps -ef | grep /usr/libexec/Xorg | grep -v grep | awk '{print $2}' | xargs kill\n";