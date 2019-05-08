# Run below in host terminal when you use GUI apps.
# ```
# $ xhost local:
# ```

# sample docker build && docker run command
# ```
# $ docker build ./ -t cudagl-9.0-cudnn7
# $ docker run --runtime=nvidia -it -e DISPLAY=${DISPLAY} -v /tmp/.X11-unix:/tmp/.X11-unix cudagl-9.0-cudnn7
# ```

# https://gitlab.com/nvidia/cuda/blob/ubuntu16.04/9.0/devel/cudnn7/Dockerfile
# https://github.com/pyenv/pyenv/wiki/Common-build-problems
# http://wiki.ros.org/docker/Tutorials/Hardware%20Acceleration

# cudagl
FROM nvidia/cudagl:9.0-devel-ubuntu16.04
ENV CUDNN_VERSION 7.5.0.56

RUN apt-get update && apt-get install -y --no-install-recommends \
            libcudnn7=$CUDNN_VERSION-1+cuda9.0 \
            libcudnn7-dev=$CUDNN_VERSION-1+cuda9.0 && \
    apt-mark hold libcudnn7

RUN apt-get update -y && apt-get -y upgrade && apt-get install -y make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev python-openssl git vim zsh

SHELL ["/bin/zsh", "-c"]

RUN wget http://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh

RUN curl https://pyenv.run | zsh && \
    echo '' >> /root/.zshrc && \
    echo 'export PATH="/root/.pyenv/bin:$PATH"' >> /root/.zshrc && \
    echo 'eval "$(pyenv init -)"' >> /root/.zshrc && \
    echo 'eval "$(pyenv virtualenv-init -)"' >> /root/.zshrc

RUN source /root/.zshrc && \
    pyenv install 3.6.8 && \
    pyenv global 3.6.8

RUN apt-get install -y libglu1 libosmesa6-dev libgl1-mesa-glx libglfw3

RUN source /root/.zshrc && \
    pip install mujoco-py==0.5.7 jupyter scipy natsort 

RUN mkdir /root/workspace
WORKDIR /root/workspace
RUN git clone https://github.com/tianheyu927/gym.git
WORKDIR /root/workspace/gym
RUN git checkout mil && \
    source /root/.zshrc && \
    pip install -e '.[mujoco]'

RUN echo 'alias jn="jupyter notebook --ip 0.0.0.0 --port 8888 --allow-root"' >> /root/.zshrc
RUN echo 'alias jl="jupyter lab --ip 0.0.0.0 --port 8888 --allow-root"' >> /root/.zshrc

WORKDIR /root
CMD ["zsh"]
