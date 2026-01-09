ELM Model
==========

ELM requires a set of forcing time series to run. In most E3SM
simulations, ELM receives forcing variables such as temperature,
humidity, precipitation rate, and nutrient deposition from the
atmospheric model (EAM).

When running ELM in standalone mode, these time series must be provided
by the user. OLMT provides several options that automate specification
and modification of ELM input data.

Here, we demonstrate a single-pixel OLMT ELM simulation across multiple
sites using OLMT options to alter temperature and precipitation (summer
rain and winter snow) separately and in combination. Outputs are
compared against a baseline case to evaluate how scaled meteorological
inputs affect ELM behavior.


Running ELM Cases
-----------------

Baseline run (Arctic initialization):

.. code-block:: bash

   docker run -it --pull always --rm \
     -v $(pwd):/home/modex_user \
     -v inputdata:/mnt/inputdata \
     -v output:/mnt/output \
     yuanfornl/ngee-arctic-modex25:models-main-latest \
     /home/modex_user/model_examples/ELM/run_ngeearctic_site.sh \
     --site_name=imnaviat_creek \
     --use_arctic_init \
     --transient_yrs=25 \
     --case_prefix=Arctic_init

Temperature scaled by +3 °C:

.. code-block:: bash

   docker run -it --pull always --rm \
     -v $(pwd):/home/modex_user \
     -v inputdata:/mnt/inputdata \
     -v output:/mnt/output \
     yuanfornl/ngee-arctic-modex25:models-main-latest \
     /home/modex_user/model_examples/ELM/run_ngeearctic_site.sh \
     --site_name=imnaviat_creek \
     --use_arctic_init \
     --add_temperature=3 \
     --startdate_add_temperature=18550101 \
     --transient_yrs=25 \
     --case_prefix=scale_temp3

Precipitation scaling (rain +40%, snow +60%):

.. code-block:: bash

   docker run -it --pull always --rm \
     -v $(pwd):/home/modex_user \
     -v inputdata:/mnt/inputdata \
     -v output:/mnt/output \
     yuanfornl/ngee-arctic-modex25:models-main-latest \
     /home/modex_user/model_examples/ELM/run_ngeearctic_site.sh \
     --site_name=imnaviat_creek \
     --use_arctic_init \
     --scale_rain=1.4 \
     --startdate_scale_rain=18550101 \
     --scale_snow=1.6 \
     --startdate_scale_snow=18550101 \
     --transient_yrs=25 \
     --case_prefix=scale_rain40_snow60

Combined temperature and precipitation scaling:

.. code-block:: bash

   docker run -it --pull always --rm \
     -v $(pwd):/home/modex_user \
     -v inputdata:/mnt/inputdata \
     -v output:/mnt/output \
     yuanfornl/ngee-arctic-modex25:models-main-latest \
     /home/modex_user/model_examples/ELM/run_ngeearctic_site.sh \
     --site_name=imnaviat_creek \
     --use_arctic_init \
     --scale_rain=1.4 \
     --scale_snow=1.6 \
     --add_temperature=3 \
     --startdate_add_temperature=18550101 \
     --transient_yrs=25 \
     --case_prefix=scale_rain40_snow60_temp3


Looking at ELM Results
----------------------

Here is where we will review how to look at the ELM results in Jupyter Lab notebooks :ref:`Analyzing ELM Output in Jupyter Lab`.

Advanced ELM Processing and Information
---------------------------------------

* ELM Background Information :ref:`ELM Background`.

* The impact of shrubs in ELM :ref:`The impact of shrubs in ELM`.
* Understanding and modifying surface files in ELM :ref:`Understanding and modifying surface files in ELM`.