=b
conducting gpu eth submission 
=cut
use warnings;
use strict;
use Parallel::ForkManager;
my $forkNo = 1;
my $pm = Parallel::ForkManager->new("$forkNo");
my @nodes = (1,3,39..42);
#my $killjobs = "yes";
my $sumitjobs = "no";

my $killjobs = "no";
#my $sumitjobs = "no";

my $checkstatus = "yes";
for (@nodes){
$pm->start and next;
    my $nodeindex=sprintf("%02d",$_);
    my $nodename= "node"."$nodeindex";
    my $cmd = "ssh $nodename ";
    my $mining_cmd;
    if($nodename eq "node01" or $nodename eq "node39" or $nodename eq "node40"){
#https://ethermine.org/miners/0x7d599d3920fa565957ea81796c05b3f3450531fe/dashboard
        $mining_cmd = "nohup ~/eth/t-rex -a ethash -o stratum+tcp://asia1.ethermine.org:4444 \\
                      -u 0x7D599D3920Fa565957ea81796c05b3f3450531FE -p x -w $nodename 2>&1 >/dev/null &";
    }
    else{
#https://https://www.flexpool.io/

        $mining_cmd = "nohup ~/eth/t-rex -a ethash -o stratum+ssl://eth-hk.flexpool.io:5555 -o stratum+ssl://eth-hke.flexpool.io:5555 \\
    -u 0x7D599D3920Fa565957ea81796c05b3f3450531FE -p x -w $nodename 2>&1 >/dev/null &";
    }

    my $temp = `$cmd "ps aux|grep -v grep|grep t-rex"`;
    print "*****$nodename*****\n";
    print "###node status before all cmd:\n $temp\n";
    
    if($killjobs eq "yes"){
        print "#Want to kill job\n";
        
        if($temp){
            print "killing job\n";
            `$cmd "ps aux|grep -v grep|grep t-rex|awk '{print \\\$2}'|xargs kill"`;
        }
        else{
             print "No existing job currently!\n";
        }
    }

    if($sumitjobs eq "yes"){
        print "#Want to submit job\n";
        
        unless($temp){
            print "Submitting job\n";
            my $pid = fork();
		    if ($pid == 0) {exec("$cmd '$mining_cmd'");}# if($pid == 0);
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