# docker-dash-encoder

This is a very simple method of generating [MPEG-DASH](http://dashif.org/) prepared videos without installing any dependencies thanks to [Docker](https://www.docker.com/).

## Usage with MP4Box
Check put the `docker-compose.yaml`:
````
version: '3'
services:
  encoder:
    build: .
    image: docker-dash-encoder
    volumes:
    - './convert.sh:/encoder/convert.sh'
    - './media:/media'
    command: bash ./convert.sh ./in/InMovie.mov
````
Your file should be in the `/media/in` folder in order to be accesed by the docker container (`./in/InMovie.mov` in this example). All files are generated in side the `/media/out` folder.

By default the video is encoded into 3 qualities (1920x1080, 1280x720 and 640x360) for more info check `./convert-shaka.sh` file.

To run it:
```
docker-compose up
# or with one single command
docker run -v $(pwd)/media:/media docker-dash-encoder bash ./convert.sh /media/in/InMovie.mp4
```
## Usage with Shaka Packager
Check put the `docker-compose.yaml`:
````
version: '3'
services:
  shaka-encoder:
    build: ./shaka-packager
    image: docker-dash-encoder:shaka
    volumes:
    - './shaka-packager/convert-shaka.sh:/encoder/convert-shaka.sh'
    - './media:/media'
    command: bash ./convert-shaka.sh /media/in/InMovie.mp4
````
Your file should be in the `/media/in` folder in order to be accesed by the docker container (`./in/InMovie.mov` in this example). All files are generated in side the `/media/out` folder.

By default the video is encoded into 3 qualities (1920x1080, 1280x720 and 640x360) for more info check `./convert.sh` file.

To run it:
```
docker-compose -f docker-compose.shaka.yaml up
# or with one single command
docker run -v $(pwd)/media:/media docker-dash-encoder:shaka bash ./convert-shaka.sh /media/in/InMovie.mp4
```
## Test with local server
Check put the `docker-compose.nginx.yaml`:
````
version: '3'
services:
  proxy:
    build:
      context: .
      dockerfile: Dockerfile.nginx
    image: docker-dash-encoder:nginx
    volumes:
    - './static.conf:/etc/nginx/conf.d/default.conf'
    - './media:/media'
    ports:
    - "8000:80"
````
This will run a static webserver in port 8000 where you can access all files generated. To test if these files actualli work there are some online players like [Online Dash Player](https://dashif.org/reference/players/javascript/1.3.0/samples/dash-if-reference-player/index.html). There you can put the local url of your manifest, something like `http://localhost:8000/out/movie/movie.mpd` and check the adaptative streaming.

To run it:
```
docker-compose -f docker-compose.nginx.yaml up
```

## Resources

+ [Docker](https://www.docker.com/)
+ [Shaka-Packager](https://github.com/google/shaka-packager)
+ [GPAC - MP4Box](https://gpac.wp.imt.fr/mp4box/dash/)
+ [FFMPEG](https://www.ffmpeg.org/)
+ [DASH](http://dashif.org/)
