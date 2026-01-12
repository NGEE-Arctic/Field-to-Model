#!/bin/bash
set -e # exit on error

# Automated test script to run the TEM EE2 breakout group runs
# The commands in here should be the same as those in the documentation at
# docs/source/breakout/TEM_mode.rst.
#
# Sure would be nice to have a way to automatically sync this script with that
# documentation...!!

# NOTE: One differece from the documentation is that this script reduces the
# number of running years from 1000 to 100 for speed. Also this script
# automatically figures out how many years of historic data are in the input
# dataset.

# Workshop actual is 1000, 250, in order to get full outputs to analyze...
PR_YRS=10     # 100 workshop actual
EQ_YRS=10     # 1000
SP_YRS=25     # 250
SC_YRS=0

INPUT_DATA_NAME=$1


##############################
# Setup
##############################

mkdir -p /mnt/output/tem/tem_ee2_breakout
cd /mnt/output/tem/tem_ee2_breakout

pyddt-swd \
   --input-data-path /mnt/inputdata/TEM/$INPUT_DATA_NAME \
   --copy-inputs \
   --force \
   baseline_tussock

pyddt-swd \
   --input-data-path /mnt/inputdata/TEM/$INPUT_DATA_NAME \
   --copy-inputs \
   --force \
   warming_imnavait_tussock

 pyddt-swd \
   --input-data-path /mnt/inputdata/TEM/$INPUT_DATA_NAME \
   --copy-inputs \
   --force \
   precip_imnavait_tussock

 pyddt-swd \
   --input-data-path /mnt/inputdata/TEM/$INPUT_DATA_NAME \
   --copy-inputs \
   --force \
   warming_and_precip_imnavait_tussock


##############################
# Baseline run
##############################
echo "Baseline run..."

cd /mnt/output/tem/tem_ee2_breakout/baseline_tussock

# have to look this up once we are in the baseline run dir
# Lookup how much transient data we have...
TRANSIENT_YRS=$(python -c "import xarray; ds = xarray.open_dataset('inputs/$INPUT_DATA_NAME/historic-climate.nc'); print(int(ds.sizes['time']/12))")

pyddt-runmask --reset --yx 0 0 inputs/$INPUT_DATA_NAME/run-mask.nc

pyddt-outspec config/output_spec.csv --on GPP m p
pyddt-outspec config/output_spec.csv --on LAYERDZ m l
pyddt-outspec config/output_spec.csv --on TLAYER m l
pyddt-outspec config/output_spec.csv --on SWE m
pyddt-outspec config/output_spec.csv --on SNOWTHICK m
pyddt-outspec config/output_spec.csv --on ALD y
pyddt-outspec config/output_spec.csv --on CMTNUM y

dvmdostem -f config/config.js --force-cmt 5 -p $PR_YRS -e $EQ_YRS -s $SP_YRS -t $TRANSIENT_YRS -n $SC_YRS -l monitor

##############################
# Do the warming
##############################
echo "Warming run..."
cd /mnt/output/tem/tem_ee2_breakout/warming_imnavait_tussock
python /home/modex_user/model_examples/TEM/modify_air_temperature.py \
  --input-file inputs/$INPUT_DATA_NAME/historic-climate.nc \
  --months 6 7 8 9 \
  --years 2010 2011 2012 \
  --deviation 3
mv inputs/$INPUT_DATA_NAME/modified_historic-climate.nc \
   inputs/$INPUT_DATA_NAME/historic-climate.nc
pyddt-runmask --reset --yx 0 0 inputs/$INPUT_DATA_NAME/run-mask.nc
pyddt-outspec config/output_spec.csv --on GPP m p
pyddt-outspec config/output_spec.csv --on LAYERDZ m l
pyddt-outspec config/output_spec.csv --on TLAYER m l
pyddt-outspec config/output_spec.csv --on SWE m
pyddt-outspec config/output_spec.csv --on SNOWTHICK m
pyddt-outspec config/output_spec.csv --on ALD y
pyddt-outspec config/output_spec.csv --on CMTNUM y
dvmdostem -f config/config.js --force-cmt 5 -p $PR_YRS -e $EQ_YRS -s $SP_YRS -t $TRANSIENT_YRS -n $SC_YRS -l monitor

