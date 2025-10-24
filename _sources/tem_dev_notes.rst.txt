TEM Setup Details
================================

Build Images
**************

Ultimately this will be done by CI but this is the command I was using for dev.
Note the means of getting the version ID from TEM repo. This gets injected into
the compiled binary.

.. code::

  docker build --build-arg TEM_VERSION=$(git -C TEM describe) \
      -t model-container -f Docker/Dockerfile-models .  


Note that some of the TEM install could get moved to the base image. Or
otherwise re-arranged, but it was useful to have it all together at the end
of the build for faster development.

Start Container
********************* 

Note the explicit directory for this repo inside the container to prevent
mounting over the home directory (and obscuring all the stuff in it like the
install directories!!).

.. code::

  docker volume create workshop_data
  docker run -it --rm \
         --port 9999:9999 \
         -v workshop_data:/home/modex_user/workshop_data \
         -v $(pwd):/home/modex_user/Field-To-Model model-container:latest

Demo run
*********************

Proof of concept that the installation and compilation worked. Also shows how to
use the :code:`pyddt` tools to set up a working directory for a run, modify some
settings, and run the model.

.. code::

  # Make a place to save our output...
  mkdir runs

  # Use the helper tool to setup a working directory for your experiment
  # has copies of parameters, config files, and 
  pyddt-swd --input-data-path install_dvmdostem/demo-data/cru-ts40_ar5_rcp85_ncar-ccsm4_toolik_field_station_10x10/ runs/EE3_warming

  # Fiddle with the settings...single pixel, turn on some output variables...
  cd runs/EE3_warming/
  pyddt-runmask --reset --yx 5 5
  pyddt-runmask --reset --yx 5 5 run-mask.nc 

  pyddt-outspec config/output_spec.csv --on LAYERDZ m l
  pyddt-outspec config/output_spec.csv --on TLAYER m l 

  # check the outspec file to see what we have...
  pyddt-outspec -s config/output_spec.csv 

  # Run the model
  dvmdostem -p 25 -e 25 -s 15 -t 115 -n 85

  # outputs are in the output folder!
  ls output/
