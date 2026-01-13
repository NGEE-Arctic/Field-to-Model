Understanding surface files in ELM
===================================

A surface file is the data input that provides ELM with
a description of the land surface required for our 
simulations. They are stored in a multi-dimensional file
type referred to as a NetCDF. These NetCDF files can 
describe our regions of interest by representing the
land surface in smaller chunks called grid cells.
These files can represent each grid cell in the area we
are modeling with many surface characteristics (often 80+
variables) across a range of plant functional type,
soil levels, and much more. 

There are many ways we can intuitively modify variables
within a surface file to answer different science questions
in our modeling. For example, if we wanted to understand
the impact of shrubification in the Arctic, we could modify
the percentage of the landscape represented by shrubs on
the surface file and compare with our current baseline.