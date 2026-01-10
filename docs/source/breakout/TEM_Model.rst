TEM Model
==========

The input variables used to drive DVMDOSTEM include: drainage classification (upland or lowland), 
CMT classification, topography (slope, aspect, elevation), soil texture (percent sand, silt, and clay), 
climate (air temperature, precipitation, vapor pressure, incoming shortwave radiation), atmospheric CO2 
concentration, and fire occurrence (date and severity). All input datasets are spatially explicit, except 
the time series of atmospheric CO2. 

When running TEM, these inputs must be provided and can be used to simulate different scenarios to 
answer specific questions about how the model system responds to changes in climate and disturbance regimes.


In order to create different scenarios with TEM that allow us to investigate 
how changes in temperature and precipitation impact snow, vegetation, and permafrost, 
we can modify the input climate data files used by TEM through the combination of 
two different functions: 

* modify_air_temperature.py , which we used in the previous example and which allows us to 
  modify air temperature by a specified offset (in °C) for specific months (e.g., summer or winter months).
* modify_precipitation_percent.py , which allows us to modify precipitation by a specified percentage for specific months.

In addition to the changes to the input climate data files, we can also alter the community type that we look at, which
determines the plant functional types (PFTs) that are present in the model simulation. For the model site that we are looking at in this example (Imnavait creek), 
the three community types that we can select from are:

* Tussock tundra (contains the PFTs betula shrubs, other decidious shrubs, evergreen shrubs, sedges, forbs, lichen, feathermoss, sphagnum moss)
* Wet sedge tundra (contains the PFTs deciduous shrubs, sedges, grasses, forbs, lichen, feathermoss, sphagnum moss)
* Heath tundra (contains the PFTs deciduous shrubs, evergreen shrubs, forbs, lichen, grasses, moss)

Within each community type, the PFTs have different characteristics that influence how they interact with snow and permafrost processes, 
as well as capability for dynamic changes over time including competition for light and nutrients. For more information, 
see the TEM background for Snow, Vegetation, and Permafrost section at the end of this document.


Running TEM Cases
-----------------

General model setup
**********************

If you have not already done so, follow the following instructions to set up your environment for running TEM:

In the shell, start a model container:

.. code:: shell

   docker run -it --rm \
      --name models-container \
      -v $(pwd):/home/modex_user \
      -v inputdata:/mnt/inputdata \ 
      -v output:/mnt/output \
      yuanfornl/ngee-arctic-modex26:models-main-latest /bin/bash

Look at the available input data and check that the Imnavait data is available: 

.. code:: shell

   modex_user@40bc0d780707:~$ ls /mnt/inputdata/TEM/
   cru-ts40_ar5_rcp85_ncar-ccsm4_toolik_field_station_10x10
   modex26-AK-BEO
   modex26-AK-UTQ
   modex26-AK-TFS-IMC
   modex26-AK-TFS




Set up the run folders
**************************


With the available functions, you can create different TEM scenarios by modifying the input climate data files. 
Below are the instructions to set up the identical scenarios to the ELM examples shown previously.  

* Baseline run 
* Temperature scaled by +3 °C
* Precipitation scaling (rain +40%, snow +60%)
* Combined temperature and precipitation scaling

You will need to create a separate run folder for each scenario you want to run:

.. code:: shell

   mkdir -p /mnt/output/tem/tem_ee2_breakout
   cd /mnt/output/tem/tem_ee2_breakout

   pyddt-swd --input-data \
      --copy-inputs \
      --input-data-path /mnt/inputdata/TEM/modex26-AK-UTQ \
      baseline_tussock

   pyddt-swd --input-data \
      --copy-inputs \
      --input-data-path /mnt/inputdata/TEM/modex26-AK-UTQ \
      warming_imnavait_tussock

    pyddt-swd --input-data \
      --copy-inputs \
      --input-data-path /mnt/inputdata/TEM/modex26-AK-UTQ \
      precip_imnavait_tussock
    
    pyddt-swd --input-data \
      --copy-inputs \
      --input-data-path /mnt/inputdata/TEM/modex26-AK-UTQ \
      warming_and_precip_imnavait_tussock


You can run each of the scenarios for the three different community types available for the 
Imnavait site described above, by replacing "tussock" in the runfolder names with "wetsedge" or "heath". 
We run through the examples using tussock tundra but will note where to change for the other community types.

