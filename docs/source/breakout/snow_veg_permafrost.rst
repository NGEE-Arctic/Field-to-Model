Snow, Vegetation, and Permafrost Interactions Breakout Group
===========================================================

Welcome to the snow–vegetation–permafrost breakout! Please see the agenda
for our breakout session `<link to agenda>`_.

ELM Model: Snow, vegetation, and permafrost 
-------------------------------------------

Why do we care about snow, shrubs, and permafrost?
-------------------------------------------------

Snow, shrubs, and permafrost are tightly coupled controls on Arctic
ecosystem function, climate feedbacks, and infrastructure stability.
Snow regulates winter soil temperatures and spring hydrology by
insulating the ground and controlling the timing and magnitude of
meltwater, while shrubs modify snow accumulation and redistribution,
often deepening snowpacks and enhancing winter insulation. These
interactions can warm soils, accelerate permafrost thaw, and alter
active layer depth, with cascading effects on soil moisture, nutrient
availability, and vegetation composition.

Permafrost stores vast amounts of frozen organic carbon, and its thaw
can trigger long-term releases of CO₂ and CH₄, amplifying global climate
change. Shrub expansion further modifies surface albedo and energy
balance, reinforcing regional warming. Together, changes in snow,
shrubs, and permafrost represent a nonlinear, self-reinforcing system
that strongly influences Arctic climate feedbacks and ecosystem
trajectories.

Under future warming scenarios, some research has indicated that
precipitation is likely to increase, a phenomenon referred to as Arctic
Amplification (refs).

In the ELM model, just as we changed temperature in TEM to simulate
warming, we can also change summer and winter precipitation. In the
example below, we walk through shifting both summer and winter
precipitation to examine impacts on subsurface conditions.

ELM Background
--------------

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

Variables of Interest
---------------------

The following variables are examined to understand how changes in
temperature, precipitation, and vegetation affect snow, soil, and
permafrost processes.

+-------------------------------+--------------------------+-------------------------+
| Variable                      | TEM                      | ELM                     |
+===============================+==========================+=========================+
| Soil active layer depth (m)   | ALD, yearly              |                         |
+-------------------------------+--------------------------+-------------------------+
| Gross primary production      | GPP, monthly             |                         |
| (g m⁻² time⁻¹)                |                          |                         |
+-------------------------------+--------------------------+-------------------------+
| Snow pack thickness (m)       | SNOWTHICK, monthly       | SNOW_DEPTH, daily       |
+-------------------------------+--------------------------+-------------------------+
| Snow water equivalent         | SWE, monthly             | H2OSNO, daily           |
| (kg m⁻²)                      |                          |                         |
+-------------------------------+--------------------------+-------------------------+
| Soil layer thickness (m)      | LAYERDZ, monthly         |                         |
+-------------------------------+--------------------------+-------------------------+
| Temperature by layer (°C)     | TLAYER, monthly          | TSOIL_10                |
+-------------------------------+--------------------------+-------------------------+

Setting Up Model Simulations
----------------------------

Mean annual temperature is projected to increase by up to +8.5 °C at
NGEE-Arctic sites according to downscaled CMIP6 projections using a
13-member ensemble (`https://dap.climateinformation.org/dap/`_).

Seasonal precipitation changes are represented as percent differences
from a 1981–2010 climate normal. Temperature perturbations are applied
as absolute °C offsets.

**Scenario:** SSP245 (2041–2070 minus 1981–2010)

+----------------------+-----------+---------------------------+------+-------+-------+
| Site                 | Location  | Lat / Long                | T    | Pjul  | Pjan  |
+======================+===========+===========================+======+=======+=======+
| imnaviat_creek       | Alaska    | -149.34047, 68.56066      | 3.05 | 39.97 | 56.93 |
+----------------------+-----------+---------------------------+------+-------+-------+

The *imnaviat_creek* site is used as the example below, though any of the
available Arctic sites may be selected.

Running ELM Cases
-----------------

Baseline run (Arctic initialization):

.. code-block:: bash

   docker run -it --rm \
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

   docker run -it --rm \
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

   docker run -it --rm \
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

   docker run -it --rm \
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

Snow Processes in ELM
--------------------

ELM represents snow as a vertically resolved, multi-layer snowpack that
simulates accumulation, compaction, melt–refreeze, and energy exchange
with the atmosphere, vegetation canopy, and soil.

Precipitation phase is determined from near-surface air temperature
(`TBOT`) using a mixed rain–snow partitioning scheme:

* Snow if ``Tair ≤ T_snow``
* Rain if ``Tair ≥ T_rain``
* Mixed phase otherwise

Typical thresholds:

* ``T_snow ≈ 273.15 K`` (0 °C)
* ``T_rain ≈ 275.15 K`` (~2 °C)

Between these thresholds, precipitation is linearly partitioned between
rain and snow.

Shrubs
------

(Description to be completed.)

Permafrost
----------

(Description to be completed.)

Snow, Shrubs, and Permafrost in TEM
----------------------------------

(Text placeholder.)

