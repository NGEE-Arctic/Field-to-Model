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

