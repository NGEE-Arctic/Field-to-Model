#!/bin/bash

# Automated test script to run the TEM EE1 warming experiment
# The commands in here should be the same as those in the documentation at
# docs/source/plenary/tem_ee1_warming.rst.
#
# Sure would be nice to have a way to automatically sync this script with that
# documentation...

# NOTE: One differece from the documentation is that this script reduces the 
# number of running years from 1000 to 100 for speed.

INPUT_DATA_NAME=$1

# Setup and run the 
mkdir -p /mnt/output/tem/tem_ee1_warming
cd /mnt/output/tem/tem_ee1_warming
pyddt-swd --input-data-path /mnt/inputdata/TEM/$INPUT_DATA_NAME --copy-inputs control
cd control/
pyddt-outspec config/output_spec.csv --on GPP m p
pyddt-outspec config/output_spec.csv --on LAYERDZ m l
pyddt-outspec config/output_spec.csv --on TLAYER m l
pyddt-outspec config/output_spec.csv --on CMTNUM y
pyddt-outspec config/output_spec.csv -s
dvmdostem -f config/config.js -p 10 -e 10 -s 25 -t 123 -n 0 --force-cmt 6 -l monitor

cd /mnt/output/tem/tem_ee1_warming
pyddt-swd --input-data-path /mnt/inputdata/TEM/$INPUT_DATA_NAME --copy-inputs warming_2.6C_JJAS_2019
cd /mnt/output/tem/tem_ee1_warming/warming_2.6C_JJAS_2019
python /home/modex_user/model_examples/TEM/modify_air_temperature.py --input-file inputs/$INPUT_DATA_NAME/historic-climate.nc --months 6 7 8 9 --years 2019 --deviation 2.6
mv inputs/$INPUT_DATA_NAME/modified_historic-climate.nc inputs/$INPUT_DATA_NAME/historic-climate.nc
cp ../control/config/output_spec.csv config/output_spec.csv
dvmdostem -f config/config.js -p 10 -e 10 -s 25 -t 123 -n 0 -l monitor --force-cmt 6