Running the model
**********************
Running the different runfolders involves several steps, many of which are identical across the scenarios.
However, some steps to adjusting the input climate data files differ. Below are the instructions for each scenario.

Baseline run:
^^^^^^^^^^^^^^^^^^^^

#. Change into the run folder: :code:`cd /mnt/output/tem/tem_ee2_breakout/baseline_tussock`

#. Adjust the runmask: :code:`pyddt-runmask --reset --yx 0 0 run-mask.nc`

#. Setup the output specification file 

   .. code::

      pyddt-outspec config/output_spec.csv --on GPP m p
      pyddt-outspec config/output_spec.csv --on LAYERDZ m l
      pyddt-outspec config/output_spec.csv --on TLAYER m l
      pyddt-outspec config/output_spec.csv --on SWE m 
      pyddt-outspec config/output_spec.csv --on SNOWTHICK m 
      pyddt-outspec config/output_spec.csv --on ALD y

#. Start the run. ATTENTION! :code:`--force-cmt 5` is for tussock tundra. For wet sedge tundra, use :code:`--force-cmt 6`, and for heath tundra, use :code:`--force-cmt 7`.
   
   .. code:: 

        dvmdostem -f config/config.js --force-cmt 5 -p 100 -e 1000 -s 250 -t 123 -n 0 -l monitor 


    
    

Temperature scaled by +3 °C:
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

#. Change into the run folder: :code:`cd /mnt/output/tem/tem_ee2_breakout/warming_imnavait_tussock`

#. Adjust the input climate data:

   .. code:: shell

      python home/modex_user/model_examples/TEM/modify_air_temperature.py \
      --input-file input/historic-climate.nc \
      --months 6 7 8 9 \
      --years 2019 \
      --deviation 3
#. Replace the old input climate data file with the modified one:

   .. code:: shell

      mv input/modified_historic-climate.nc input/historic-climate.nc   

#. Adjust the runmask: :code:`pyddt-runmask --reset --yx 0 0 run-mask.nc`

#. Setup the output specification file 

   .. code::

      pyddt-outspec config/output_spec.csv --on GPP m p
      pyddt-outspec config/output_spec.csv --on LAYERDZ m l
      pyddt-outspec config/output_spec.csv --on TLAYER m l
      pyddt-outspec config/output_spec.csv --on SWE m 
      pyddt-outspec config/output_spec.csv --on SNOWTHICK m 
      pyddt-outspec config/output_spec.csv --on ALD y

#. Start the run. 
   
   .. code:: 

        dvmdostem -f config/config.js --force-cmt 5 -p 100 -e 1000 -s 250 -t 123 -n 0 -l monitor 




Precipitation scaling (rain +40%, snow +60%):
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

#. Change into the run folder: :code:`cd /mnt/output/tem/tem_ee2_breakout/precip_imnavait_tussock`

#. Adjust the input climate data with the :code:`modify_precipitation_percent.py` script. Since in TEM, precipitation falls as rain or snow depending on the average monthly air temperature, we will modify rain and snow separately assuming that rain occurs in the summer months (June, July, August, September) and snow in the winter months (October, November, December, January, February, March, April, May). 

   .. code:: shell

      python home/modex_user/model_examples/TEM/modify_precipitation.py \
      --input-file input/historic-climate.nc \
      --months 6 7 8 9 \
      --years 2018 2019 \
      --deviation 0.4

      python home/modex_user/model_examples/TEM/modify_precipitation.py \
      --input-file input/historic-climate.nc \
      --months 10 11 12 1 2 3 4 5 \
      --years 2018 2019 \
      --deviation 0.6


#. Replace the old input climate data file with the modified one:

   .. code:: shell

      mv input/modified_historic-climate.nc input/historic-climate.nc  

#. Adjust the runmask: :code:`pyddt-runmask --reset --yx 0 0 run-mask.nc`

#. Setup the output specification file 

   .. code::

      pyddt-outspec config/output_spec.csv --on GPP m p
      pyddt-outspec config/output_spec.csv --on LAYERDZ m l
      pyddt-outspec config/output_spec.csv --on TLAYER m l
      pyddt-outspec config/output_spec.csv --on SWE m 
      pyddt-outspec config/output_spec.csv --on SNOWTHICK m 
      pyddt-outspec config/output_spec.csv --on ALD y

#. Start the run. 
   
   .. code:: 

        dvmdostem -f config/config.js --force-cmt 5 -p 100 -e 1000 -s 250 -t 123 -n 0 -l monitor 



Combined temperature and precipitation scaling:
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

