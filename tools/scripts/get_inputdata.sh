#!/bin/sh -f

if [ -d "/mnt/inputdata/.git" ]; then
  git -C /mnt/inputdata pull --ff-only
else
  git clone --depth=1 --single-branch -b main https://github.com/ngee-arctic/field-to-model-inputdata /mnt/inputdata || true
  # unpack zipped data
  find /mnt/inputdata -name '*.gz' -exec gunzip -v {} +

  # make necessary folders in output volume
  mkdir -p /mnt/output/cime_case_dirs
  mkdir -p /mnt/output/cime_run_dirs
fi

# Download ILAMB Data
if [ -d "/mnt/inputdata/ILAMB/DATA" ]; then
 ilamb-fetch --local_root=/mnt/inputdata/ILAMB/DATA --remote_root=https://data.ngee-arctic.ornl.gov/ilamb/DATA --collection=NGEEA-Workshop --no-check-certificate
else
 mkdir -p /mnt/inputdata/ILAMB
 mkdir -p /mnt/inputdata/ILAMB/DATA
 ilamb-fetch -y --local_root=/mnt/inputdata/ILAMB/DATA --remote_root=https://data.ngee-arctic.ornl.gov/ilamb/DATA --collection=NGEEA-Workshop --no-check-certificate
fi

