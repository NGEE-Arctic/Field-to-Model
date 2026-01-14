# ATS for NGEE Arctic ModEx Workshop

This will be one section of broader NGEE Arctic ModEx workshop, which will be offered Jan 14-15, 2026, in Santa Fe, New Mexico and virtually.

## Key Links (tl;dr)

* See the [full workshop agenda](https://ngee-arctic.github.io/Field-to-Model/index.html)


# Participant: Set up for this short course

Follow the instructions at [this link](https://ngee-arctic.github.io/Field-to-Model/setup.html).

## Quickstart

1. Launch the visualization container:

```sh 
docker run -it --pull always --rm \
    -p 8888:8888 \
    -v $(pwd):/home/jovyan \
    -v inputdata:/mnt/inputdata \
    -v output:/mnt/output \
    yuanfornl/ngee-arctic-modex26:vis-main-latest
```


2. Open the web browser (as before) and point it at your Jupyter lab instance.

3. Navigate to the folder `model_examples/ATS` and open the Jupyter notebook, `ats_demos.ipynb`

4. Launch the modeling container:

```sh 
docker run -it --pull always --rm \
    -v $(pwd):/home/modex_user \
    -v inputdata:/mnt/inputdata \
    -v output:/mnt/output \
    yuanfornl/ngee-arctic-modex26:models-main-latest \
    /bin/bash
```

