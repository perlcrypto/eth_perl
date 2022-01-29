#http://blog.zencoffee.org/2021/05/nvidia-overclocking-headless/
# nvidia-smi -q -d CLOCK
#nvidia-smi -q -d temperature
#my %overclock = (
#    2060 => " --pl 72 --mclock +700 --cclock -50 ",#2060 --fan 99  --templimit 80
#    2080 => " --pl 60 --mclock +1100 --cclock -200 ",#2080 Ti --fan 80  --templimit 65
#);


nvidia-xconfig -a --force-generate --allow-empty-initial-configuration --cool-bits=28 --no-sli --connected-monitor="DFP-0"
nvidia-smi -pm 1
nvidia-smi -pl 125
nvidia-settings -c :0 -a [gpu:0]/GPUMemoryTransferRateOffset[2]=600
nvidia-settings -c :0 -a [gpu:0]/GPUGraphicsClockOffset[2]=-100
nvidia-settings -c :0 -a [gpu:0]/GPUFanControlState=1
--
xinit nvidia-settings -a [gpu:0]/GPUFanControlState=1 -a [fan:0]/GPUTargetFanSpeed=80 --  :0 -once