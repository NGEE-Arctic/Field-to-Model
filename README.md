# Field-to-Model

> temporary instructions - move to wiki:

## Setup

```shell
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
```

## Usage

```shell
# # model image

# # visualization image
docker pull yuanfornl/vis-test:main-latest

docker run -it --init \
    --mount type=bind,source=$(pwd),target=/home/joyvan/workdir -w /home/joyvan/workdir -p 9999:9999 \
    yuanfornl/vis-test:main-latest

docker run -it --init \
    --mount type=bind,source=$(pwd),target=/home/joyvan/workdir -w /home/joyvan/workdir -p 8888:8888 \
    vis-test
```


## TEM Minimal Running Example

### Build Images

Ultimately this will be done by CI but this is the command I was using for dev.
Note the means of getting the version ID from TEM repo. This gets injected into
the compiled binary.

```shell
docker build --build-arg TEM_VERSION=$(git -C TEM describe) -t model-container -f Docker/Dockerfile-models .  
```

Note that some of the TEM install could get moved to the base image. Or
otherwise re-arranged, but it was useful to have it all together at the end
of the build for faster development.

### Start Container

Note the explicit directory for this repo inside the container to prevent
mounting over the home directory (and obscuring all the stuff in it like the
install directories!!).

```shell
docker volume create workshop_data
docker run -it --rm -v workshop_data:/home/modex_user/workshop_data -v $(pwd):/home/modex_user/Field-To-Model model-container:latest
```

### Demo run

Proof of concept that the installation and compilation worked.

```shell
# Make a place to save our output...
mkdir runs

# Use the helper tool to setup a working directory for your experiment
# has copies of parameters, config files, and 
pyddt-swd --input-data-path install_dvmdostem/demo-data/cru-ts40_ar5_rcp85_ncar-ccsm4_toolik_field_station_10x10/ runs/EE3_warming

# Fiddle with the settings...single pixel, turn on some output variables...
cd runs/EE3_warming/
pyddt-runmask --reset --yx 5 5
pyddt-runmask --reset --yx 5 5 run-mask.nc 

pyddt-outspec config/output_spec.csv --on LAYERDZ m l
pyddt-outspec config/output_spec.csv --on TLAYER m l 

# check the outspec file to see what we have...
pyddt-outspec -s config/output_spec.csv 

# Run the model
dvmdostem -p 25 -e 25 -s 15 -t 115 -n 85

# outputs are in the output folder!
ls output/
```
