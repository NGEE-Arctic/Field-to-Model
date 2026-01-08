Getting Started
====================

Follow these instructions to set up your environment for the workshop. This
workshop uses Docker containers to simplify installation of models and visualization
tools. Both the models and visualization tools can have complex dependencies and prerequisites
that need to be available on your computer. Docker containers allow us to simplify installation 
across computers and operating systems by providing a single "bundle" that contains the models,
visualization tools, and their dependencies. 

We have pre-built Docker images for the models and visualization tools, which
can be pulled from Docker Hub.

.. caution:: 
    If you prefer to build the images locally, instructions are provided in the :ref:`container-setup` section.
    It will take quite some time, and we strongly recommend using the pre-built containers.

Required software:
--------------------------

You will need the following software:

* Docker Desktop - though note you may need an institutional license.
* git
* WSL (Windows Subsystem for Linux) for Windows users

Optionally, you will need a 3D visualization tool: one of ParaView or VisIt for the ATS section of this workshop.  VisIt is a little more intuitive to new users if you have never used either one and is sufficient for 90% of what we will do; ParaView is preferred for viewing complex 3D meshes.
  
Docker
^^^^^^

`Download Docker <https://www.docker.com/get-started>`_

.. admonition:: Windows

    Installation for Windows can be difficult since WSL 2 is required for the current version of Docker Desktop, so it is important to begin this process well before the short-course. If given the choice during installation, choose WSL 2 instead of Hyper-V.

    To manually update WSL 2:

    * Open a terminal or Powershell.
    * Update WSL ``wsl --update``
    * Install WSL ``wsl --install`` **Note: The process will take awhile and prompt you for an account creation**
    * Verify install using ``wsl --list``. You should see something like "Ubuntu".
    * Set default WSL ``wsl --set-default-version 2``

    .. warning::

        You will have to be mindful of whether your command line interfaces from here on are Windows Powershell kernels
        or a Linux/WSL kernel. Everything above this comment should be done in PowerShell, everything from here should 
        be done in Linux/WSL kernel. If you are not sure which you are currently using, try running ``uname -a`` in your
        command line window. If you are in PowerShell, you will get an error; if you are in WSL/Linux, you should get output
        that starts with "Linux" or "Ubuntu". If you are in PowerShell, and need a WSL terminal, you could open one using 
        the WSL application, a new Ubuntu application if it's been installed or simply typing ``wsl`` into Powershell at this point.
        (note, however for this last option: you should change directories to /home/${USER} - ``cd /home/${USER}``) 

    .. seealso::

        * `WSL Installation <https://docs.microsoft.com/en-us/windows/wsl/install-win10#step-4---download-the-linux-kernel-update-package>`_
        * `WSL Troubleshooting Guide <https://learn.microsoft.com/en-us/windows/wsl/troubleshooting#installation-issues>`_


.. admonition:: macOS

    Download and install the .dmg file for your silicon type, whether Intel (older) or Apple (M1 and newer).

.. admonition:: Linux

    Docker provides instructions for adding DEB package repositories, then installing through apt-get for Ubuntu, Debian, and related distributions.  They also provide RPMs for RHEL8 & 9 and Fedora, and pacman for Arch.


Git
^^^

* **Mac OSX**: git is included in the *command line tools*, installed via ``xcode-select --install``, or in XCode itself.
* **Linux**: git is included as a standard package under most package managers, e.g. ``sudo apt-get install git``.
* **Windows**: See `Git Downloads <https://github.com/git-guides/install-git>`_. Note that the GitHub Desktop is also an option for Windows users and provides a GUI.

ParaView or VisIt
^^^^^^^^^^^^^^^^^^^^^^
* **ParaView**: ParaView can be installed from the KitWare website (or for LANL folks, LANL self service/software center): `Download ParaView <https://www.paraview.org/download/>`_
* **VisIt**: VisIt can be installed from the LLNL website: `Download VisIt <https://wci.llnl.gov/simulation/computer-codes/visit/downloads>`_

Terminal Tips
-------------------------------------------------
We will be using Terminal to access the Command Line. You can open Terminal by clicking the Spotlight Search magnifying glass at the top right of your computer and typing "Terminal." 


Each time you see code in the box below, copy and paste the contents of it into your Terminal window and hit Enter for the code to run. Some common commands are as follows:

.. code::

    ls
    cd
    pwd
    history
    exit
    

where
    * ls means 'list' and provides a list of the files within your current directory (folder)
    * cd means 'change directory' and allows you to move from one directory to another
    * pwd means "print working directory" and outputs the filepath of the directory where you are currently located
    * history prints a history of the commands you have already run
    * exit allows you to leave your Docker session and return to your home directory 
    * Ctrl + C will cancel a command (useful if you want to cancel a model run)
    * Tab will autocomplete a command or file name

Clone Field-to-Model repository for the workshop
-------------------------------------------------

.. tip::

    Reminder that Windows users now need to be in a WSL terminal for this step and all subsequent steps.

.. code::

    git clone --recurse-submodules https://github.com/ngee-arctic/field-to-model
    cd field-to-model

This step downloads all of the scripts and infrastructure we have developed for the workshop,
it should take a couple minutes to complete.

.. note:: 

    You will likely see some SSH errors if you don't have an SSH key setup - 
    this should be okay, these submodules are not needed for the workshop.

