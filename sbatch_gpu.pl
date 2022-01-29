=b
conducting gpu eth submission 
=cut
use warnings;
use strict;

for (0..5){
my $mod = $_ % 4;
my $temp = sprintf("%02d",$mod);
my $jobname = `date +%H`;
chomp $jobname;
$jobname = "dp_c$temp"."-$jobname"; 
`sed -i '/#SBATCH.*--job-name/d' ~/eth_scripts/slurm_dp.sh`;
`sed -i '/#sed_anchor01/a #SBATCH --job-name=$jobname' ~/eth_scripts/slurm_dp.sh`;
`/usr/local/bin/sbatch ~/eth_scripts/slurm_dp.sh`;

#`sed -i '/#SBATCH.*--job-name/d' /home/jsp/eth_scripts/slurm_dp.sh`;
#`sed -i '/#sed_anchor01/a #SBATCH --job-name=$jobname' /home/jsp/eth_scripts/slurm_dp.sh`;
#`sbatch /home/jsp/eth_scripts/slurm_dp.sh`;
}
