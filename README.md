# docker-dash-encoder

This is a very simple method of generating [MPEG-DASH](http://dashif.org/) prepared videos without installing any dependencies thanks to [Docker](https://www.docker.com/).

## Usage
Check put the `docker-compose.yaml`:
````
version: '3'
services:
  encoder:
    build: .
    image: docker-dash-encoder
    volumes:
    - './convert.sh:/media/convert.sh'
    - './data/out:/media/out'
    - './data/in:/media/in'
    command: bash ./convert.sh ./in/InMovie.mov
````
Your file should be in the `/data/in` folder in order to be accesed by the docker container (`./in/InMovie.mov` in this example). All files are generated in side the `/data/out` folder.

By default the video is encoded into 3 qualities (1920x1080, 1280x720 and 640x360) for more info check `./convert.sh` file.

To run it:
```
docker-compose up
```
