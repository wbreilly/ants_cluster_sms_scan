#!/bin/bash -l 
#
#SBATCH --job-name=write_mtl_rois_10_22_18
#SBATCH --output=/home/wbreilly/sms_scan_crick/ants_data_10_20_18/logs/write_mtl_rois_10_22_18.%j.%N.out
#SBATCH --error=/home/wbreilly/sms_scan_crick/ants_data_10_20_18/logs/write_mtl_rois_10_22_18.%j.%N.err
#SBATCH --nodes=1
#SBATCH -c 1
#SBATCH --time=5-00:00:00
# #SBATCH -p high
#SBATCH --mem-per-cpu=2000 
#SBATCH --mail-type=ALL
#SBATCH --mail-user=wbreilly@ucdavis.edu
#SBATCH --array=1-34


date 
hostname
module load ants/2.2.0

export ANTSPATH=/group/dml/apps/ants/bin
export PATH=${ANTSPATH}:$PATH

export script_path=/home/wbreilly/sms_scan_crick/ants_data_10_20_18/ants_cluster_sms_scan
export PATH=${script_path}:$PATH

SEEDFILE=/home/wbreilly/sms_scan_crick/ants_data_10_20_18/ants_cluster_sms_scan/sub_array.txt # this is a file with the subjects to run one line for each subject i.e. sub01 sub02 etc.
SEED=$(cat $SEEDFILE | head -n $SLURM_ARRAY_TASK_ID | tail -n 1) 

SUBJECTS_DIR=/home/wbreilly/sms_scan_crick/ants_data_10_20_18/$SEED/mprage_sag_NS_g3

cd $SUBJECTS_DIR
echo $SUBJECTS_DIR

t1_image="$(ls s*.nii)"
echo $t1_image

# there's an option to use more than 1 thread but not sure how that works yet (-n <#threads>)
# srun antsRegistrationSyN.sh -d 3 -f $t1_image -m /home/wbreilly/halle_data_ants_crick/mtl_probabilistic_masks/MNI152_T1_1mm.nii.gz -o  $SUBJECTS_DIR/${SEED}_aligned_MNI_ 

srun $script_path/write_rois.sh $t1_image $SUBJECTS_DIR $SEED