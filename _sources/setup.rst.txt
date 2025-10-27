Getting Started
====================

Follow these instructions to set up your environment for the workshop. This
workshop uses Docker containers to encapsulate the models and visualization
tools.

We have pre-built Docker images for the models and visualization tools, which
can be pulled from Docker Hub. However, if you prefer to build the images
locally, instructions are provided in the :ref:`container-setup` section.

Clone Field-to-Model repository for the workshop
-------------------------------------------------

.. code::

    git clone --recurse-submodules https://github.com/ngee-arctic/field-to-model
    cd field-to-model

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

You will also need to set up a few docker volumes for the workshop:

.. code::

    docker volume create inputdata
    docker volume create output

Docker volumes act as additional 'drives' available on your computer that we
can use to store all of the ELM model input and output in the same places across
platforms (e.g., Windows vs mac). 

Get the workshop data
------------------------------

E3SM/ELM input data needed for the workshop can be downloaded by:

.. code::

    docker run -it --rm \
        -v $(pwd):/home/modex_user \
        -v inputdata:/mnt/inputdata \
        yuanfornl/ngee-arctic-modex25:model-main-latest \
        /home/modex_user/tools/scripts/get_inputdata.sh

.. note:: TODO, write this...
    
    Download from bucket? Google Drive? git clone? Thumb drives?


Launch the containers
----------------------------

Then once you have the images you can run them with the following commands
from the folder containing the field-to-model repo:

.. code::

    docker run -it --rm \
        -v  $(pwd):/home/modex_user \
        -v inputdata:/mnt/inputdata \
        -v output:/mnt/output \
        yuanfornl/ngee-arctic-modex25:model-main-latest /bin/bash

.. code::

    docker run -it --rm \
        -v  $(pwd):/home/modex_user \
        -v output:/mnt/output \
        -p 8888:8888 \
        yuanfornl/ngee-arctic-modex25:vis-main-latest

If you need a shell into the visualization container, you can open one using:

.. code::

    docker exec -it {CONTAINER_NAME} /bin/bash

.. note:: TODO, write this...
    
    issue some kind of run command and get a shell in the container with 
    volumes mounted to the workshop data and the correct ports open...

    RPF - added information about this, but really what it needs is CONTAINER_NAME
    which can be determined by `docker ps`. Alternative option would be to specify 
    the container name at container startup in the docker run commands.

