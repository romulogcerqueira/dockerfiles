ARG BASE_IMAGE
FROM $BASE_IMAGE
LABEL maintainer "Rômulo Cerqueira <romulogcerqueira@gmail.com>"

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get install -y software-properties-common && \
    add-apt-repository ppa:brightbox/ruby-ng && \
    apt-get update && apt-get install -y --no-install-recommends \
        apt-utils \
        bash-completion \
        build-essential \
        curl \
        git \
        locales \
        pkg-config \
        ruby2.5 \
        ruby2.5-dev \
        sudo \
        tzdata \
        wget && \
    curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash && \
    apt-get install -y git-lfs && \
    apt-get clean && \
    echo "Binary::apt::APT::Keep-Downloaded-Packages \"true\";" | tee /etc/apt/apt.conf.d/bir-keep-cache && \
    rm -rf /etc/apt/apt.conf.d/docker-clean && \
    rm -rf /tmp/* /var/tmp/*

# Set env variables
RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8 \
    QT_X11_NO_MITSHM=1

# Replicate host user to the docker image
ARG USER
ARG UUID
ARG UGID

RUN useradd -m $USER && \
    echo "$USER:$USER" | chpasswd && \
    usermod --shell /bin/bash $USER && \
    usermod -aG sudo $USER && \
    echo "$USER ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/$USER && \
    chmod 0440 /etc/sudoers.d/$USER && \
    usermod --uid $UUID $USER && \
    groupmod --gid $UGID $USER

# Copy workspace script to docker image
COPY ./rootfs/ /

RUN chmod 755 /usr/bin/install-autoproj && \
    chmod 755 /usr/bin/bootstrap-project && \
    chmod 755 /usr/bin/install-workspace && \
    chmod 755 /usr/bin/reset-omniorb

CMD ["/bin/bash"]
