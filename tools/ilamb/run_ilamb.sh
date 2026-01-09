#!/bin/bash

# Set ILAMB_ROOT 
export ILAMB_ROOT="/mnt/inputdata/ILAMB" # ILAMB needs this as a global variable

echo "Run ILAMB"
cd $HOME
mkdir -p ilamb_builds
# All outputs will be created in current directory
echo $PWD

# Run ilamb -- test 1
# Create directory for the ILAMB outputs
mkdir -p "ilamb_builds/build_IM2_20260115_1"

ilamb-run --config tools/ilamb/1_config_IM2.cfg \
  --model_setup tools/ilamb/models_IM2.yaml \
  --build_dir ilamb_builds/build_IM2_20260115_1 \
  --study_limits 2000 2014 \
  --define_regions /mnt/inputdata/ILAMB/DATA/NGEEA-Workshop/regions/ILAMB_region_CAVM_NO_GREENLAND.nc

# Run ilamb -- test 2
# Create directory for the ILAMB outputs
mkdir -p "ilamb_builds/build_IM2_20260115_2"

ilamb-run --config tools/ilamb/2_config_IM2.cfg \
  --model_setup tools/ilamb/models_IM2.yaml \
  --build_dir ilamb_builds/build_IM2_20260115_2 \
  --study_limits 2000 2014 \
  --define_regions /mnt/inputdata/ILAMB/DATA/NGEEA-Workshop/regions/ILAMB_region_CAVM_NO_GREENLAND.nc

# Run ilamb -- test 3
# Create directory for the ILAMB outputs
mkdir -p "ilamb_builds/build_IM2_20260115_3"

ilamb-run --config tools/ilamb/3_config_IM2.cfg \
  --model_setup tools/ilamb/models_IM2.yaml \
  --build_dir ilamb_builds/build_IM2_20260115_3 \
  --study_limits 2000 2014 \
  --define_regions /mnt/inputdata/ILAMB/DATA/NGEEA-Workshop/regions/ILAMB_region_CAVM_NO_GREENLAND.nc

