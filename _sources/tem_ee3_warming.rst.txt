TEM Warming Experiment
================================================

What are we trying to model?
-------------------------------------------------------------

We are trying to model a warming experiment. This will help us understand
whether our models are doing an adequate job at representing the outcomes of
field warming experiments. If they do, we are more confident that they can be
used to make predictions into the future with further warming.

Setup
-----

We will be running the model at the Toolik Field Station. We will use the demo
demonstration data that is shipped with the TEM model for our "control" or
"base" run. This data is based on the CRU TS 4.0 dataset.

We will then create a second input dataset that is identical to the first except
that the air temperatures have been increased by 2 degrees Celsius during the
summer months (June, July, August) for the years 2000-2015.

This will be our "treatment" or "warming" run.

We will then compare the outputs of the two runs to see how the warming has
affected the model's predictions of various ecosystem variables.

.. collapse:: Draft API ideas for creating altered input data
   :class: workshop-collapse
   :name: draft-api

   .. code:: python

      warming_experiment(deviation=2, sign='+', year=2015, month=May, 
                        original_data=/path/to/data 
                        altered_data=/path/to/users/experiment/director)  

      warming_experiment(deviation=2, sign='+', year=2015, month=May, 
                        original_data=/path/to/data 
                        altered_data=/path/to/users/experiment/director)

   Similar for precipitation

   .. code:: python

      precip_experiment(
         mm=2,
         sign='+',
         year=2020,
         month=January,
         original_data=/path/to/data
         altered_data=/path/to/users/experiment/director
      )

Technical Experiment Setup
----------------------------

#. What spatial (geographic) area(s) do you want to run. Single or multi-pixel run?
  
   Single pixel, choose one of the available places (e.g. Utqiagvik, Kougarok, Kougarok Hillslope, Toolik) 

#. Is this experiment designed around a single run or multiple runs? If multiple describe what is different between each run.

   Two different runs: the control run and a warming experiment (treatment)

#. Decide what variables and resolutions you want to have output.
  
   This will be very variable depending on the person. I would want to output a wide range of variables and provide a wide range of plotting tools.

#. Which stages to run? How many years for each stage?
  
   :code:`-p 100 -e 2000 -s 250 -t 115 -n 85`, Potentially with the option of combining transient and scenario? 
   Also consider using the restart capability to avoid running eq over and over?

#. From which stages do we need to save the output?
  
   Transient and scenario; combined, see above

#. Which Community Type(s) to use?
  
   Shrub, tussock, and wet sedge tundra

#. Is this run a calibration (parameter estimation) run? If so, elaborate.
  
   No

#. List some ideas for how you expect to analyze the outputs
  
   This is the complicated answer because it's likely a lot! We want options for people to be able to explore their science questions.

#. What computer will the runs be on?
   
   Laptop with Docker container pulled from cloud

#. Decide where on your computer you want to store your model run(s).
   
   User will have a folder on their host, i.e. :code:`~/ngee-modex-2025/workflows` that is mounted inside the container

#. Decide how to organize the outputs (important if the experiment dictates multiple runs)
   
   One folder for "control" one folder for each "treatment case"

#. Are the driving inputs and parameters for the specified run(s) available?
   
   We should make sure they are :) I guess the specific warming experiment driver will be created as part of the example though.

#. If the experiment is a multi-run experiment, can the different runs be scripted?
   
   Not sure yet...see example API above in the intro; only 2 runs so no need to fully automate...

#. Is the run a single pixel (site) run or a multi pixel?
   
   single

#. Decide on all other run settings/parameters:

   * Is the community type (CMT) fixed or driven by input vegetation.nc map?
   * Any other command line options or special environment settings?

#. Will the plotting happen in the run-time environment or will the data need to be copied to a different environment?

Analysis
----------------------------

.. note:: TODO, write this...

   What kinds of plots and analyses do we want to provide? What variables are we
   most interested in? How do we want to visualize the differences between the
   control and warming runs?

   Some ideas:
   
   * Time series plots of key variables (e.g. GPP, NEE, soil carbon) for control vs warming
   * Seasonal cycle plots
   * Difference maps if multi-pixel
   * Statistical summaries (means, variances, trends)
   * Comparison to observational data if available

   We can use Jupyter notebooks for interactive analysis and visualization.   