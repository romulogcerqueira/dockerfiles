ARG BASE_IMAGE
FROM $BASE_IMAGE
LABEL maintainer "Rômulo Cerqueira <romulogcerqueira@gmail.com>"

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y \
        software-properties-common \
        && add-apt-repository ppa:brightbox/ruby-ng

RUN apt-get update && apt-get install -y \
        apt-utils \
        bash-completion \
        build-essential \
        git  \
        locales \
        pkg-config  \
        ruby2.5 \
        ruby2.5-dev \
        sudo \
        tzdata \
        wget \
        && apt-get clean \
        && echo "Binary::apt::APT::Keep-Downloaded-Packages \"true\";" | tee /etc/apt/apt.conf.d/bir-keep-cache \
        && rm -rf /etc/apt/apt.conf.d/docker-clean \
        && rm -rf /tmp/* /var/tmp/*

RUN export LANGUAGE=en_US.UTF-8; \
    export LANG=en_US.UTF-8; \
    export LC_ALL=en_US.UTF-8; \
    locale-gen en_US.UTF-8; \
    dpkg-reconfigure locales

# Set locales
ENV LANGUAGE=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV QT_X11_NO_MITSHM=1

# Replicate host user to the docker image
ARG USER
ARG UUID
ARG UGID

RUN useradd -m $USER && \
    echo "$USER:$USER" | chpasswd && \
    usermod --shell /bin/bash $USER && \
    usermod -aG sudo $USER && \
    echo "$USER ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/$USER && \
    chmod 0440 /etc/sudoers.d/$USER

RUN usermod  --uid $UUID $USER && \
    groupmod --gid $UGID $USER

# Copy workspace script to docker image
COPY ./rootfs/ /

RUN chmod 755 /usr/local/bin/install-autoproj; \
    chmod 755 /usr/local/bin/bootstrap-project; \
    chmod 755 /usr/local/bin/install-workspace; \
    chmod 755 /usr/local/bin/reset-omniorb

CMD ["/bin/bash"]
