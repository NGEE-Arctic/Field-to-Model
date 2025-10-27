TEM Setup Details
================================

Build Images
**************

If you need to build the image locally for development purposes, use:

.. code::

  docker build -t model-container -f Docker/Dockerfile-models .  


Start Container
********************* 

TEM is now installed at `/opt/dvmdostem` in the container. This command shows
the port mapping in case you want to run a Jupyter notebook server or similar
(not installed by default).

.. code::

  docker volume create inputdata
  docker volume create output
  docker run -it --rm \
         --port 9999:9999 \
         -v inputdata:/mnt/inputdata \
         -v output:/mnt/output \
         -v $(pwd):/home/modex_user model-container:latest

Demo run
*********************

Proof of concept that the installation and compilation worked. Also shows how to
use the :code:`pyddt` tools to set up a working directory for a run, modify some
settings, and run the model.

See the :code:`model_examples/TEM/test.sh` script for a runnable toy example.

.. This literal include is not working properly with Sphinx because of the way
.. that for the doc builder container, only the :code:`docs/` directory is mounted.
.. this means that the relative path to the script is not valid.
.. In order to use this, will need to re-think the way the doc build container is
.. set up to include the whole repo, or at least the model_examples folder.

.. literalinclude:: ../../model_examples/TEM/test.sh
  :language: bash
  :linenos:
  :emphasize-lines: 11-14,25-31

