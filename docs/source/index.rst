.. Modex2025 documentation master file, created by
   sphinx-quickstart on Sat Oct 11 21:15:10 2025.

Welcome to the ModEx 2026 Field to Model Workshop
===================================================

Welcome to the 2nd NGEE Arctic Field-to-Model Workshop in Santa Fe, NM!
Following the project's tradition of bringing modelers to the field, our goal
over this 2.5-day workshop is to bring empiricists to the models. We will be
providing an introduction to land surface modeling by providing overviews of
three different land surface models used across the project:

 * the Energy Exascale Earth System (E3SM) Land Model (ELM), 
 * the Advanced Terrestrial Simulator (ATS), and
 * DVM-DOS-TEM (Dynamic Vegetation, Dynamic Organic Soil, 
   Terrestrial Ecosystem Model, often shortened to TEM) 
  
that illustrate different design philosophies, approaches, and tradeoffs in
representing land surface processes. 

We will also introduce the ILAMB (International LAnd Model
Benchmarking) and DaPPER (Data PreParation for ELM Runs) python packages. ILAMB
is designed to improve model-data integration and allow for validation of land
surface models against observations, while DaPPER allows for the generation of
necessary ELM input data from gridded datasets on Google Earth Engine.

A major component of this workshop will be three breakout groups that will focus
in greater detail on a specific set of Arctic processes in the models. The
breakout groups will focus on 

 #. permafrost hydrology,
 #. snow/vegetation/permafrost interactions, and
 #. hillslope hydrology impacts on biogeochemistry. 
 
We have tried to structure the breakout groups to include experts from at least
two of these models in each breakout group. Our hope is this structure will help
facilitate conversations not only between the empiricists and modelers, but also
to identify and discuss transferable insights across models.

Over the duration of the workshop, you will be running and analyzing example
cases for all three models, learning more about how you might be able to apply
these models to your research and what their limitations might be, and hopefully
finding opportunities for future collaboration and ideas for future
publications. We hope that you are as excited for the workshop as we are!

Here you will find resources and documentation needed to follow the workshop examples.

.. note::

  It is highly recommended that you download the workshop containers and input
  data ahead of time. More information and a log of various setup issues can be
  found here: `<https://github.com/NGEE-Arctic/Field-to-Model/issues/38>`_


.. warning::

  Windows users will have a longer setup procedure than macOS or Linux users. It
  is even more strongly recommended that attendees hoping to run the models on a
  Windows computer work through the setup instructions ahead of the workshop!!




.. toctree::
  :maxdepth: 2 
  :numbered: 3 

  modex_agenda_2026
  setup
  plenary/elm_intro
  plenary/tem_ee1_warming
  plenary/ats_intro
  plenary/ilamb_intro.rst
  breakout/snow_veg_permafrost
  breakout/permafrost_hydrology
  breakout/hillslope_bgc
  common_issues
  dev_notes
  tem_dev_notes

