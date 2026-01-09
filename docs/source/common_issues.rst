Common Issues/FAQ
=====================

* If you see the following when running ELM/OLMT, you need to clone the Field-to-Model repository with the `--recurse-submodules` flag:

.. code-block:: 

   **** Running OLMT:
   /opt/conda/bin/python: can't open file '/home/modex_user/tools/olmt/./site_fullrun.py': [Errno 2] No such file or directory

* If you try to run two instances of the Docker containers at the same time,
  with the same port mappings you may see an error like this:

  .. code:: 

    docker: Error response from daemon: failed to set up container networking:
    driver failed programming external connectivity on endpoint friendly_shirley
    (a9108d46d0ece39a56496506b75135a04c4669eb8c1f1018d832c71e64eb4941): Bind for
    0.0.0.0:8888 failed: port is already allocated




More Information and Links
=============================

Setup help:

  * :ref:`Workshop Setup Instructions <setup>`
  * `Github Issue for Setup Notes <https://github.com/NGEE-Arctic/Field-to-Model/issues/38>`_
  * :ref:`Workshop Agenda <modex_agenda_2025>`

More information about ELM

  * `E3SM's ELM Documentation <https://docs.e3sm.org/E3SM/ELM>`_ (note: this is under development)
  * `CLM 4.5 Technical Note <https://www.cesm.ucar.edu/models/cesm2/land/docs/CLM45_Tech_Note.pdf>`_
  * `E3SM Development repository <https://github.com/E3SM-Project/E3SM/tree/master/components/elm>`_

More information about TEM

  * `DVM-DOS-TEM documentation <http://uaf-arctic-eco-modeling.github.io/dvm-dos-tem/>`_
  * `DVM-DOS-TEM development repository <https://github.com/uaf-arctic-eco-modeling/dvm-dos-tem>`_

More information about ATS

  * `Amanzi-ATS documentation <https://amanzi.github.io>`_
  * `ATS development repository <https://github.com/amanzi/ats>`_ 

More information about ILAMB

  * `ILAMB documentation <https://www.ilamb.org>`_
  * `ILAMB development repository <https://github.com/rubisco-sfa/ILAMB>`_

Breakout groups

  * `Permafrost Hydrology <https://ngee-arctic.github.io/Field-to-Model/breakout/permafrost_hydrology.html>`_
  * `Snow/Vegetation/Permafrost Interactions <https://ngee-arctic.github.io/Field-to-Model/breakout/snow_veg_permafrost.html>`_
  * `Hillslope Hydrology impacts on Biogeochemistry <https://ngee-arctic.github.io/Field-to-Model/breakout/hillslope_bgc.html>`_  

Additional resources
=========================

  * `Introduction to version control using Git <https://swcarpentry.github.io/git-novice/>`_


Glossary
=================

.. list-table::
  :header-rows: 1
  :widths: 20 80

  * - **Acronym**
    - **Definition**
  * - ATS
    - Advanced Terrestrial Simulator
  * - CI
    - Continuous Integration
  * - DaPPER
    - Data PreParation for ELM Runs 
  * - DVM-DOS-TEM
    - Dynamic Vegetation Model Dynamic Organic Soil Terrestrial Ecosystem Model
  * - E3SM
    - Energy Exascale Earth System Model
  * - ELM
    - E3SM Land Model
  * - ILAMB
    - International Land Model Benchmarking system
  * - IM3
    - ??
  * - MEQ
    - ??
  * - OLMT
    - Offline Land Model Testbed

