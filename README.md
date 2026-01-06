# 2nd NGEE Arctic Field-to-Model Workshop
<img src=".assets/NGEE Arctic logo_large (002).png" align="right" width="200">

Welcome to the 2nd NGEE Arctic Field-to-Model Workshop in Santa Fe, New Mexico!
Following the project's tradition of bringing modelers to the field, our goal
over this 2.5-day workshop is to bring empiricists to the models. We will be
providing an introduction to land surface modeling by providing overviews of
three different land surface models used across the project.

**Attendees, please see the [workshop website](https://ngee-arctic.github.io/Field-to-Model/index.html) 
for all setup instructions, agendas, and information!**

> [!NOTE]
> It is highly recommended that you download the workshop containers and input data ahead of time.
> Setup Instrucitons found [here](https://ngee-arctic.github.io/Field-to-Model/setup.html) and 
> additional setup information [here](https://github.com/NGEE-Arctic/Field-to-Model/issues/38)

> [!WARNING]
> Windows users will have a longer setup procedure than macOS or Linux users. It is even more strongly
> recommended that attendees hoping to run the models on a Windows computer work through the setup instructions
> ahead of the workshop.


## Developer Info

> [!TIP]
> Attendeeds should be able to ignore this section.

More comprehensive developer information is held in the Developer Notes section
of the [workshop website](https://ngee-arctic.github.io/Field-to-Model/index.html#developer-notes),
but for a quick start see these instructions.

There are 3 container images for the project: 

 - a modeling image,
 - a visualization image, and
 - a documentation builder image.

The modeling image has all the heavy weight modeling tools installed. The
visualization image has Jupyter Lab installed, and the documentation builder
image has the Sphinx tool installed.

The project used Github Actions to automatically build and publish the images to
Docker Hub. Attendees (and for the most part developers too) will begin by
pulling the images from DockerHub:

```
docker pull yuanfornl/ngee-arctic-modex26:models-main-latest
docker pull yuanfornl/ngee-arctic-modex26:vis-main-latest
```

The documentation builder image is not published, so to work on the
documentation, you will need to build the image first:

```
docker build -t docbuilder --target docbuilder -f Docker/Dockerfile-docs .
```

and then you can start a "live reload" server that will let you modify the
documentation and see a a preview of the webpages in your local browser:

```
docker run --name docbuilder \
      -p9999:9999 \
      --mount type=bind,src=$(pwd)/docs,dst=/docs \ # bind mount needs abs path!
      -it --rm docbuilder make livehtml
```

## Known issues:

- ERA5 for Bayelva not working currently