##############################
# Do the precip scaling
##############################
echo "Precip run..."

cd /mnt/output/tem/tem_ee2_breakout/precip_imnavait_tussock

python /home/modex_user/model_examples/TEM/modify_precipitation.py \
   --input-file inputs/$INPUT_DATA_NAME/historic-climate.nc \
   --months 6 7 8 9 \
   --years 2010 2011 2012 \
   --deviation 0.4
mv inputs/$INPUT_DATA_NAME/modified_historic-climate.nc \
   inputs/$INPUT_DATA_NAME/historic-climate.nc
python /home/modex_user/model_examples/TEM/modify_precipitation.py \
   --input-file inputs/$INPUT_DATA_NAME/historic-climate.nc \
   --months 10 11 12 1 2 3 4 5 \
   --years 2010 2011 2012 \
   --deviation 0.6
mv inputs/$INPUT_DATA_NAME/modified_historic-climate.nc \
   inputs/$INPUT_DATA_NAME/historic-climate.nc
pyddt-runmask --reset --yx 0 0 inputs/$INPUT_DATA_NAME/run-mask.nc
pyddt-outspec config/output_spec.csv --on GPP m p
pyddt-outspec config/output_spec.csv --on LAYERDZ m l
pyddt-outspec config/output_spec.csv --on TLAYER m l
pyddt-outspec config/output_spec.csv --on SWE m
pyddt-outspec config/output_spec.csv --on SNOWTHICK m
pyddt-outspec config/output_spec.csv --on ALD y
pyddt-outspec config/output_spec.csv --on CMTNUM y

dvmdostem -f config/config.js --force-cmt 5 -p $PR_YRS -e $EQ_YRS -s $SP_YRS -t $TRANSIENT_YRS -n $SC_YRS -l monitor

#################################
# Combined temp/precip scaling
#################################
echo "Combined run..."

cd /mnt/output/tem/tem_ee2_breakout/warming_and_precip_imnavait_tussock

python /home/modex_user/model_examples/TEM/modify_precipitation.py \
  --input-file inputs/$INPUT_DATA_NAME/historic-climate.nc \
  --months 6 7 8 9 \
  --years 2010 2011 2012 \
  --deviation 0.4
mv inputs/$INPUT_DATA_NAME/modified_historic-climate.nc \
   inputs/$INPUT_DATA_NAME/historic-climate.nc

python /home/modex_user/model_examples/TEM/modify_precipitation.py \
  --input-file inputs/$INPUT_DATA_NAME/historic-climate.nc \
  --months 10 11 12 1 2 3 4 5 \
  --years 2010 2011 2012 \
  --deviation 0.6
mv inputs/$INPUT_DATA_NAME/modified_historic-climate.nc \
   inputs/$INPUT_DATA_NAME/historic-climate.nc

python /home/modex_user/model_examples/TEM/modify_air_temperature.py \
  --input-file inputs/$INPUT_DATA_NAME/historic-climate.nc \
  --months 6 7 8 9 \
  --years 2010 2011 2012 \
  --deviation 3
mv inputs/$INPUT_DATA_NAME/modified_historic-climate.nc \
   inputs/$INPUT_DATA_NAME/historic-climate.nc

pyddt-runmask --reset --yx 0 0 inputs/$INPUT_DATA_NAME/run-mask.nc

pyddt-outspec config/output_spec.csv --on GPP m p
pyddt-outspec config/output_spec.csv --on LAYERDZ m l
pyddt-outspec config/output_spec.csv --on TLAYER m l
pyddt-outspec config/output_spec.csv --on SWE m
pyddt-outspec config/output_spec.csv --on SNOWTHICK m
pyddt-outspec config/output_spec.csv --on ALD y
pyddt-outspec config/output_spec.csv --on CMTNUM y

dvmdostem -f config/config.js --force-cmt 5 -p $PR_YRS -e $EQ_YRS -s $SP_YRS -t $TRANSIENT_YRS -n $SC_YRS -l monitor