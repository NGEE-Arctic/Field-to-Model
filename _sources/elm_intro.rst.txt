Introduction to ELM and workshop scripts
=========================================

The E3SM Land Model (ELM) is the land surface component of the coupled E3SM model. ELM simulates a wide set of land surface and ecosystem processes, including surface energy balance, photosynthesis, carbon allocation, soil and surface hydrology, nitrogen and phosphorus dynamics, and snow processes, among others. ELM can be run by itself (if provided meteorological forcing data) or in different coupling configurations of E3SM. In addition, ELM can be run in point (e.g., single grid cell), regional, or global configurations.

For this workshop, we have simplified the process of running ELM for several Arctic sites using a shell script. Several of the new parameterizations added in phase 3 of the NGEE Arctic project are accessible through this script, as are several ways of testing the sensitivity of model results to changes in forcing conditions. You can see the options that are available for the script by running:

In the first example, we will run a 'control' case for one of the NGEE Arctic sites where none of the new capabilities developed for NGEE Arctic have been turned on. 


note::

Under the hood
--------------
The script we have developed simplifies the interface to the Offline Land Model Testbed (OLMT), developed by Dan Ricciuto (ORNL). OLMT itself simplifies the setup of model cases necessary to spin up an ELM simulation from a 'cold start' condition. (Figure of hierarchy?). OLMT sets up three cases that run consecutively: an 'accelerated' decomposition spin up that features accelerated biogeochemical cycling, a second stage of spin up with normal biogeochemical cycling rates, and finally a transient run that starts in 1850 and continues to near present (depending on how long the forcing datasets run). OLMT automates the setup of these cases through the E3SM case control system (CIME - Common Infrastructure for Modeling the Earth).
