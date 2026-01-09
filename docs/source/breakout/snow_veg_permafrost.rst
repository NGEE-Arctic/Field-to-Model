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


Setting Up Model Simulations
----------------------------

Mean annual temperature is projected to increase by up to +8.5 °C at
NGEE-Arctic sites according to downscaled CMIP6 projections using a
15-member ensemble (`<https://dap.climateinformation.org/dap/>`_).

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

TEM and ELM Models
------------------

In this next few presentations, we will go into more details on ELM and
TEM, and show you how to run each of these models and look at model
results for different cases for snow, vegetation, and permafrost model
outputs. 

.. toctree::
   :maxdepth: 2

   ELM_Model
   TEM_Model
  
.. toctree::
   :hidden:

   snow_veg_permafrost_agenda


References
----------

Bintanja, R., 2018. The impact of Arctic warming on increased 
rainfall. Scientific Reports, 8(1), p.16001.

England, M.R., Eisenman, I., Lutsko, N.J. and Wagner, T.J., 2021.
The recent emergence of Arctic amplification. Geophysical Research 
Letters, 48(15), p.e2021GL094086.

Rantanen, M., Karpechko, A.Y., Lipponen, A., Nordling, K., Hyvärinen, O., 
Ruosteenoja, K., Vihma, T. and Laaksonen, A., 2022. The Arctic has warmed 
nearly four times faster than the globe since 1979. Communications Earth 
& Environment, 3(1), p.168.

