#http://blog.zencoffee.org/2021/05/nvidia-overclocking-headless/
=b
nvidia-smi -L:
GPU 0: Tesla K40m (UUID: GPU-d0e093a0-c3b3-f458-5a55-6eb69fxxxxxx)

nvidia-smi --query-gpu=index,name,uuid,serial --format=csv
index, name, uuid, serial
0, NVIDIA GeForce RTX 2060, GPU-b188d724-7bb6-7e4b-a3a2-267815c40df3, [N/A]

nvidia-smi dmon  : dynamically gpu usage monitor
nvidia-smi pmon  : dynamically process monitor
=cut

#nvidia-smi -q -d CLOCK
#nvidia-smi -q -d temperature
#pl, cclock,mclock
#nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits
#nvidia-settings -q gpucoretemp (-t for temp only)
my %OCsetting = (
    # power w, core freq, mem freq, Fan
    2060 => [125,"+200","+1300",85],#2060 --fan 99  --templimit 80
    2080 => [180,"+200","+1800",85],#2080 Ti --fan 80  --templimit 65
);

my $dnf_install = "no"; # yes for the first time setting
my $overclock = "yes";
my $gpu_info = "yes";

my %nodes = (
    161 => [1,3,39..42 ],
    182 => [20..24 ]
    );
my $ip = `ip a`;    
$ip =~ /140\.117\.\d+\.(\d+)/;
my $cluster = $1;
$cluster =~ s/^\s+|\s+$//;
#print "\$cluster: $cluster\n";
my @nodes = @{$nodes{$cluster}};#get node information
#for (@nodes){print "$_\n";}
#die; 
#
#install packages
if($dnf_install eq "yes"){
    for (@nodes){
        my $nodeindex=sprintf("%02d",$_);
        my $nodename= "node"."$nodeindex";
        my $cmd = "ssh $nodename ";
        print "\$nodename: $nodename\n";
        system("$cmd  'dnf config-manager --enable powertools'");
    #https://forketyfork.medium.com/centos-8-installation-error-setting-up-base-repository-4a64e7eb2e72
    #https://forketyfork.medium.com/centos-8-no-urls-in-mirrorlist-error-3f87c3466faa    
    #sudo sed -i -e "s|mirrorlist=|#mirrorlist=|g" /etc/yum.repos.d/CentOS-*
    #sudo sed -i -e "s|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g" /etc/yum.repos.d/CentOS-*
        system("$cmd  'sed -i -e \"s|mirrorlist=|#mirrorlist=|g\" /etc/yum.repos.d/CentOS-*'");
        system("$cmd  'sed -i -e \"s|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g\" /etc/yum.repos.d/CentOS-*'");
        system("$cmd  'dnf clean all'");
        system("$cmd  'dnf install xorg-x11-server-Xorg xorg-x11-xauth xorg-x11-apps xterm xinit libXv* -y'");
    }
}

#overclock setting