#. Change into the run folder: :code:`cd /mnt/output/tem/tem_ee2_breakout/warming_and_precip_imnavait_tussock`

#. Adjust the input climate data

   .. code:: shell

    python home/modex_user/model_examples/TEM/modify_precipitation.py \
      --input-file input/historic-climate.nc \
      --months 6 7 8 9 \
      --years 2018 2019 \
      --deviation 0.4

    python home/modex_user/model_examples/TEM/modify_precipitation.py \
      --input-file input/historic-climate.nc \
      --months 10 11 12 1 2 3 4 5 \
      --years 2018 2019 \
      --deviation 0.6

    python home/modex_user/model_examples/TEM/modify_air_temperature.py \
      --input-file input/historic-climate.nc \
      --months 6 7 8 9 \
      --years 2019 \
      --deviation 3


#. Replace the old input climate data file with the modified one:

   .. code:: shell

      mv input/modified_historic-climate.nc input/historic-climate.nc  

#. Adjust the runmask: :code:`pyddt-runmask --reset --yx 0 0 run-mask.nc`

#. Setup the output specification file 

   .. code::

      pyddt-outspec config/output_spec.csv --on GPP m p
      pyddt-outspec config/output_spec.csv --on LAYERDZ m l
      pyddt-outspec config/output_spec.csv --on TLAYER m l
      pyddt-outspec config/output_spec.csv --on SWE m 
      pyddt-outspec config/output_spec.csv --on SNOWTHICK m 
      pyddt-outspec config/output_spec.csv --on ALD y

#. Start the run. 
   
   .. code:: 

        dvmdostem -f config/config.js --force-cmt 5 -p 100 -e 1000 -s 250 -t 123 -n 0 -l monitor 




Looking at TEM Results
----------------------

For the analysis portion of this experiment, we will use a Jupyter Notebook to 
visualize and compare the outputs from the control and warming runs. This allows
us to interactively explore the data and create plots to see how the warming
treatment affected the soil temperatures.

To start this notebook, use another terminal to launch a Jupyter Notebook server
in a new container:

.. code::

   docker run -it --rm \
      --name vis-container \
      -p 8888:8888 \
      -v $(pwd):/home/jovyan \
      -v inputdata:/mnt/inputdata \ 
      -v output:/mnt/output \
      yuanfornl/ngee-arctic-modex26:vis-main-latest   

You should see output like this:

.. code::

   [I 2025-12-12 21:31:22.299 ServerApp] jupyter_lsp | extension was successfully linked.
   [I 2025-12-12 21:31:22.305 ServerApp] jupyter_server_terminals | extension was successfully linked.
   [I 2025-12-12 21:31:22.311 ServerApp] jupyterlab | extension was successfully linked.
   [I 2025-12-12 21:31:22.317 ServerApp] notebook | extension was successfully linked.
   ...
       To access the server, open this file in a browser:
        file:///home/jovyan/.local/share/jupyter/runtime/jpserver-360-open.html
    Or copy and paste one of these URLs:
        http://2aecc7b15434:8888/tree?token=e66b3be47f2b3d7721adeb88992b8b1818901c5d76281678
        http://127.0.0.1:8888/tree?token=e66b3be47f2b3d7721adeb88992b8b1818901c5d76281678

Once the server is running, you should see a URL printed out in the terminal
that you can open in your web browser on your host computer to access the
Jupyter interface. Navigate to the :code:`vis_notebooks/TEM/` directory and
open the :code:`precipitation_plotting.ipynb` notebook.

Advanced TEM Processing and Information
---------------------------------------


TEM background for Snow, Vegetation, and Permafrost
----------------------------------------------------
Each DVMDOSTEM grid cell can be assigned one “community type” (CMT). A community type is essentially a parameterization
that specifies many properties for vegetation, and soil.

Each vegetation CMT (e.g. “wet-sedge tundra”, “white spruce forest”, etc.), is modeled with up to ten PFTs
(e.g., “deciduous shrubs”, “sedges”, “mosses”), each of which may have up to three compartments: leaf, stem, 
and root. Vegetation carbon and nitrogen fluxes are calculated at each time step based on environmental factors and soil properties. 
Assimilation of atmospheric CO2 by the vegetation is estimated by computing gross primary productivity (GPP) for each 
PFT. GPP is a function of foliage development (seasonal and successional patterns), air and soil temperature, 
water and nutrient availability, photosynthetically active radiation, and maximum assimilation rate (a calibrated 
parameter) (McGuire et al., 1992; Euskirchen et al., 2009). Changes in vegetation carbon stocks are calculated using GPP, 
autotrophic respiration (Ra), and litter-fall (transfer from vegetation to soil). Vegetation nitrogen stocks are calculated using 
plant nitrogen uptake and litter-fall. Vegetation carbon and nitrogen soil stocks may also be modified as a result 
of wildfire burn.


