TEM Warming Experiment (and TEM Introduction)
=================================================================

What are we trying to model?
-------------------------------------------------------------

NGEE Arctic has worked on numerous experiments and field equipment over the last decade+, one of which being the zero-power warming 
chambers (see Lewin et at. (2017) https://bg.copernicus.org/articles/14/4071/2017/bg-14-4071-2017.pdf) 
The chambers passively warm the mean daily temperature inside the chamber by 2.6◦C above ambient temperatures during the summer months. 
Modeling such field experiments allows us to evaluate how well the model is able to capture the ecosystem responses to warming, 
and thus how adequate the model is for predicting future ecosystem changes.

At Utqiagvik, the chambers were deployed over a single season in multiple locations from 2017-2021 from mid-June through to mid-September (Ely et al. 2024). 
In this example, we model the 2019 summer warming experiment and compare the modeled and measured soil temperatures at 10cm depth 
for the warmed and control site. The 2019 experiment focused on *Eriophorum angustifolium*, a common sedge species in Arctic tundra which 
in the model DVM-DOS-TEM is represented by the sedge plant functional type (PFT) and grows for example in the wet sedge tundra 
community type (CMT). We model the warming experiment at a single pixel representing the wet sedge tundra CMT at Utqiagvik and compare the 
soil temperature at 10cm depth between the control and warmed runs to the observed soil temperatures at the site (Ely et al. 2024).


Lewin, K. F., McMahon, A. M., Ely, K. S., Serbin, S. P., & Rogers, A. (2017). A zero-power warming chamber for investigating plant responses to rising temperature. Biogeosciences, 14(18), 4071-4083.

Ely, Kim, Anderson, Jeremiah, Serbin, Shawn, & Rogers, Alistair (2024). Vegetation Warming Experiment: Thaw depth and dGPS locations, Utqiagvik, Alaska, 2019. https://doi.org/10.5440/1887568


.. note:: TODO

   Add some links to the text above into the relevant sections of the TEM 
   User Guide. For example linking to the description of Community Types, PFTs, 
   etc.



Setup
-----

.. warning:: 

   Waiting on Tobey to finalize input data prep. For now, just use the 
   demo data that is shipped with the TEM install...in the modex model container
   you can find it at :code:`/home/modex_user/install_dvmdostem/demo-data`.

.. note:: Prerequisites

   Assumes you have done the following container setup after downloading
   the container image from the cloud:

   .. code:: shell

      docker volume create inputdata
      docker volume create output
      docker run -it --rm \
         -p 9000:9000 \ 
         -v $(pwd)/model_examples:/home/modex_user/model_examples \ 
         -v inputdata:/home/modex_user/inputdata \
         -v output:/home/modex_user/output \
         model-container:latest

      # Alternate ways, mount might work better if you plan to edit files on the
      # host side and have them show up in the container right away....
      # -v $(pwd)/model_examples:/home/modex_user/model_examples \
      # --mount type=bind,src=$(pwd)/model_examples,dst=/home/modex_user/model_examples \


   Which should give you a shell prompt inside the container with two
   volumes mounted for input data and workshop runs.

   .. code:: shell

      modex_user@5cf5a55dff62:~$


Inputs
************

Copy the input data that you'd like to use to the input data directory:

.. tip:: 
   
   Once we have inputs prepared for the workshop you can skip this step and
   just browse the input data folder to find data you want to use.

.. code:: shell

   cp -r /opt/dvmdostem/demo-data/* /mnt/inputdata/

Next, to make the experiment and analysis easier, we will glue together the 
historic and projected (scenario) climate data into a single continuous dataset.
This will allow us to run the model in a single stage from 1901-2100 rather than
having to do a transient run followed by a scenario run. Use the helper script
in the :code:`model_examples/TEM` directory to do this:

.. collapse:: More info on TEM run stages...
   :class: workshop-collapse
   :name: tem-run-stages

   TEM typically runs in multiple stages to cover the full historical and future
   periods. The typical stages are:

     * Equilibrium (EQ): Run model to reach a steady state using pre-industrial climate data.
     * Spinup (SP): Further spin-up using historical climate data.
     * Transient (TR): Run model with historical climate data from 1901 to present.
     * Scenario (SC): Run model with future climate projections from present to 2100.
   
   By gluing the transient and scenario datasets together, we can simplify the
   run process into a single stage covering 1901-2100.

.. code:: shell

   ./model_examples/TEM/glue_transient_scenario.py /mnt/inputdata/cru-ts40_ar5_rcp85_ncar-ccsm4_toolik_field_station_10x10

Now if you look in the new directory, you should see a new file called
:code:`stock-historic-climate.nc` which is the original file that came with the
dataset. The file :code:`historic-climate.nc` is now the glued together version
that covers 1901-2100. The same applies to the CO2 files.

.. collapse:: Examining a NetCDF file.
   :class: workshop-collapse
   :name: ncdump-glued

   You can use the :code:`ncdump` utility to inspect the contents of the new
   netCDF file. For example:

   .. code:: shell

      ncdump -h /mnt/inputdata/cru-ts40_ar5_rcp85_ncar-ccsm4_toolik_field_station_10x10/historic-climate.nc

   This will show you the dimensions and variables in the file, including the
   time dimension which should now span from 1901 to 2100.

Creating the Warming Treatment Dataset
**********************************************

Now we are going to make copy of this dataset to create our "treatment" or
"warming" dataset. We will then modify this copy to increase the air temperatures
by 2.6 degrees Celsius during the summer months (June, July, August, September)
for the year 2019.

.. code:: shell

   cp -r /mnt/inputdata/cru-ts40_ar5_rcp85_ncar-ccsm4_toolik_field_station_10x10 \
     /mnt/inputdata/cru-ts40_ar5_rcp85_ncar-ccsm4_toolik_field_station_10x10_warming_2.6C_JJAS_2019

Now we will run the helper script to modify the air temperatures in the new
dataset:

.. code:: shell

   ./model_examples/TEM/modify_air_temperature.py \
   --input-file /mnt/inputdata/cru-ts40_ar5_rcp85_ncar-ccsm4_toolik_field_station_10x10_warming_2.6C_JJAS_2019/historic-climate.nc \
   --months 6 7 8 9 \
   --years 2019 \
   --deviation 2.6

   
.. collapse:: Details about the modification script
   :class: workshop-collapse
   :name: modify-script-details

   The modification script uses :code:`xarray` under the hood to manipulate
   the netCDF data. It creates a boolean mask for the time dimension based
   on the specified years and months, and then applies the temperature deviation
   only to those selected time points.

   The modification script can take additional arguments to modify multiple
   years and different months as needed. See the help message for details.

As you will see in the statements that are printed out from this script it will 
actually create an new file alongside the existing one. Here we throw out the 
original file and rename the modified version to clean things up.

.. code:: shell

   mv /mnt/inputdata/cru-ts40_ar5_rcp85_ncar-ccsm4_toolik_field_station_10x10_warming_2.6C_JJAS_2019/modified_historic-climate.nc \
      /mnt/inputdata/cru-ts40_ar5_rcp85_ncar-ccsm4_toolik_field_station_10x10_warming_2.6C_JJAS_2019/historic-climate.nc

Now we have two datasets:

* the control dataset: :code:`/mnt/inputdata/cru-ts40_ar5_rcp85_ncar-ccsm4_toolik_field_station_10x10`
* the warming treatment dataset: :code:`/mnt/inputdata/cru-ts40_ar5_rcp85_ncar-ccsm4_toolik_field_station_10x10_warming_2.6C_JJAS_2019`

.. note:: TODO

   would be nice to show some viz of this...do we need to use the other container??

Setting up the run folders
**********************************************

Now that we have the datasets set up, we can create two run folders using the 
:code:`pyddt-swd` utility helper tool. For this we will work in the 
:code:`/mnt/output/tem_ee1_warming` directory.

.. code:: shell

   mkdir -p /mnt/output/tem/tem_ee1_warming
   cd /mnt/output/tem/tem_ee1_warming

   pyddt-swd --input-data \
      /mnt/inputdata/cru-ts40_ar5_rcp85_ncar-ccsm4_toolik_field_station_10x10 \
      control

   pyddt-swd --input-data \
      /mnt/inputdata/cru-ts40_ar5_rcp85_ncar-ccsm4_toolik_field_station_10x10_warming_2.6C_JJAS_2019 \
      treatment

You should now have two run folders set up for the control and treatment runs:

.. code:: shell

   $ pwd
   /mnt/output/tem/tem_ee1_warming/control

   $ ls -l
   drwxr-xr-x 6 modex_user modex_user 4096 Oct 20 22:17 control
   drwxr-xr-x 6 modex_user modex_user 4096 Oct 20 22:17 warming_2.6C_JJAS_2019   

Now we can start a run in each folder.

Running the model
**********************************************

Take care of the last setup steps. **DO THIS FOR EACH RUN**:

#. Change into the run folder, e.g. :code:`cd /mnt/output/tem/tem_ee1_warming/control`.

#. Adjust the run mask so that only a single pixel is enabled.

   .. code::

      pyddt-runmask --reset --yx 0 0 run-mask.nc

#. Setup the output specification file. This is a `:code:`csv` file that tells 
   the model which variables to output and at what resolution. You can edit it 
   by hand but it's easier to use the :code:`pyddt-outspec` utility to add the
   variables you want. 

   .. code::

      pyddt-outspec config/output_spec.csv --on GPP m p
      pyddt-outspec config/output_spec.csv --on LAYERDZ m l
      pyddt-outspec config/output_spec.csv --on TLAYER m l

      # Print it out to see what vars we have at what resolution...
      pyddt-outspec config/output_spec.csv -s
               Name                Units       Yearly      Monthly        Daily          PFT Compartments       Layers    Data Type     Description
                GPP            g/m2/time            y                   invalid                                invalid       double     GPP
            LAYERDZ                    m            y            m      invalid      invalid      invalid            l       double     Thickness of layer
             TLAYER             degree_C            y            m      invalid      invalid      invalid            l       double     Temperature by layer


#. Optional - config file settings.

   Expand this section to see a discussion of adjusting the config file.

   .. collapse:: Example of adjusting config file settings
      :class: workshop-collapse
      :name: alt-file-shuffle

      The config file is a :code:`json` file that contains a bunch of settings
      for the run. You may want to look through the file to see what things
      are available for changing. You can edit the file directly with a text
      editor, or you can use a small script to do it programmatically or in 
      an interactive Python session, as in the following example.

      .. code:: python

         cd /mnt/output/tem/tem_ee1_warming/control/

         ipython
         Python 3.11.14 | packaged by conda-forge | (main, Oct 13 2025, 14:09:32) [GCC 14.3.0]
         Type 'copyright', 'credits' or 'license' for more information
         IPython 9.6.0 -- An enhanced Interactive Python. Type '?' for help.
         Tip: Put a ';' at the end of a line to suppress the printing of output.

         In [1]: import json

         In [2]: with open('config/config.js') as f:
            ...:   jd = json.load(f)

         In [3]: jd['IO']['hist_climate_file'] = "/mnt/inputdata/cru-ts40_ar5_rcp85_ncar-ccsm4_toolik_field_station_10x10/transient-scenario-climate.nc"
         In [4]: jd['IO']['co2_file'] = "/mnt/inputdata/cru-ts40_ar5_rcp85_ncar-ccsm4_toolik_field_station_10x10/transient-scenario-co2.nc"

         In [5]: with open('config/config.js', 'w') as f:
            ...:    json.dump(jd, f, indent=4)


#. Now we can start the run.

   .. code:: shell

      dvmdostem -f config/config.js -p 15 -e 10 -s 10 -t 150 -n 0 -l monitor


Analysis
----------------------------

.. note:: TODO, write this...

   What kinds of plots and analyses do we want to provide? What variables are we
   most interested in? How do we want to visualize the differences between the
   control and warming runs?

   Some ideas:
   
   * Time series plots of key variables (e.g. GPP, NEE, soil carbon) for control vs warming
   * Seasonal cycle plots
   * Difference maps if multi-pixel
   * Statistical summaries (means, variances, trends)
   * Comparison to observational data if available

   We can use Jupyter notebooks for interactive analysis and visualization.   