if($overclock eq "yes"){
    for (@nodes){
        my %GPUinfo;        
        my %maxclocks;        
        my %clocks;        
        my $nodeindex=sprintf("%02d",$_);
        my $nodename= "node"."$nodeindex";
        my $cmd = "ssh $nodename ";
        print "\n\$nodename: $nodename for GPU overclock\n";
        my @gpuinfo = `$cmd 'nvidia-smi -q'`;
        chomp @gpuinfo;
        my $counter = 0;
        my $maxclockL;#line number of max clock for getting the following 4 lines
        my $clockL;#line number of max clock for getting the following 4 lines
        for (@gpuinfo){
            s/^\s+|\s+$//;
            #print "$counter: $_\n";
            if(/Max Clocks/){$maxclockL = $counter;print "Max Clocks \$maxclockL:$maxclockL\n";}
            elsif(/^Clocks$/){$clockL = $counter;print "clockL \$clockL:$clockL\n"; }
            elsif(/(Fan Speed).+: (\d{2,}).+%$/){chomp ($1,$2);print "Fan Speed \$1,\$2: $1,$2\n"}
            elsif(/(Product Name).+(\d{4})/){chomp ($1,$2);print "Product Name \$1,\$2: $1,$2\n";$GPUinfo{$1} = $2;}
            elsif(/(GPU Current Temp).+(\d{2})/){chomp ($1,$2);print "GPU Current Temp \$1,\$2: $1,$2\n";$GPUinfo{$1} = $2;}
            #elsif(/(GPU Slowdown Temp).+(\d{2})/){chomp ($1,$2);print "GPU Slowdown Temp \$1,\$2: $1,$2\n"}
            #elsif(/(GPU Max Operating Temp).+(\d{2})/){chomp ($1,$2);print "GPU Max Operating Temp \$1,\$2: $1,$2\n"}
            #elsif(/(GPU Target Temperature).+(\d{2})/){chomp ($1,$2);print "GPU Target Temperature \$1,\$2: $1,$2\n"}
            elsif(/(Power Draw).+(\d{3})/){chomp ($1,$2);print "Power Draw \$1,\$2: $1,$2\n";$GPUinfo{$1} = $2;}
            elsif(/(^Power Limit).+(\d{3})/){chomp ($1,$2);print "Power Limit \$1,\$2: $1,$2\n";$GPUinfo{$1} = $2;}
            elsif(/(Min Power Limit).+(\d{3})/){chomp ($1,$2);print "Min Power Limit \$1,\$2: $1,$2\n";$GPUinfo{$1} = $2;}
            elsif(/(Max Power Limit).+(\d{3})/){chomp ($1,$2);print "Max Power Limit \$1,\$2: $1,$2\n";$GPUinfo{$1} = $2;}

            $counter++;
        }
       #get max clocks information from the line number of @gpuinfo 
        for my $max ($maxclockL + 1 .. $maxclockL + 4){
           print "\$max: $gpuinfo[$max]\n";
          if($gpuinfo[$max] =~ /(Graphics)\s+:\s+(\d+)/){chomp ($1,$2);print "Max Graphics \$1,\$2: $1,$2\n";$maxclocks{$1} = $2;}
          elsif($gpuinfo[$max] =~ /(Memory)\s+:\s+(\d+)/){chomp ($1,$2);print "Max Memory \$1,\$2: $1,$2\n";$maxclocks{$1} = $2;}
       } 
       #get clocks information from the line number of @gpuinfo
       for my $cl ($clockL + 1 .. $clockL + 4){ 
           print "\$clocks: $cl, $gpuinfo[$cl]\n";
          if($gpuinfo[$cl] =~ /(Graphics)\s+:\s+(\d+)/){chomp ($1,$2);print "Graphics \$1,\$2: $1,$2\n";$clocks{$1} = $2;}
          elsif($gpuinfo[$cl] =~ /(Memory)\s+:\s+(\d+)/){chomp ($1,$2);print "Memory \$1,\$2: $1,$2\n";$locks{$1} = $2;}
       } 
       
       print "==========Node name: $nodename=========\n";
       system("$cmd 'nvidia-smi -q|egrep \"Product Name\"'");
        
       print "*Before overclock\n";
       system("$cmd 'nvidia-smi -q|egrep -A4 \"^ +Clocks\\\$\"'");
       system("$cmd 'nvidia-smi -q|egrep \"Fan Speed\"'");
       system("$cmd 'nvidia-smi -q|egrep \"GPU Current Temp\"'");
       system("$cmd 'nvidia-smi -q|egrep \"Power Draw\"'");
       system("$cmd 'nvidia-smi -q|egrep \"^Power Limit\"'");
       system("$cmd 'nvidia-smi -q|egrep \"Min Power Limit\"'");
       system("$cmd 'nvidia-smi -q|egrep \"Max Power Limit\"'");
### Begin OC here!
        system("rm -f OC_$nodename.sh");
        system("cp OC_example.sh OC_$nodename.sh");
        my $pname = $GPUinfo{"Product Name"};
        chomp $pname;
        my @oc_setting = @{$OCsetting{$pname}};
        chomp @oc_setting;
        #for (@oc_setting){print "$_\n";}
        # power w, core freq, mem freq, Fan

        `sed -i 's:nvidia-smi -i 0 -pl .*:nvidia-smi -i 0 -pl $oc_setting[0]:' OC_$nodename.sh`;
        `sed -i '/GPUGraphicsClockOffset/d' OC_$nodename.sh`;
        `sed -i '/#GRA_anchor/a nvidia-settings -a "[gpu:0]/GPUGraphicsClockOffset[4]=$oc_setting[1]"' OC_$nodename.sh`;   
        
        `sed -i '/GPUMemoryTransferRateOffset/d' OC_$nodename.sh`;
        `sed -i '/#MEM_anchor/a nvidia-settings -a "[gpu:0]/GPUMemoryTransferRateOffset[4]=$oc_setting[2]"' OC_$nodename.sh`;   

        `sed -i '/GPUTargetFanSpeed/d' OC_$nodename.sh`;
        `sed -i '/#Fan_anchor/a nvidia-settings -a "[fan:0]/GPUTargetFanSpeed=$oc_setting[3]"' OC_$nodename.sh`;   
        system("scp  ./OC_$nodename.sh root\@$nodename:/root");
        system("$cmd 'chmod 755 ./OC_$nodename.sh'");
        `$cmd 'nohup ./OC_$nodename.sh'`;
        `$cmd 'rm ./OC_$nodename.sh'`;
        `rm -f ./OC_$nodename.sh`;

### OC done
sleep(1);#waiting up for overclocking results

       print "\n#After overclock\n";
       system("$cmd 'nvidia-smi -q|egrep -A4 \"^ +Clocks\\\$\"'");
       system("$cmd 'nvidia-smi -q|egrep \"Fan Speed\"'");
       system("$cmd 'nvidia-smi -q|egrep \"GPU Current Temp\"'");
       system("$cmd 'nvidia-smi -q|egrep \"Power Draw\"'");
       system("$cmd 'nvidia-smi -q|egrep \"^Power Limit\"'");
       system("$cmd 'nvidia-smi -q|egrep \"Min Power Limit\"'");
       system("$cmd 'nvidia-smi -q|egrep \"Max Power Limit\"'");


    }#loop over nodes
###

    
}#if command for overclock

