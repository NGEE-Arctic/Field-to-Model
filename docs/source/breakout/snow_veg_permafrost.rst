Snow, Vegetation, and Permafrost Interactions Breakout Group
================================================================

Welcome to the snow–vegetation–permafrost breakout! Please see the agenda
for our breakout session :ref:`Snow, Vegetation, Permafrost (SVP) 
Breakout Agenda`.

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
Amplification (e.g., Bintanja et al. 2018, England et al. 2021,
Rantanen et al. 2022).

In the ELM model, just as we changed temperature in TEM to simulate
warming, we can also change summer and winter precipitation. In the
example below, we walk through shifting both summer and winter
precipitation to examine impacts on subsurface conditions.

Variables of Interest in TEM and ELM
------------------------------------

The following variables are examined to understand how changes in
temperature, precipitation, and vegetation affect snow, soil, and
permafrost processes.

.. list-table:: Model variables and temporal resolution
   :header-rows: 1
   :widths: 40 30 30

   * - Variable
     - TEM
     - ELM
   * - Soil active layer depth (m)
     - ALD, yearly
     - ALT, daily
   * - Gross primary production (g m⁻² time⁻¹)
     - GPP, monthly
     - GPP, daily
   * - Snow pack thickness (m)
     - SNOWTHICK, monthly
     - SNOW_DEPTH, daily
   * - Snow water equivalent (kg m⁻²)
     - SWE, monthly
     - H2OSNO, daily
   * - Soil layer thickness (m)
     - LAYERDZ, monthly
     - levgrnd, static
   * - Temperature by layer (°C)
     - TLAYER, monthly
     - TSOI_10CM, daily (K)

ELM Introduction
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

Setting Up ELM Model Simulations
----------------------------

Mean annual temperature is projected to increase by up to +8.5 °C at
NGEE-Arctic sites according to downscaled CMIP6 projections using a
13-member ensemble (`<https://dap.climateinformation.org/dap/>`_).

Seasonal precipitation changes are represented as percent differences
from a 1981–2010 climate normal. Temperature perturbations are applied
as absolute °C offsets.

**Emissions scenario:** Median annual or seasonal (SSP245, 2041–2070,
difference from 1981–2010)

+---------------------+----------+-------------------+------+-------+-------+
| Site Abbreviation   | Location | Lat / Long        | T    | Pjul  | Pjan  |
+=====================+==========+===================+======+=======+=======+
| beo                 | Alaska   | 71.30 / -156.60   | 4.67 | 31.74 | 44.97 |
+---------------------+----------+-------------------+------+-------+-------+
| council             | Alaska   | 64.85 / -163.71   | 3.25 | 21.59 | 13.08 |
+---------------------+----------+-------------------+------+-------+-------+
| kougarok            | Alaska   | 65.16 / -164.83   | 3.43 | 20.68 | 15.41 |
+---------------------+----------+-------------------+------+-------+-------+
| teller              | Alaska   | 64.74 / -165.95   | 3.56 | 11.99 | 17.92 |
+---------------------+----------+-------------------+------+-------+-------+
| toolik_lake         | Alaska   | 68.63 / -149.59   | 3.09 | 36.97 | 45.97 |
+---------------------+----------+-------------------+------+-------+-------+
| imnaviat_creek      | Alaska   | 68.60 / -149.30   | 3.05 | 39.97 | 56.93 |
+---------------------+----------+-------------------+------+-------+-------+
| upper_kuparuk       | Alaska   | 68.61 / -149.31   | 3.05 | 39.97 | 56.93 |
+---------------------+----------+-------------------+------+-------+-------+
| trail_valley_creek  | Canada   | 68.74 / -133.50   | 3.82 | 21.76 | 14.83 |
+---------------------+----------+-------------------+------+-------+-------+
| abisko              | Sweden   | 68.35 / 18.82     | 2.06 | 21.55 |  6.74 |
+---------------------+----------+-------------------+------+-------+-------+
| bayelva             | Norway   | 78.92 / 11.83     | 3.29 | 19.53 | 15.68 |
+---------------------+----------+-------------------+------+-------+-------+
| samoylov_island     | Russia   | 72.37 / 126.50    | 3.56 |  9.49 | 33.93 |
+---------------------+----------+-------------------+------+-------+-------+


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


Looking at ELM Results
----------------------

Here is where we will review how to look at the ELM results in Jupyter Lab notebooks.

Advanced ELM Processing
-----------------------

The impact of shrubs in ELM :ref:`The impact of shrubs in ELM`.
Sub-grid variability in ELM :ref:`Sub-grid variability in ELM`.
Understanding and modifying surface files in ELM :ref:`Understanding and modifying surface files in ELM`.




END OF MATERIALS





ELM Background: Snow Processes
------------------------------

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



ELM Background: Vegetation and Shrubs
-------------------------------------

In ELM, shrubs and other vegetation are represented using a  
**plant functional type (PFT)** framework, in which each grid  
cell contains fractional coverage of multiple PFTs (e.g.,  
Arctic shrubs), each with its own prognostic carbon, water,  
and energy budgets.  

Vegetation structure is characterized by prognostic variables  
such as **leaf area index (LAI)** and **stem area index (SAI)**,  
which control radiative transfer, canopy interception of  
precipitation (rain and snow), aerodynamic roughness, and  
transpiration.  

Recent improvements following Sulman et al. (2021) expanded  
the Arctic vegetation representation from two PFTs to nine  
Arctic-specific PFTs, including distinct classes of deciduous  
and evergreen shrubs, nitrogen-fixing alder, graminoids,  
forbs, and nonvascular mosses and lichens.  

