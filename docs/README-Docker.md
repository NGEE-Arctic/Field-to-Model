# General docker strategy

Looking to have capability to run ELM, ATS, and TEM from same container. Most direct path is - multi stage build:
1) ubuntu and packages
2) amanzi tpls
3) ats install
4) cime layers
5) TEM layers?
6) 