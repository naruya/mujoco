# mujoco @ docker on remote pc

## dl_remote (beta)
For Deep Reinforcement Learning on remote server.

## Usage

```shell
$ ssh foo@bar
$ git clone https://github.com/naruya/dl_remote.git
$ cd dl_remote
$ cp /path/to/mjkey.txt ./
$ docker build . -t dl_remote  # it takes about 15 min
$ nvidia-docker run -it --privileged -v /share2/n-kondo/:/root/share -p 5900:5900 -p 8888:8888 -p 6006:6006 --name kondo_temp dl_remote
```

in your container,
```
# ./start.sh
```

use vnc viewer on your local machine

## Test

```shell
$ cd tests
$ python test_mujoco.py
```

# mujoco @ docker on local pc

## Docker Hub
- https://cloud.docker.com/u/naruya/repository/docker/naruya/mujoco-mil

## Dockerfile
- https://github.com/naruya/mujoco/blob/master/Dockerfile
- mujoco-mil + cuda + OpenGL(GUI) + zsh + pyenv
  - mujoco-mil: https://github.com/tianheyu927/mil

## Host
- ubuntu16.04

## Run

### docker build (if you need)
```
$ docker build ./ -t mujoco-mil
```

## docker run

.mujoco/  
  ├ mjkey.txt  
  └ mjpro131/  

- mjpro131: https://www.roboti.us/download/mjpro131_linux.zip

```
# change "path/to/host/.mujoco", "path/to/workspace(this dir must include mil textures)"
$ docker run --runtime=nvidia -it \
             -e "DISPLAY" -e "QT_X11_NO_MITSHM=1" -v /tmp/.X11-unix:/tmp/.X11-unix \
             -v /home/hsr-dev2/.mujoco:/root/.mujoco -v /home/hsr-dev2/workspace/:/root/share \
             -p 8888:8888 --name mil naruya/mujoco-mil
```

Run below in host.
```
$ xhost local:
```

(Additional) Simple mujoco sample. Run below in a running container.
```
$ cd workspace
$ git clone https://github.com/naruya/mujoco.git
$ cd mujoco
$ python mujoco_sample.py
```

don't forget
```
# change "path/to/textures"
$ cp -d -r ~/share/data/textures ~/workspace/gym/gym/envs/mujoco/assets/sim_push_xmls
```

(Additional) tecnets
```
# change "path/to/textures"
$ cp -d -r ~/share/data/textures ~/workspace/gym/gym/envs/mujoco/assets/sim_push_xmls
$ cd workspace
$ git clone https://git.hsr.io/matsuolab/task_embedded_control_networks.git
$ cd task_embedded_control_networks
$ pip install -r requirements.txt
$ mkdir logs
$ wget https://www.dropbox.com/s/55t0j5b0odf2mbo/ctr_20.732142329216003_2019-05-22T17%3A15%3A58.938877.pt -P ./logs/
$ wget https://www.dropbox.com/s/d8yt1g9ru527hyg/emb_20.732142329216003_2019-05-22T17%3A15%3A58.936195.pt -P ./logs/
$ jl &
# Run meta-test
```
