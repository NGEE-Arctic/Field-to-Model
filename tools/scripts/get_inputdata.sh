#!/bin/sh -f

if [ -d "/mnt/inputdata/.git" ]; then
  git -C /mnt/inputdata fetch
  git -C /mnt/inputdata reset --hard origin/main
else
  git clone --depth=1 --single-branch -b main https://github.com/ngee-arctic/field-to-model-inputdata /mnt/inputdata || true
  # unpack zipped data
  find /mnt/inputdata -name '*.gz' -exec gunzip -v {} +

  # make necessary folders in output volume
  mkdir -p /mnt/output/cime_case_dirs
  mkdir -p /mnt/output/cime_run_dirs
fi

