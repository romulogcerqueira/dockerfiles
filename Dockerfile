ARG BASE_IMAGE
FROM $BASE_IMAGE
LABEL maintainer "Rômulo Cerqueira <romulogcerqueira@gmail.com>"

RUN export DEBIAN_FRONTEND=noninteractive; \
    apt-get update && \
    apt-get install -y software-properties-common && \
    add-apt-repository ppa:brightbox/ruby-ng

# Install dependencies
RUN apt-get update && apt-get install -y \
        build-essential \
        pkg-config \
        git \
        wget \
        sudo \
        ruby2.5 \
        ruby2.5-dev \
        locales \
        tzdata \
        bash-completion \
        && apt-get clean \
        && echo "Binary::apt::APT::Keep-Downloaded-Packages \"true\";" | tee /etc/apt/apt.conf.d/bir-keep-cache \
        && rm -rf /etc/apt/apt.conf.d/docker-clean \
        && rm -rf /tmp/* /var/tmp/*

RUN export LANGUAGE=en_US.UTF-8; \
    export LANG=en_US.UTF-8; \
    export LC_ALL=en_US.UTF-8; \
    locale-gen en_US.UTF-8; \
    DEBIAN_FRONTEND=noninteractive dpkg-reconfigure locales

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
COPY install-autoproj.sh /usr/local/bin/install-autoproj
RUN chmod 755 /usr/local/bin/install-autoproj

CMD ["/bin/bash"]
