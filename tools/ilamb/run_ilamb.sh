#!/bin/bash


# Set ILAMB_ROOT 
export ILAMB_ROOT="/mnt/inputdata/ILAMB" # ILAMB needs this as a global variable

ILAMB_RUN_NAME="build_IM2_20260106_3" # Output directory with this name will be created to store ILAMB results 
MODELS_YAML_NAME="models_IM2.yaml"    # describes model simulations to be evaluated
CONFIG_FILE_NAME="config_IM2.cfg"     # describes confrontations to be conducted for variables/observations


echo "Run ILAMB"
mkdir -p /mnt/output/ILAMB
mkdir -p /mnt/output/ILAMB/finished_builds
cd /mnt/output/ILAMB
# All outputs will be created in current directory
echo $PWD
OUTDIR=$ILAMB_RUN_NAME

#rm -rf "$OUTDIR"; mkdir -p "$OUTDIR"
mkdir -p "finished_builds/$OUTDIR"

ilamb-run --config /home/modex_user/Field-to-Model/tools/ilamb/1_config_IM2.cfg \
  --model_setup /home/modex_user/Field-to-Model/tools/ilamb/models_IM2.yaml \
  --build_dir finished_builds/$OUTDIR \
  --study_limits 2000 2014 \
  --define_regions /mnt/inputdata/ILAMB/DATA/regions/ILAMB_region_CAVM_NO_GREENLAND.nc

