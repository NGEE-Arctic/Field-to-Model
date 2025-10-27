General Notes
===========================================================

 - This Sphinx project is configured to use MyST parser to allow writing in 
   Markdown as well as reStructuredText. 
 
 - Markdown is easier to write, but reStructuredText is much more powerful for
   advanced formatting. 
   
 - If you want collapse blocks, use reStructuredText.

 - The :code:`sphinx-autobuild` extension (which is enabled) would be super
   handy, but for some reason the hot reloading is not working; changes to the
   source files in the host editor don't trigger any events in the dev server.

 - There is some custom CSS in the :code:`source/_static/css/custom.css` file to
   style the collapse blocks. You can edit that file to change the colors,
   borders, etc. See the comments in the CSS file for more details.


Working with Sphinx Docs
===========================================================
The Dockerfile-docs file contains instructions to build a Docker image that can
build and serve the Sphinx docs.

There are a number of ways you can use this, but for working on content and
editing the docs, the easiest is to use the live reloading server shown below.

Building the Docker Image
---------------------------

.. code:: bash

  docker build -t docbuilder --target docbuilder -f Docker/Dockerfile-docs .

Running the container with Live Reload
----------------------------------------

Run the container! This starts a live-reloading server on port 9999 that is 
watching the docs folder for changes. When it encounters changes, it rebuilds
the docs. On your host system you can open a browser to localhost:9999 to see
the docs.

.. code:: bash
  
  docker run --name docbuilder \
      -p9999:9999 \
      --mount type=bind,src=$(pwd)/docs,dst=/docs \ # bind mount wants abs path
      -it --rm docbuilder make livehtml

.. warning::
    
    On OSX host, the traditional volume mount doesn't seem to trigger rebuilds. 
    Also note that restarting the Docker daemon was necessary before live reload
    worked with the bind mount!!

Working with the Modeling and Visualization Docker Images
===========================================================

.. _container-setup:

Container Setup
-------------------

.. code::

    # # data
    git clone --recurse-submodules https://github.com/NGEE-Arctic/field-to-model
    cd field-to-model
    docker volume create workshop_data

    # # to build model container
    # # (this will take a while, please open an issue for any build failures)
    docker build -t model-container -f Docker/Dockerfile-models . 

    # # to build visualization container
    docker build -t vis-container -f Docker/Dockerfile-vis .

    # # to run before CI is finalized:
    # # Model container:
    docker run -it -v $(pwd):/home/modex_user -v workshop_data:/home/modex_user/data yuanfornl/model-test:main-latest

    # # Vis container (@jsta this will need some work) - a) launch jupyter lab with same folder mounts; b) connect over localhost

    # # When CI is up/more robust:
    # # To run model container:
    docker run -it -v $(pwd):/home/modex_user yuanfornl/ngee-modex-models:main-latest

    # # (Note: still needs volume mounts for input/output data)
    # # To run visualization container: 
    docker run -it -v $(pwd):/home/modex_user yuanfornl/ngee-modex-visualization:main-latest


Usage
-------------------

These examples show 

.. code::

  # # model image

  # # visualization image
  docker pull yuanfornl/vis-test:main-latest

  docker run -it --init \
      --mount type=bind,source=$(pwd),target=/home/joyvan/workdir -w /home/joyvan/workdir -p 9999:9999 \
      yuanfornl/vis-test:main-latest

  docker run -it --init \
      --mount type=bind,source=$(pwd),target=/home/joyvan/workdir -w /home/joyvan/workdir -p 8888:8888 \
      vis-test