#nvidia-xconfig -a --force-generate --allow-empty-initial-configuration --cool-bits=28 --no-sli --connected-monitor="DFP-0"
#nvidia-smi -pm 1
#nvidia-smi -pl 125
#nvidia-settings -c :0 -a [gpu:0]/GPUMemoryTransferRateOffset[2]=600
#nvidia-settings -c :0 -a [gpu:0]/GPUGraphicsClockOffset[2]=-100
#nvidia-settings -c :0 -a [gpu:0]/GPUFanControlState=1
#--
#xinit nvidia-settings -a [gpu:0]/GPUFanControlState=1 -a [fan:0]/GPUTargetFanSpeed=80 --  :0 -once


#
#dnf config-manager --enable powertools
#yum install xorg-x11-server-Xorg xorg-x11-xauth xorg-x11-apps xterm -y
#nvidia-xconfig --cool-bits=31 --allow-empty-initial-configuration
#systemctl set-default multi-user.target
#
#
#if($gpu_info eq "yes"){
#        my @gpucard = `$cmd 'lspci|grep NVIDIA|grep VGA'`;
#        chomp @gpucard;
#        my $allGPU = join(" ",@gpucard);
#        if(@gpucard){
#            `echo "" >> $output`;
#            `echo "$nodename GPU card info: $allGPU" >> $output`;
#            my @lsmod = `$cmd "lsmod | grep nouveau"`;
#            chomp @lsmod;
#            my $lsmod = join(" ",@lsmod);
#            `echo "lsmod output $lsmod" >> $output`;            
#        }
#        else{#no GPU card
#            `echo '' >> $output`;        
#            `echo "No GPU card in $nodename" >> $output`;  
#        }# 
#    }#gpu_card information
#
#use strict;
#use warnings;
#use Parallel::ForkManager;
#my @nodes = (1..27,32..42);
#my $forkNo = 1;
#my $pm = Parallel::ForkManager->new("$forkNo");
#
##my $remote_perl = "remote_setting.pl";
##my $remote_perl = "remote_NFS.pl";
#my $remote_perl = "NFSnode4server.pl";
##my $remote_perl = "parted4node.pl";
#for (@nodes){
#    $pm->start and next;
#    my $nodeindex=sprintf("%02d",$_);
#    my $nodename= "node"."$nodeindex";
#    my $cmd = "ssh $nodename ";
#    print "\$nodename: $nodename\n";
#    #system("$cmd  'df -h /free'");
#    system("scp  ./$remote_perl root\@$nodename:/root");
#    if ($?){print "BAD: scp  $remote_perl root\@$nodename:/root failed\n";};
#    system("$cmd 'echo $nodename > remote_setting.out'"); 
#    system("$cmd 'perl $remote_perl 2>&1 >> remote_setting.out'"); 
#    system("$cmd 'cat remote_setting.out'");
#    print "\n"; 
#    $pm->finish;
#}
#$pm->wait_all_children;
#
#
#my $shell_script = "
#\# start up X
#xinit &
#export DISPLAY=:0.0
#
#\# configure the card
#nvidia-smi -pm 1                                                      \# enable persistent mode
#nvidia-smi -i 0 -pl 80                                                \# set power rate limit at 80 watts
#nvidia-settings -a \"[gpu:0]/GpuPowerMizerMode=2\"                    \# set performance level 2 (high performance)
#nvidia-settings -a \'[gpu:0]/GPUFanControlState=1\'                     \# set manually controlled fan speed
#nvidia-settings -a \'[fan:0]/GPUTargetFanSpeed=75\'                     \# set fan speed to 75%
#nvidia-settings -a \'[gpu:0]/GPUGraphicsClockOffset[2]=-200'           \# set the GPU clock offset to -200 MHz (underclock)
#nvidia-settings -a '[gpu:0]/GPUMemoryTransferRateOffset[2]=+2200'     \# set the RAM clock offset to +2200 MHz (overclock)
#\# shut down x
#ps -ef | grep /usr/libexec/Xorg | grep -v grep | awk '{print \\\$2}' | xargs kill\n";