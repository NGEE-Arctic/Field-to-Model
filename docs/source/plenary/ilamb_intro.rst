International Land Model Benchmarking (ILAMB) 
=============================================

The ILAMB is a python package which provides systematic assessment and
benchmarking of land surface models by confronting them with reference
datasets. ILAMB works with CF-compliant NetCDF files, such as outputs
from CMIP models distributed by ESGF. 

ILAMB can also read outputs from ELM in their native format and supports
both structured and unstructured grids for gridded or point scale
simulations. As part of this workshop we will explore features of ILAMB using a
series of Pan-Arctic scale gridded simulations conducted using ELM.


Get the ILAMB model and observation data
----------------------------------------
Skip if you have completed this step before

.. code::

    docker run -it --rm \
        -v $(pwd):/home/modex_user \
        -v inputdata:/mnt/inputdata \
        yuanfornl/ngee-arctic-modex26:models-main-latest \
        /home/modex_user/tools/scripts/get_inputdata.sh

ILAMB includes ``ilamb-fetch`` tool to get data from ILAMB data servers.

.. code::

    $ ilamb-fetch -h
    usage: ilamb-fetch [-h] [--local_root PATH] [--remote_root PATH] [-k COLLECTION] [-c] [--no-check-certificate] [-y]
    
    options:
      -h, --help            show this help message and exit
      --local_root PATH     Location on your system.
      --remote_root PATH    Location on the remote system.
      -k, --collection COLLECTION
                            Data collection to download. [Options: ILAMB-Data (default); ABoVE-Data; NGEEA-Data;]
      -c, --create          Enable to create a sha1sum check file of the contents of the local root
      --no-check-certificate
                            Enable to skip checking authenticity of the downloaded certificate
      -y                    Enable to automatically accept the query to download files

ILAMB data *collections* offer thematic collection of reference
datasets. This workshop will use ``NGEEA-Workshop`` collection hosted on
NGEE Arctic data servers and can be downloaded using ``ilamb-fetch``.

.. code::

    ilamb-fetch --local_root=/mnt/inputdata/ILAMB/DATA --remote_root=https://data.ngee-arctic.ornl.gov/ilamb/DATA --collection=NGEEA-Workshop --no-check-certificate

Data in ILAMB collection are organized in following hierarchy tree.

.. code::
    
    .
    ├── biomass
    │   └── ESACCI
    │       └── biomass.nc
    ├── ch4
    │   └── FluxnetANN
    │       └── FCH4_F_ANN_monthly_wetland_tier1.nc
    ├── cSoil
    │   └── HWSD2
    │       ├── cSoilAbove1m_fx_HWSD2_19600101-20220101.nc
    │       └── cSoil_fx_HWSD2_19600101-20220101.nc


Models yaml Files
-----------------
Model simulations to be included in the benchmarking analysis can be
described via a simple YAML file. YAML file to be used in this workshop
is available in *Field-to-Model* repository at
``Field-to-Model/tools/ilamb``.

.. code::

    ## Model simulations to be analyzed from IM2 
    ## Simulations below were forced using GSWP3
    
    ELM_Panarctic_Baseline_GSWP3:
      modelname: 1.Base.GSWP3
      color: "#1f78b4"    # GSWP3 baseline (blue, medium)
      path: /mnt/inputdata/ILAMB/DATA/NGEEA-Workshop/models/MasterE3SM_pan-arctic-CAVM0.5deg_GSWP3_RERUN.longitude.fix_2D
    
    ELM_Panarctic_TopoUnits_GSWP3:
      modelname: 2.+Topo.GSWP3.NoDS
      color: "#9ecae1"    # GSWP3 +Topo (blue, lighter)
      path: /mnt/inputdata/ILAMB/DATA/NGEEA-Workshop/models/MasterE3SM_test-topounit-surf-v2_pan-arctic-CAVM0.5deg_GSWP3
    
    ELM_Panarctic_HillslopeHydro_GSWP3:
      modelname: 3.+IM2.GSWP3.withDS
      color: "#0b559f"    # GSWP3 +IM2 (blue, darker)
      path: /mnt/inputdata/ILAMB/DATA/NGEEA-Workshop/models/MasterE3SM_IM-2-no-phen_pan-arctic-CAVM0.5deg_gswp3

**ELM_Panarctic_Baseline_GSWP3** -- Pan-Arctic scale 0.5 degree resolution baseline ELM simulation forced using GSWP3.

**ELM_Panarctic_TopoUnits_GSWP3** -- Pan-Arctic scale simulation with
elevation-based topounits to capture subgrid scale topographic
variability. Topography based downscaling of atmospheric forcings turned
OFF.

**ELM_Panarctic_HillslopeHydro_GSWP3** -- Pan-Arctic scale simulation
with elevation-based topounits, downscaling of atmospheric forcings ON,
and IM1 - Hill Slope hydrology module ON.
  

ILAMB Configure Files
---------------------
Model variables to be benchmarked and reference datasets to confront
them with are defined using a simple configuration file.

