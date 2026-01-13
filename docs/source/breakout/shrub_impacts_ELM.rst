The impact of shrubs in ELM
==============================

When shrubs increase in Arctic ecosystems, a process often referred to as *shrubification*,
they alter ecosystem structure, energy balance, and biogeochemical cycling. 

Taller and denser shrubs trap more snow during winter, which insulates the ground and 
leads to warmer soil temperatures. In summer, shrubs reduce surface albedo by darkening 
the landscape, increasing the absorption of solar radiation. Together, these effects can 
accelerate permafrost thaw, change hydrology, shift plant community composition, and 
influence carbon cycling by modifying both plant productivity and soil decomposition rates.

The Energy Exascale Earth System Model Land Model (ELM) can be used to understand shrub 
impacts on snow and permafrost by explicitly representing vegetation functional types, 
snow–vegetation interactions, and soil thermal processes. 

In the NGEE Arctic project, we add a shrub bending parameter to better represent shrub
characteristics in Arctic ecosystems. A stiffer shrub (higher shrub bending parameters
of 1 or 0.75) results in more canopy area exposed above the snow, which generally
leads to a lower surface albedo (darker surface) and potentially less snow accumulation
on the ground. This can also lead to a earlier and faster snow melt.

A more flexible shrub (i.e., 0.25) leads to more of the shrub being buried, resulting
in a higher surface albedo (brighter snow surface) and different snowpack properties.

The amount of exposed or buried vegetation can also affect the surface energy budget.
Buried vegetation is insulated by the snowpack, while exposed branches interact with
the atmosphere, influencing heat and moisture fluxes.

ELM simulates how shrub height and density influence snow accumulation, snow thermal
insulation, and the timing of snowmelt, as well as how changes in albedo affect
surface energy fluxes. These processes are coupled to a vertically resolved soil
thermal model that tracks soil temperature and active-layer depth, enabling
assessment of how shrub expansion modifies permafrost stability. By running
scenario experiments with varying shrub cover, shrub bending, and climate forcing,
ELM allows researchers to project the impacts of shrubification on Arctic
snow dynamics and permafrost degradation.


Running ELM Cases
-----------------

Below are cases for shrubs at 100% in Imnaviat Creek basin examples.


Model run with 100% shrubs and bendresist example:

.. code-block:: bash

   docker run -it --pull always --rm \
     -v $(pwd):/home/modex_user \
     -v inputdata:/mnt/inputdata \
     -v output:/mnt/output \
     yuanfornl/ngee-arctic-modex25:models-main-latest \
     /home/modex_user/model_examples/ELM/run_ngeearctic_site.sh \
     --site_name=imnaviat_creek \
     --met_source=gswp3 \
     --use_arctic_init \
     --use_allshrubs \
     --mod_param_file=/mnt/inputdata/E3SM/lnd/clm2/paramdata/im3_params_bendresist050_sd.nc \
     --transient_yrs=25 \
     --case_prefix=Arctic_init_br50_allshrubs


Temperature scaled by +3 °C in the 100% shrubs and bendresist example:

.. code-block:: bash

   docker run -it --pull always --rm \
     -v $(pwd):/home/modex_user \
     -v inputdata:/mnt/inputdata \
     -v output:/mnt/output \
     yuanfornl/ngee-arctic-modex25:models-main-latest \
     /home/modex_user/model_examples/ELM/run_ngeearctic_site.sh \
     --site_name=imnaviat_creek \
     --met_source=gswp3 \
     --use_arctic_init \
     --add_temperature=3 \
     --startdate_add_temperature=18550101 \
     --use_allshrubs \
     --mod_param_file=/mnt/inputdata/E3SM/lnd/clm2/paramdata/im3_params_bendresist025_sd.nc \
     --transient_yrs=25 \
     --case_prefix=scale_temp3_br25_allshrubs


You can see below how this will look in your terminal.


Precipitation scaling (rain +40%, snow +60%) in the 100% shrubs and bendresist example:

.. code-block:: bash

   docker run -it --pull always --rm \
     -v $(pwd):/home/modex_user \
     -v inputdata:/mnt/inputdata \
     -v output:/mnt/output \
     yuanfornl/ngee-arctic-modex25:models-main-latest \
     /home/modex_user/model_examples/ELM/run_ngeearctic_site.sh \
     --site_name=imnaviat_creek \
     --met_source=gswp3 \
     --use_arctic_init \
     --scale_rain=1.4 \
     --startdate_scale_rain=18550101 \
     --scale_snow=1.6 \
     --startdate_scale_snow=18550101 \
     --use_allshrubs \
     --mod_param_file=/mnt/inputdata/E3SM/lnd/clm2/paramdata/im3_params_bendresist025_sd.nc \
     --transient_yrs=25 \
     --case_prefix=scale_rain40_snow60_br25_allshrubs

