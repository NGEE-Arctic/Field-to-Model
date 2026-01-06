Introduction to ELM and workshop scripts
=========================================

The E3SM Land Model (ELM) is the land surface component of the coupled E3SM model. 
ELM simulates a wide set of land surface and ecosystem processes, including surface 
energy balance, photosynthesis, carbon allocation, soil and surface hydrology, 
nitrogen and phosphorus dynamics, and snow processes, among others. 
ELM can be run by itself (if provided meteorological forcing data) or in 
different coupling configurations of E3SM. In addition, ELM can be run in point 
(e.g., single grid cell), regional, or global configurations.

For this workshop, we have simplified the process of running ELM for several Arctic 
sites using a shell script. Several of the new parameterizations added in phase 3 of 
the NGEE Arctic project are accessible through this script, as are several ways of 
testing the sensitivity of model results to changes in forcing conditions. You can 
see the options that are available for the script by running:

.. code:: 

    docker run -it --rm \
        -v  $(pwd):/home/modex_user \
        -v inputdata:/mnt/inputdata \
        -v output:/mnt/output \
        yuanfornl/ngee-arctic-modex26:models-main-latest \
        /home/modex_user/model_examples/ELM/run_ngeearctic_site.sh -h

In the first example, we will run a 'control' case for one of the NGEE Arctic sites where 
none of the new capabilities developed for NGEE Arctic have been turned on. There are 9 sites
you can choose from and substitute into the command below at <site_name>:

.. code::

 docker run -it --rm \
    -v  $(pwd):/home/modex_user \
    -v inputdata:/mnt/inputdata \
    -v output:/mnt/output \
    yuanfornl/ngee-arctic-modex26:models-main-latest \
    /home/modex_user/model_examples/ELM/run_ngeearctic_site.sh --site_name=<site_name>

This command will run three ELM cases (Rosenbloom and Thorton, 2004): a) a spinup with accelerated
biogeochemical cycling (to more rapidly spinup biogeochemical pools), b) a second stage of spinup with
normal biogeochemical cycling rates, and c) a transient run with time-varying CO2 and meteorological forcing
from 1850 to near present (2024 for ERA5, 2014 for GSWP3). In this default configuration, ERA5 meteorological
forcing from dapper will be used, but GSWP3 is available as an option for comparison.

We can open a second shell window and run a second set of cases while this first case is running. As an example,
let's change the initial conditions of the first spinup case. By default, ELM initializes at 274K and at fairly dry
soil conditions. A new initialization option, ``--use_arctic_init``, sets wetter and colder initial conditions for
the first step (soil column at liquid saturation, and at a temperature varying between 290K and 250K based on `cos(lat)`).

.. code::

 docker run -it --rm \
    -v  $(pwd):/home/modex_user \
    -v inputdata:/mnt/inputdata \
    -v output:/mnt/output \
    yuanfornl/ngee-arctic-modex26:models-main-latest \
    /home/modex_user/model_examples/ELM/run_ngeearctic_site.sh --site_name=<site_name> \
    --use_arctic_init --case_prefix=Arctic_init

After these runs are completed, we can compare the impacts of this initialization choice using the visualization containers.

.. warning::
    Note that if you rerun one of these commands, the existing output and case directories for these simulations are removed!
    Therefore, if you want to perform a second simulation on a site, you should also set the `--case_prefix` option so that
    the case has a different name. In this case, we have set it to "Arctic_init" to distinguish it from our control.


Under the hood
--------------
The script we have developed simplifies the interface to the Offline Land Model Testbed (OLMT), developed by
Dan Ricciuto (ORNL). OLMT itself simplifies the setup of model cases necessary to spin up an ELM simulation from
a 'cold start' condition. (Figure of hierarchy?). OLMT sets up three cases that run consecutively: an 'accelerated'
decomposition spin up that features accelerated biogeochemical cycling, a second stage of spin up with normal
biogeochemical cycling rates, and finally a transient run that starts in 1850 and continues to near present
(depending on how long the forcing datasets run). OLMT automates the setup of these cases through the E3SM case
control system (CIME - Common Infrastructure for Modeling the Earth).

======================
Additional Resources
======================

1. What variables are on an ELM surface file? https://ngee-arctic.github.io/dapper/surface-variables.html#all-surface-variables
 