Evaluations can be grouped in logical groups as desired. For example,
below defines **"Ecosystem and Carbon Cycle"** group.

.. code::

    [h1: Ecosystem and Carbon Cycle]
    bgcolor = "#86DE6A"

Variables to be part of the group can be then defined as:

.. code::

    [h2: Biomass]
    variable = "biomass"
    alternate_vars = "TOTVEGC","cVeg"
    weight         = 5
    skip_rmse      = True
    mass_weighting = True

* ``variable`` defines the model variable of interest. 
* ``alternate_vars`` allow definition of synonymous variable names, since the models and observations may use different variable name for the same quantity.
* ``weight`` is optional and is used by ILAMB to calculate aggregated overall scores. All variables/observations has equal weight by default.

Each variable can be benchmarked against one (or many) reference data,
 which can be defined as:

.. code::

    [ESACCI]
    source   = "DATA/NGEEA-Workshop/biomass/ESACCI/biomass.nc"

Where ``[ESACCI]`` is the name of the reference dataset, and ``source``
is the path to the reference data files relative from ``$ILAMB_ROOT``.

However, it is possible that your dataset has no direct analog in the
list of variables which models output and some manipulation is needed.
We have support for when your dataset corresponds to an algebraic
function of model variables. An example evapotranspiration can be
calculated as sum of canopy evaporation (``QVEGE``), canopy transpiration
(``QVEGT``) and ground evaporation (``QSOIL``) to compare against the
reference dataset. An equation to calculate the derived variable can be
defined using ``derived`` tag.

.. code::

    [h2: Evapotranspiration]
    variable = "evspsbl"
    alternate_vars = "et"
    derived = "QVEGE+QVEGT+QSOIL"

Point based data for benchmarking
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
While its common to benchmark models using gridded reference datasets,
ILAMB is also able to leverge point based datasets, such as those from
FLUX towers, for benchmarking. Following is an example of using
towers-based FLUXNET-CH4 datasets for benchmarking of methane (CH4)
fluxes from the ELM model.

.. code::

    [h2: CH4]
    variable = "FCH4"

    [FLUXNET-CH4]
    source = "DATA/NGEEA-Workshop/ch4/FluxnetANN/FCH4_F_ANN_monthly_wetland_tier1.nc"

No specific instructions are needed, and ILAMB is able to detect the
data being in point formats and conducts necessary metrics calculations
automatically.

Variable to variable relationships
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
While most often individual variables are compared against reference
dataset to benchmark the model, equally important is to ensure that
model (and observations) preserve functional relationships among
interacting processes and variables. ILAMB allows calculation of
pair-wise variable to variable relationships that can be defined via the
configuration file. Below is an example configuration to analyze
relationship between GPP vs Evapotranspiration, GPP vs Precipitation,
GPP vs Surface Downward SW Radiation, and GPP vs Surface
Air Temperature.

.. code::

    [FLUXCOM]
    source        = "DATA/NGEEA-Workshop/gpp/FLUXCOM/gpp.nc"
    weight        = 15
    table_unit    = "Pg yr-1"
    plot_unit     = "g m-2 d-1"
    space_mean    = False
    skip_iav      = True
    relationships = "Evapotranspiration/GLEAMv3.3a","Precipitation/GPCPv2.3","SurfaceDownwardSWRadiation/CERESed4.2","SurfaceAirTemperature/CRU4.02"


Running ILAMB
-------------
Now that we have the configuration file set up, you can run the study using the ilamb-run script. Executing the command:

.. code::

    ilamb-run --config hostdir/Field-to-Model/tools/ilamb/1_config_IM2.cfg \
    --model_setup hostdir/Field-to-Model/tools/ilamb/models_IM2.yaml \
    --build_dir ilamb_builds/build_IM2_20260115_1 \
    --study_limits 2000 2014 \
    --define_regions /mnt/inputdata/ILAMB/DATA/NGEEA-Workshop/regions/ILAMB_region_CAVM_NO_GREENLAND.nc

* ``--config`` defined the ILAMB configuration file to use 
* ``--model_setup`` defines model simulations to benchmark 
* ``--build_dir`` defines the path where the ILAMB outputs should be saved 
* ``--study_limits`` is optional and defines the temporal period of the \\
analysis. By default the analysis will conducted over the entire time \\
series contained within the model and reference data files.
* ``--define_regions`` is optional and defines the spatial region of \\
analysis. By default analysis is conducted on the entire spatial \\
extent contained within the model/obs data. 

``ILAMB_region_CAVM_NO_GREENLAND.nc`` is a custom defined region limited
to the extent of Arctic vegetation as defined by Circumpolar Arctic
Vegetation Map.

Visualize ILAMB Results
-----------------------

ILAMB results are prepared as a set of html files that can be viewed in
any browser. Relevant statistics and data are also stored in set of
NetCDF files, all in the directory defined by ``--build_dir``.

To view the results, start an http server with port forwarding within
your container:

.. code::

    python3 -m http.server 8000

Now open your browser and access ``http://localhost:8000/`` to view the
ILAMB results.