Combined temperature and precipitation scaling in the 100% shrubs and bendresist example:

.. code-block:: bash

   docker run -it --pull always --rm \
     -v $(pwd):/home/modex_user \
     -v inputdata:/mnt/inputdata \
     -v output:/mnt/output \
     yuanfornl/ngee-arctic-modex25:models-main-latest \
     /home/modex_user/model_examples/ELM/run_ngeearctic_site.sh \
     --site_name=imnaviat_creek \
     --met_source=gswp3 \
     --use_arctic_init \
     --add_temperature=3 \
     --startdate_add_temperature=18550101 \
     --scale_rain=1.4 \
     --startdate_scale_rain=18550101 \
     --scale_snow=1.6 \
     --startdate_scale_snow=18550101 \
     --use_allshrubs \
     --mod_param_file=/mnt/inputdata/E3SM/lnd/clm2/paramdata/im3_params_bendresist025_sd.nc \
     --transient_yrs=25 \
     --case_prefix=scale_rain40_snow60_temp3_br25_allshrubs


Below are cases for shrubs at 0% in Imnaviat Creek basin examples. This means that there is all grass
in these simulations. In these runs, there is no bendresist used since there are no shrubs.


Model run with 0% shrubs example:

.. code-block:: bash

   docker run -it --pull always --rm \
     -v $(pwd):/home/modex_user \
     -v inputdata:/mnt/inputdata \
     -v output:/mnt/output \
     yuanfornl/ngee-arctic-modex25:models-main-latest \
     /home/modex_user/model_examples/ELM/run_ngeearctic_site.sh \
     --site_name=imnaviat_creek \
     --met_source=gswp3 \
     --use_arctic_init \
     --use_noshrubs \
     --transient_yrs=25 \
     --case_prefix=Arctic_init_noshrubs

Temperature scaled by +3 °C in the 0% shrubs example:

.. code-block:: bash

   docker run -it --pull always --rm \
     -v $(pwd):/home/modex_user \
     -v inputdata:/mnt/inputdata \
     -v output:/mnt/output \
     yuanfornl/ngee-arctic-modex25:models-main-latest \
     /home/modex_user/model_examples/ELM/run_ngeearctic_site.sh \
     --site_name=imnaviat_creek \
     --met_source=gswp3 \
     --use_arctic_init \
     --add_temperature=3 \
     --startdate_add_temperature=18550101 \
     --use_noshrubs \
     --transient_yrs=25 \
     --case_prefix=scale_temp3_noshrubs


You can see below how this will look in your terminal.


Precipitation scaling (rain +40%, snow +60%) in the 0% shrubs example:

.. code-block:: bash

   docker run -it --pull always --rm \
     -v $(pwd):/home/modex_user \
     -v inputdata:/mnt/inputdata \
     -v output:/mnt/output \
     yuanfornl/ngee-arctic-modex25:models-main-latest \
     /home/modex_user/model_examples/ELM/run_ngeearctic_site.sh \
     --site_name=imnaviat_creek \
     --met_source=gswp3 \
     --use_arctic_init \
     --scale_rain=1.4 \
     --startdate_scale_rain=18550101 \
     --scale_snow=1.6 \
     --startdate_scale_snow=18550101 \
     --use_noshrubs \
     --transient_yrs=25 \
     --case_prefix=scale_rain40_snow60_noshrubs

Combined temperature and precipitation scaling in the 0% shrubs example:

.. code-block:: bash

   docker run -it --pull always --rm \
     -v $(pwd):/home/modex_user \
     -v inputdata:/mnt/inputdata \
     -v output:/mnt/output \
     yuanfornl/ngee-arctic-modex25:models-main-latest \
     /home/modex_user/model_examples/ELM/run_ngeearctic_site.sh \
     --site_name=imnaviat_creek \
     --met_source=gswp3 \
     --use_arctic_init \
     --add_temperature=3 \
     --startdate_add_temperature=18550101 \
     --scale_rain=1.4 \
     --startdate_scale_rain=18550101 \
     --scale_snow=1.6 \
     --startdate_scale_snow=18550101 \
     --use_noshrubs \
     --transient_yrs=25 \
     --case_prefix=scale_rain40_snow60_temp3_noshrubs


Looking at ELM Results
----------------------

Here is where we will review how to look at the ELM results in Jupyter Lab notebooks :ref:`breakout/analyzing_ELM_output_Jupyter_Notebooks:Analyzing ELM Output in Jupyter Lab`

