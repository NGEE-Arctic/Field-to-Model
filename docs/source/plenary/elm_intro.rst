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
testing the sensitivity of model results to changes in forcing conditions. 

If you just completed 'Step 2. Getting Started', first open a new Terminal window (Terminal, Cmd + N) and navigate to your field-to-model folder with the following code. For any code blocks starting with 'docker run', you should be in your field-to-model directory. 

.. code:: 

    cd field-to-model

You can see the options that are available for the script by running:

.. code:: 

    docker run -it --pull always --rm \
        -v  $(pwd):/home/modex_user \
        -v inputdata:/mnt/inputdata \
        -v output:/mnt/output \
        yuanfornl/ngee-arctic-modex26:models-main-latest \
        /home/modex_user/model_examples/ELM/run_ngeearctic_site.sh -h

In the first example, we will run a 'control' case for one of the NGEE Arctic sites where 
none of the new capabilities developed for NGEE Arctic have been turned on. There are 9 sites
you can choose from and substitute into the command below at <site_name> (must delete angle brackets):

.. code::

 docker run -it --pull always --rm \
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

We can open a second shell window (Terminal, Cmd + N for a new window, or Cmd + T for a new tab) and run a second set of cases while this first case is running. As an example, let's change the initial conditions of the first spinup case. By default, ELM initializes at 274K and at fairly dry soil conditions. A new initialization option, ``--use_arctic_init``, sets wetter and colder initial conditions for the first step (soil column at liquid saturation, and at a temperature varying between 290K and 250K based on `cos(lat)`).

.. code::

 docker run -it --pull always --rm \
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

Adding demography and disturbance: ELM-FATES
--------------------------------------------
FATES is the “Functionally Assembled Terrestrial Ecosystem Simulator.” It is an optional external module which can run within ELM to include alternative representations of ecosystem processes, namely vegetation demography and dynamic vegetation and disturbance.  FATES is a cohort- and patch-based model of vegetation competition and co-existence, allowing a representation of the terrestrial biosphere which accounts for the division of the land surface into successional stages, and for competition for light between height structured cohorts of representative trees of various plant functional types.

A very detailed explain of FATES can be found in this `Technical Documentation <https://fates-users-guide.readthedocs.io/projects/tech-doc/en/latest/index.html>`

The source code for FATES, as well as discussion boards, and tracking changes can be found in this `GitHub repository <https://github.com/NGEET/fates>`

For this workshop, we will not go into the details of setting up and running FATES. However, we encourage users to visit previous User Guide documentation, and past `FATES Tutorial documents <https://fates-users-guide.readthedocs.io/en/latest/>`(the latest tutorial was in Fall 2024). 
  
Here are a few quick instructions and tips for running ELM-FATES:
- FATES will use these same files from ELM: the surface file, domain file, climatology driver data, and ELM parameter file.  The main difference is that FATES has its own parameter file for FATES specific PFT and site level parameters. 
- Before running FATES we need to generate a parameter file that describes the traits of each Plant Functional Type (PFT) in our simulation.
- A main way to "turn on" the FATES model is through a compset. Example compsets for FATES are IELMFATES or I1850ELMFATES
- There is also a containerized version of FATES using Docker, which was created in 2024.




======================
Additional Resources
======================

1. What variables are on an ELM surface file? https://ngee-arctic.github.io/dapper/surface-variables.html#all-surface-variables
 
