Getting Started
====================

Follow these instructions to set up your environment for the workshop. This
workshop uses Docker containers to encapsulate the models and visualization
tools.

We have pre-built Docker images for the models and visualization tools, which
can be pulled from Docker Hub. However, if you prefer to build the images
locally, instructions are provided in the developer section.

Download Docker containers
----------------------------

The workshop uses two Docker containers: one for running the models and another
for visualization.

Each the model container has the following models installed:

- ELM (Energy Exascale Earth System Land Model)    
- TEM (Terrestrial Ecosystem Model)    
- ATS (Advanced Terrestrial Simulator)

The model container is ~1.6GB on Docker Hub, and the visualization container is 
~2.1GB on Docker Hub.

Once you have the containers downloaded, you can run them on your local machine
with the following commands:

.. code::
    
    docker pull yuanfornl/ngee-arctic-modex25:model-main-latest
    docker pull yuanfornl/ngee-arctic-modex25:vis-main-latest

Then once you have the images you can run them with the following commands:

.. code::

    docker run -it --rm \
        -v <path_to_your_workshop_data>:/home/workshop_data \
        yuanfornl/ngee-arctic-modex25:model-main-latest /bin/bash

.. code::

    docker run -it --rm \
        -v <path_to_your_workshop_data>:/home/workshop_data \
        -p 8888:8888 \
        yuanfornl/ngee-arctic-modex25:vis-main-latest /bin/bash

Get the workshop data
------------------------------

.. note:: TODO, write this...
    
    Download from bucket? Google Drive? git clone? Thumb drives?


Launch the containers
----------------------------

.. note:: TODO, write this...
    
    issue some kind of run command and get a shell in the container with 
    volumes mounted to the workshop data and the correct ports open...