Download Docker containers
----------------------------

The workshop uses two Docker containers: one for running the models and another
for visualization.

The model container has the following models available:

- ELM (Energy Exascale Earth System Land Model)    
- TEM (Terrestrial Ecosystem Model)    
- ATS (Advanced Terrestrial Simulator)

The model container is ~1.6GB on Docker Hub, and the visualization container is 
~2.1GB on Docker Hub.

Once you have the containers downloaded, you can run them on your local machine
with the following commands:

.. code::
    
    docker pull yuanfornl/ngee-arctic-modex26:models-main-latest
    docker pull yuanfornl/ngee-arctic-modex26:vis-main-latest

You will also need to set up a few docker volumes for the workshop:

.. code::

    docker volume create inputdata
    docker volume create output

Docker volumes act as additional 'drives' available on your computer that we
can use to store all of the ELM model input and output in the same places across
platforms (e.g., Windows vs Mac). 

.. warning::

    If you happen to still have the volumes from the 2022 workshop in 
    Chattanooga, you are likely to encounter errors. There are two options to resolve that:

    1) You could delete these volumes and make new ones:

        .. code:: bash

            docker volume delete inputdata
            docker volume delete output
            docker volume create inputdata
            docker volume create output

    2) If you want to keep these volumes, you could give them different names, e.g.,

        .. code:: bash

            docker volume create inputdata26
            docker volume create output26

    However, note if you choose the second option, you won't be able to copy and paste
    the container commands from the rest of the documentation. Instead, you'll have to change
    the volume mounts for input and output data to:

        .. code:: bash

            -v inputdata26:/mnt/inputdata \
            -v output26:/mnt/output




Get the workshop data
------------------------------

E3SM/ELM and TEM input data needed for the workshop can be downloaded by:

.. code::

    docker run -it --pull always --rm \
        -v $(pwd):/home/modex_user \
        -v inputdata:/mnt/inputdata \
        yuanfornl/ngee-arctic-modex26:models-main-latest \
        /home/modex_user/tools/scripts/get_inputdata.sh

Test the containers
----------------------------

We have included a quick script to test whether the container images work for you:

.. code::

    docker run -it --pull always --rm \
        -v $(pwd):/home/modex_user \
        -v inputdata:/mnt/inputdata \
        -v output:/mnt/output \
        yuanfornl/ngee-arctic-modex26:models-main-latest \
        /home/modex_user/tools/scripts/test_container.sh

If you get output that matches the output below, you've setup the container correctly:

.. code:: 

    ATS version 1.6.0_9f6f117d
    v0.8.3-42-g77038e0c
    Docker	E3SM  README.md  docs  model_examples  tools  vis_notebooks
    inputdata  output


Let's also test the visualization container:

.. code::

    docker run -it --pull always --rm \
        -p 8888:8888 \
        -v $(pwd):/home/jovyan \
        -v inputdata:/mnt/inputdata \
        -v output:/mnt/output \
        yuanfornl/ngee-arctic-modex26:vis-main-latest

You should get output to your terminal window that looks something like this:

.. code-block:: bash

    [I 2026-01-07 18:34:13.827 ServerApp] nbclassic | extension was successfully loaded.
    [I 2026-01-07 18:34:13.850 ServerApp] nbdime | extension was successfully loaded.
    [I 2026-01-07 18:34:13.852 ServerApp] notebook | extension was successfully loaded.
    [I 2026-01-07 18:34:13.852 ServerApp] panel.io.jupyter_server_extension | extension was successfully loaded.
    [I 2026-01-07 18:34:13.856 ServerApp] solara.server.jupyter.server_extension | extension was successfully loaded.
    [I 2026-01-07 18:34:13.858 ServerApp] voila.server_extension | extension was successfully loaded.
    [I 2026-01-07 18:34:13.858 ServerApp] Serving notebooks from local directory: /home/jovyan
    [I 2026-01-07 18:34:13.858 ServerApp] Jupyter Server 2.17.0 is running at:
    [I 2026-01-07 18:34:13.858 ServerApp] http://localhost:8888/lab?token=5418c0dfba4d91815397d3ca582be0f905541d7ffbc0ae09
    [I 2026-01-07 18:34:13.858 ServerApp]     http://127.0.0.1:8888/lab?token=5418c0dfba4d91815397d3ca582be0f905541d7ffbc0ae09
    [I 2026-01-07 18:34:13.858 ServerApp] Use Control-C to stop this server and shut down all kernels (twice to skip confirmation).
    [C 2026-01-07 18:34:13.862 ServerApp] 
        
        To access the server, open this file in a browser:
            file:///home/jovyan/.local/share/jupyter/runtime/jpserver-7-open.html
        Or copy and paste one of these URLs:
            http://localhost:8888/lab?token=5418c0dfba4d91815397d3ca582be0f905541d7ffbc0ae09
            http://127.0.0.1:8888/lab?token=5418c0dfba4d91815397d3ca582be0f905541d7ffbc0ae09

If you do, copy one of the bottom two links into a web browser and it should open a JupyterLab interface.


Please take a moment to report if you were able to successfully get to this stage, or 
post any issues you are having here: https://github.com/NGEE-Arctic/Field-to-Model/issues/38
and we will try to have someone from the organizing team help you out before the workshop!
