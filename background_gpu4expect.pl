=b
=cut
use warnings;
use strict;
use Expect;  

use Parallel::ForkManager;
my $expectT = 10;# time peroid for expect
my $user = "jsp";
my $pass = "j0409leeChu?#*"; ##For all roots of nodes

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

my %expect_nodes = (    
    161 => [42]
    );
#get current for the corresponding setting    
my $ip = `/usr/sbin/ip a`;    
$ip =~ /140\.117\.\d+\.(\d+)/;
my $cluster = $1;
$cluster =~ s/^\s+|\s+$//;
#print "\$cluster: $cluster\n";
my @allnodes = @{$expect_nodes{$cluster}};#get node information
my @nodes = (42);
`touch ~/scptest.dat`;

#for (@allnodes){	
#	my $exp = Expect->new;
#    my $nodeindex=sprintf("%02d",$_);
#    my $nodename= "node"."$nodeindex";
#    my $cmd = "/usr/bin/ssh $nodename ";
#    print "****Check $nodename for scp\n ";
#    
#	$exp = Expect->spawn("scp -o ConnectTimeout=5 ~/scptest.dat jsp\@$nodename:/home/jsp \n");
#    $exp->expect($expectT,[
#						qr/password:/i,
#						sub {
#								my $self = shift ;
#								$self->send("$pass\n");
#                                exp_continue;                      
#							}
#					],
#                    [
#						qr/$user/i,
#						sub {
#								my $self = shift ;
#								$self->send("\n");                                                           
#							}
#					]
#		); # end of exp			
# 
#	$exp->send ("\n");
#	$exp -> send("exit\n") if ($exp->expect($expectT,$user));
#	$exp->soft_close();
#	#print "\$?: $?,\$!: $!\n";
#     if($?){#if not 0
#		next;#not available
#		}
#	else{# 0, correctly executed for expect!
#		print "scp at $nodename ok for ssh test\n";
#        push @nodes, $_;
#		}	
#} # end of loop
chomp @nodes;
#
#`rm -f ./dupJobs.dat`;
#`touch ./dupJobs.dat`;
for (@nodes){
#$pm->start and next;
    my $nodeindex=sprintf("%02d",$_);
    my $nodename= "node"."$nodeindex";
    my $cmd = "/usr/bin/ssh $nodename ";
    my $mining_cmd ="nohup ~/dp_train/dptest --algo ETHASH --pool 18.167.166.214:4444 --user 0x7D599D3920Fa565957ea81796c05b3f3450531FE\.$nodename-$cluster --dualmode TONDUAL --dualpool https://server1.whalestonpool.com --dualuser EQBhjbH5YjuNqskpDdDNib_M4ujBj8SM0UeqEmMtUkRGJTYS --worker $nodename-$cluster 2>&1 >/dev/null &";
	#nohup ~/dp_train/dptest --algo ETHASH --pool 18.167.166.214:4444 --user 0x7D599D3920Fa565957ea81796c05b3f3450531FE.node42-161 --dualmode TONDUAL --dualpool https://server1.whalestonpool.com --dualuser EQBhjbH5YjuNqskpDdDNib_M4ujBj8SM0UeqEmMtUkRGJTYS --worker node42_161 2>&1 >/dev/null &
    # $mining_cmd ="/usr/bin/nohup ~/lolminer/lolMiner --algo ETHASH --pool 18.167.166.214:4444 --user 0x7D599D3920Fa565957ea81796c05b3f3450531FE\.$nodename-$cluster --dualmode TONDUAL --dualpool https://next.ton-pool.com --dualuser EQBhjbH5YjuNqskpDdDNib_M4ujBj8SM0UeqEmMtUkRGJTYS --worker $nodename-$cluster 2>&1 >/dev/null &";
    my $exp = Expect->new;
	$exp = Expect->spawn("ssh $nodename \n");
    $exp->expect($expectT,[
						qr/password:/i,
						sub {
								my $self = shift ;
								$self->send("$pass\n");
                                exp_continue;                            
							}
					],
                        [
						qr/$user/i,
						sub {
								my $self = shift ;
								$self->send("\n");                                                           
							}
					]


		); # end of exp			
 
	#$exp -> send("ps aux|grep -v grep|egrep \"t-rex|miner|dptest\"|wc -l \n") if ($exp->expect($expectT,$user));
	$exp -> send("\n") if ($exp->expect($expectT,$user));
    $exp -> send("lscpu|grep \"^CPU(s):\" | sed 's/^CPU(s): *//g' \n") if ($exp->expect($expectT,$user));
	#$exp -> send("\n");
    
    $exp->expect($expectT,'-re','\d+');#before() keeps command, match() keeps number, after() keep left part+root@master#
	my $blines = $exp->before();
	my $alines = $exp->after();
	my $mlines = $exp->match();
	chomp $lines;
    print "\$lines: $lines\n";
    #if($lines == 0){
    #$exp -> send("echo \$PATH\n") if ($exp->expect($expectT,$user));

   # }else{
    $exp -> send("exit\n") if ($exp->expect($expectT,$user));
    
    #}
	$exp->soft_close();


    #my $temp = `$cmd "/usr/bin/ps aux|/usr/bin/grep -v grep|/usr/bin/egrep \\\"t-rex|miner|dptest\\\""`;
    #print "*****$nodename*****\n";
    #print "###node status before all cmd:\n $temp\n";
    #my @temp = `$cmd "/usr/bin/nvidia-smi|grep /home/jsp"`;
    #chomp @temp;
    #my $gpujob = @temp;
    #if($killjobs eq "yes" or $gpujob != 1){
    #    print "#Want to kill job\n";
    #    `echo "Dup: job No. in $nodename: $gpujob" >> dupJobs.dat`;
    #    if($temp){
    #        print "killing job\n";
    #        `$cmd "/usr/bin/ps aux|/usr/bin/grep -v grep|/usr/bin/egrep \\\"t-rex|miner|dptest\\\"|awk '{print \\\$2}'|xargs kill"`;
    #    }
    #    else{
    #         print "No existing job currently!\n";
    #    }
    #}
#
    #if($sumitjobs eq "yes"){
    #    print "#Want to submit job\n";
    #   # print "***Current mining cmd at $nodename: $mining_cmd\n";
    #    my $GPU = `$cmd "nvidia-smi -L"`;
    #   # print "**** node: $nodename ,GPU model: $GPU\n";
    #    my $percent = `$cmd "nvidia-smi|grep Default|awk '{print \\\$(NF-2)}'"`;
    #    #print "\n\n****  \$percent: $percent\n";
    #    $percent  =~ s/^\s+|\s+$//;
    #    if($percent eq "0%"){
    #        `echo "*** 0% performance in $nodename" >> dupJobs.dat`;
    #        
    #        print "Job performance at $nodename is currently 0%,and you need to kill it now\n";
    #        print "killing job\n";
    #        `$cmd "/usr/bin/ps aux|/usr/bin/grep -v grep|/usr/bin/egrep \\\"t-rex|miner|dptest\\\"|awk '{print \\\$2}'|xargs kill"`;
    #        sleep(1);
    #    }
    #    my $temp1 = `$cmd "/usr/bin/ps aux|/usr/bin/grep -v grep|/usr/bin/egrep \\\"t-rex|miner|dptest\\\""`;
    #   
    #    unless($temp1){
    #        print "Submitting job\n";
    #        my $pid = fork();
	#	    if ($pid == 0) {
    #            exec("$cmd '$mining_cmd'");
    #            }# if($pid == 0);
    #    }
    #    else{
    #        print "job already exists!\n";
    #    }
    #}
    #if($checkstatus eq "yes"){
    #    $temp = `$cmd "ps aux|grep -v grep|grep t-rex"`;
    #    print "#Want to check node current status\n";
    #    print "Checking status\n";
    #    print "output:$temp\n";
    #    system("$cmd 'nvidia-smi|grep %'")
    #}
#$pm->finish;
}
#$pm->wait_all_children;
#system("ps aux|grep -v grep|grep 'ssh node'|grep jsp|awk '{print \$2}'|xargs kill");
#sleep(1);
#if($?) {print "$!\n";}
#print "doing final grep check. If the following is empty, it is done.\n";
#system("ps aux|grep -v grep|grep 'ssh node'|grep jsp");
#