These PFTs are parameterized using observed traits such as  
belowground biomass allocation, specific leaf area,  
carbon-to-nitrogen ratios, and rooting depth, enabling improved  
representation of tundra trait diversity and spatial  
variability in biomass and productivity.  

This expanded PFT set improves model fidelity in Arctic  
environments by better capturing functional differences among  
vegetation growth forms and their biophysical and  
biogeochemical roles.  

Photosynthesis and stomatal conductance are computed using  
coupled formulations that link carbon uptake to water loss,  
while vegetation carbon pools evolve through allocation,  
turnover, and mortality processes.  

ELM employs Farquhar photosynthesis (Farquhar et al., 1980;  
Leuning et al., 1995) coupled to either the Ball–Berry  
(Ball et al., 1987) or Medlyn (Medlyn et al., 2011) stomatal  
conductance formulations, depending on model configuration.  

Vegetation interacts strongly with snow and soil through  
**canopy masking and interception**, particularly for shrubs,  
which trap wind-blown snow and reduce exposure of high-albedo  
snow surfaces, indirectly warming underlying soils.  

Snow interception by vegetation is typically parameterized as  
a function of canopy structure, for example:  

.. math::

   M_{\text{snow,int}} = P_{\text{snow}} \left(1 - e^{-k\,\text{LAI}}\right)

where :math:`P_{\text{snow}}` is snowfall and :math:`k` is an  
extinction coefficient.  

Vegetation also influences the surface energy balance through  
changes in albedo, roughness length, and turbulent heat fluxes,  
making shrub cover a key mediator of land–atmosphere coupling  
and permafrost dynamics in ELM.



ELM Background: Permafrost
--------------------------
In ELM, permafrost is represented as an emergent property of the  
prognostic subsurface thermal and hydrologic system rather  
than as a prescribed or binary state.  

ELM solves a vertically discretized soil column with prognostic  
soil temperature, liquid water, and ice content, explicitly  
accounting for freezing and thawing through an enthalpy-based  
(apparent heat capacity) formulation.  

Soil temperature is computed by solving the  
one-dimensional heat diffusion equation through a vertically  
discretized soil column, with explicit representation of  
freezing and thawing processes. The governing equation 
conserves energy within each soil  layer and can be written as:  

.. math::

   C(T,\theta)\,\frac{\partial T}{\partial t}
   =
   \frac{\partial}{\partial z}
   \left(
   k(T,\theta)\,\frac{\partial T}{\partial z}
   \right)
   + Q

where :math:`T` is soil temperature, :math:`t` is time,  
:math:`z` is depth, :math:`C` is the volumetric heat capacity,  
:math:`k` is the thermal conductivity, and :math:`Q` represents  
internal heat sources or sinks, which are typically zero for  
soils.  


This approach allows phase change to occur continuously as soil  
temperatures cross the freezing point, conserving energy and  
capturing realistic seasonal freeze–thaw behavior.  

ELM represents phase change using an enthalpy-based or  
apparent heat capacity formulation, in which latent heat  
effects are incorporated directly into the heat capacity term.  

This can be expressed as:  

.. math::

   C = C_\text{soil} + L_f \frac{\partial \theta_i}{\partial T}

where :math:`C_\text{soil}` is the sensible heat capacity of  
soil solids, liquid water, and ice, :math:`L_f` is the latent  
heat of fusion, and :math:`\theta_i` is the volumetric ice  
content.  

Soil thermal conductivity and heat capacity vary dynamically as  
functions of soil texture, moisture, and ice content, enabling  
simulation of active-layer development, thermal buffering, and  
long-term permafrost stability or degradation. Frozen soils
generally exhibit higher conductivity than unfrozen soils.

The subsurface thermal regime is coupled to the land surface  
through boundary conditions imposed by the surface energy  
balance at the top of the soil column and a zero-flux or  
prescribed geothermal heat flux at the lower boundary.

The heat equation is discretized using a finite-difference  
approach and solved implicitly in time to ensure numerical  
stability under strong temperature gradients and during  
freeze–thaw transitions. 

Snow and vegetation influence permafrost primarily by modifying  
heat exchange between the atmosphere and soil, with snow acting  
as an insulating layer and vegetation altering radiative and  
turbulent fluxes at the surface.  

These surface controls modulate winter soil cooling and summer  
warming, shaping ground temperature profiles and controlling  
the depth and timing of seasonal thaw.  

Together, the prognostic soil thermal structure and its coupling  
to surface energy fluxes allow ELM to simulate permafrost  
dynamics, active-layer thickness, and their sensitivity to  
climate forcing in a physically consistent manner.

References
----------

Bintanja, R., 2018. The impact of Arctic warming on increased 
rainfall. Scientific Reports, 8(1), p.16001.

England, M.R., Eisenman, I., Lutsko, N.J. and Wagner, T.J., 2021.
The recent emergence of Arctic amplification. Geophysical Research 
Letters, 48(15), p.e2021GL094086.

Sulman, B.N., Salmon, V.G., Iversen, C.M., Breen, A.L., Yuan, F. 
and Thornton, P.E., 2021. Integrating arctic plant functional types
in a land surface model using above‐and belowground field observations. 
Journal of Advances in Modeling Earth Systems, 13(4), p.e2020MS002396.

Rantanen, M., Karpechko, A.Y., Lipponen, A., Nordling, K., Hyvärinen, O., 
Ruosteenoja, K., Vihma, T. and Laaksonen, A., 2022. The Arctic has warmed 
nearly four times faster than the globe since 1979. Communications Earth 
& Environment, 3(1), p.168.

