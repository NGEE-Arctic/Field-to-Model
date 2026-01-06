
ELM Background: Snow, Vegetation, and Permafrost Processes
============================================================


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

Sulman, B.N., Salmon, V.G., Iversen, C.M., Breen, A.L., Yuan, F. 
and Thornton, P.E., 2021. Integrating arctic plant functional types
in a land surface model using above‐and belowground field observations. 
Journal of Advances in Modeling Earth Systems, 13(4), p.e2020MS002396.
