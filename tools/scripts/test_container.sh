#!/bin/bash -f

# test if ATS is on path
ats --version

# test if TEM is on path
dvmdostem --sha

# check home directory contents
ls ~

# check volume mounts:
ls /mnt

# test ilamb 
which ilamb-run 
python -c "import ILAMB; print(ILAMB.__version__)"

