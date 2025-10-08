# Field-to-Model

## temporary instructions - move to wiki:
1) `git clone --recurse-submodules https://github.com/NGEE-Arctic/field-to-model`
2) `cd field-to-model`
3) `docker volume create workshop_data`
4) To build model container: `docker build -t model-container -f Docker/Dockerfile-models .` (this will take a while, please open an issue for any build failures)
5) To build visualization container: `docker build -t vis-container -f Docker/Dockerfile-vis .`

To run before CI is finalized:
6) Model container: `docker run -it -v $(pwd):/home/modex_user -v workshop_data:/home/modex_user/data yuanfornl/model-test:main-latest`
7) Vis container (@jsta this will need some work) - a) launch jupyter lab with same folder mounts; b) connect over localhost

When CI is up/more robust:
8) To run model container: `docker run -it -v $(pwd):/home/modex_user yuanfornl/ngee-modex-models:main-latest`
(Note: still needs volume mounts for input/output data)
9) To run visualization container: `docker run -it -v $(pwd):/home/modex_user yuanfornl/ngee-modex-visualization:main-latest`
