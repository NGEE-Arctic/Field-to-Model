ELM Background
===============

ELM is based on the Community Land Model Version 4.5 (CLM4.5,
Oleson et al. 2013). ELM calculates canopy radiation flux using the
two-stream approximation methods; snow albedo using the Snow, Ice, and
Aerosol Radiative Model (SNICAR) model (Flanner et al., 2007); and snow
cover fraction based on snow water equivalent (Swenson and Lawrence, 2012).
ELM also represents the snow hydrological processes including snowfall
accumulation, melting, refreezing, compaction, aging, water transfer across
layers, etc.

New features in ELM to better represent land surface processes include an
updated representation of soil hydrology (Bisht et al., 2018), improved
treatment of ecosystem carbon dynamics (Tang and Riley, 2018), a novel
topography-based sub-grid spatial structure impacting atmospheric preciptiation
and temperature (Tesfa and Leung, 2017, Tesfa et al. 2020) and radiation
(Hao et al. 2022), an irrigation scheme constrained by water management
(Zhou et al., 2020), and improved snow albedo (Hao et al. 2023). 


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

For more details, see the CLM 4.5 Tech Note (Oleson et al 2013).

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

Ball, J.T., Woodrow, I.E. and Berry, J.A., 1987, October. A model predicting
stomatal conductance and its contribution to the control of photosynthesis
under different environmental conditions. In Progress in photosynthesis research:
volume 4 proceedings of the VIIth international congress on photosynthesis
providence, Rhode Island, USA, august 10–15, 1986 (pp. 221-224). Dordrecht:
Springer Netherlands.

Bisht, G., Riley, W.J., Hammond, G.E. and Lorenzetti, D.M., 2018.
Development and evaluation of a variably saturated flow model in the
global E3SM Land Model (ELM) version 1.0. Geoscientific Model Development,
11(10), pp.4085-4102.

Farquhar, G.D., von Caemmerer, S., and Berry, J.A. 1980. A biochemical
model of photosynthetic CO2 assimilation in leaves of C3 species.
Planta 149:78-90.

Flanner, M.G., Arnheim, J., Cook, J.M., Dang, C., He, C., Huang, X.,
Singh, D., Skiles, S.M., Whicker, C.A. and Zender, C.S., 2021.
SNICAR-AD v3: A community tool for modeling spectral snow albedo.
Geoscientific Model Development Discussions, 2021, pp.1-49.

Hao, D., Bisht, G., Huang, M., Ma, P.L., Tesfa, T., Lee, W.L., Gu, Y.
and Leung, L.R., 2022. Impacts of sub‐grid topographic representations
on surface energy balance and boundary conditions in the E3SM land model:
A case study in Sierra Nevada. Journal of Advances in Modeling Earth
Systems, 14(4), p.e2021MS002862.

Hao, D., Bisht, G., Rittger, K., Bair, E., He, C., Huang, H.,
Dang, C., Stillinger, T., Gu, Y., Wang, H., Qian, Y., and Leung, L. R.,
2023. Improving snow albedo modeling in the E3SM land model (version 2.0)
and assessing its impacts on snow and surface fluxes over the Tibetan
Plateau, Geosci. Model Dev., 16, 75–94,
https://doi.org/10.5194/gmd-16-75-2023.

Leuning R. A critical appraisal of a combined stomatal‐photosynthesis model
for C3 plants. Plant, Cell & Environment. 1995 Apr; 18(4):339-55.

Medlyn, B.E., Duursma, R.A., Eamus, D., Ellsworth, D.S., Prentice, I.C., 
Barton, C.V., Crous, K.Y., De Angelis, P., Freeman, M. and Wingate, L., 2011.
Reconciling the optimal and empirical approaches to modelling stomatal
conductance. Global change biology, 17(6), pp.2134-2144.

Oleson, K.W., Lawrence, D.M., Bonan, G.B., Fisher, R.A., Lawrence, P.J.
and Muszala, S.P., 2013. Technical description of version 4.5 of the
Community Land Model (CLM). Technical description of version 4.5 of
the Community Land Model (CLM)(2013) NCAR/TN-503+ STR, 503.

Sulman, B.N., Salmon, V.G., Iversen, C.M., Breen, A.L., Yuan, F. 
and Thornton, P.E., 2021. Integrating arctic plant functional types
in a land surface model using above‐and belowground field observations. 
Journal of Advances in Modeling Earth Systems, 13(4), p.e2020MS002396.

Swenson, S.C. and Lawrence, D.M., 2012. A new fractional snow‐covered
area parameterization for the Community Land Model and its effect
on the surface energy balance. Journal of geophysical research:
Atmospheres, 117(D21).

Tang, J. and Riley, W.J., 2018. Predicted land carbon dynamics are
strongly dependent on the numerical coupling of nitrogen mobilizing
and immobilizing processes: A demonstration with the E3SM land model.
Earth Interactions, 22(11), pp.1-18.

Tesfa, T. K. and Leung, L.-Y. R.: Exploring new topography-based subgrid
spatial structures for improving land surface modeling, Geosci. Model Dev.,
10, 873–888, https://doi.org/10.5194/gmd-10-873-2017, 2017.

Tesfa, T.K., Leung, L.R. and Ghan, S.J., 2020. Exploring topography‐based
methods for downscaling subgrid precipitation for use in Earth System
Models. Journal of Geophysical Research: Atmospheres, 125(5), p.e2019JD031456.

Zhou, T., Leung, L.R., Leng, G., Voisin, N., Li, H.Y., Craig, A.P., 
Tesfa, T. and Mao, Y., 2020. Global irrigation characteristics and
effects simulated by fully coupled land surface, river, and water
management models in E3SM. Journal of Advances in Modeling Earth
Systems, 12(10), p.e2020MS002069.