The soil column is structured as a sequence of layers organized by soil horizons (i.e. fibric, humic, mineral, 
and parent material). The number and physical properties of layers may change throughout the simulation based 
on vegetation, thermal, hydrologic, and seasonal properties that are calculated at each time step 
(Zhuang et al., 2003; Euskirchen et al., 2014; Yi et al., 2009; McGuire et al., 2018). The model uses 
the two-directional Stefan algorithm to predict freezing/thawing fronts and the Richards equation to predict 
soil moisture dynamics in the unfrozen layers (Yi et al., 2009; Yi et al., 2010; Zhuang et al., 2003). 
Snow is also represented with a dynamic stack of layers. The physical properties of the snowpack (density, 
thickness, and temperature) are calculated from snowfall, sublimation and snowmelt. Snow cover influences 
soil-thermal and hydrological seasonal dynamics. Changes in soil carbon stocks are a result of litter-fall from the 
vegetation and decomposition of soil carbon stocks by microbes (heterotrophic respiration or Rh). Changes in soil organic 
and available nitrogen stocks are a result of litter-fall, net mineralization of organic nitrogen, and plant nitrogen uptake. Soil organic 
layers and soil carbon and nitrogen stocks may also be modified due to wildfire.


A.D. McGuire, J. M. Melillo, L. A. Joyce, D. W. Kicklighter, A. L. Grace, B. Moore, and C. J. Vorosmarty. Interactions between carbon and nitrogen dynamics in estimating net primary productivity for potential vegetation in North America. Global Biogeochemical Cycles, 6:101–124, 1992. doi:10.1029/92GB00219.

E.S. Euskirchen, A. D. Mcguire, F. S. Chapin, S. Yi, and C. C. Thompson. Changes in vegetation in northern Alaska under scenarios of climate change, 2003-2100: implications for climate feedbacks. Ecological Applications, 19:1022–1043, 7 2009. doi:10.1890/08-0806.1.

Q.Zhuang, A. D. McGuire, K. P. O'Neill, J. W. Harden, V. E. Romanovsky, and J. Yarie. Modeling soil thermal and carbon dynamics of a fire chronosequence in interior Alaska. Journal of Geophysical Research: Atmospheres, 1 2003. doi:10.1029/2001JD001244.

E.S. Euskirchen, C. W. Edgar, M. R. Turetsky, M. P. Waldrop, and J. W. Harden. Differential response of carbon fluxes to climate in three peatland ecosystems that vary in the presence and stability of permafrost. Journal of Geophysical Research: Biogeosciences, 119:1576–1595, 8 2014. doi:10.1002/2014JG002683.

Shuhua Yi, A. David McGuire, Jennifer Harden, Eric Kasischke, Kristen Manies, Larry Hinzman, Anna Liljedahl, Jim Randerson, Heping Liu, Vladimir Romanovsky, Sergei Marchenko, and Yongwon Kim. Interactions between soil thermal and hydrological dynamics in the response of Alaska ecosystems to fire disturbance. Journal of Geophysical Research: Biogeosciences, 6 2009. doi:10.1029/2008JG000841.

A.D. McGuire, Hélène Genet, Zhou Lyu, Neal Pastick, Sarah Stackpoole, Richard Birdsey, David D'Amore, Yujie He, T. Scott Rupp, Robert Striegl, Bruce K. Wylie, Xiaoping Zhou, Qianlai Zhuang, and Zhiliang Zhu. Assessing historical and projected carbon balance of Alaska: a synthesis of results and policy/management implications. Ecological Applications, 28:1396–1412, 9 2018. doi:10.1002/EAP.1768.

Shuhua Yi, A. David McGuire, Eric Kasischke, Jennifer Harden, Kristen Manies, Michelle MacK, and Merritt Turetsky. A dynamic organic soil biogeochemical model for simulating the effects of wildfire on soil environmental conditions and carbon dynamics of black spruce forests. Journal of Geophysical Research: Biogeosciences, 12 2010. doi:10.1029/2010JG001302.
