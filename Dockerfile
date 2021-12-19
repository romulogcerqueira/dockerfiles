ARG BASE_IMAGE
FROM $BASE_IMAGE

RUN export DEBIAN_FRONTEND=noninteractive; \
    apt-get update && \
    apt-get install -y software-properties-common && \
    add-apt-repository ppa:brightbox/ruby-ng && \
    apt-get update && \
    apt-get install -y build-essential && \
    apt-get install -y pkg-config && \
    apt-get install -y git && \
    apt-get install -y wget && \
    apt-get install -y sudo && \
    apt-get install -y ruby2.5 && \
    apt-get install -y ruby2.5-dev && \
    apt-get install -y locales && \
    apt-get install -y tzdata && \
    apt-get install -y bash-completion && \
    apt-get clean && \
    echo "Binary::apt::APT::Keep-Downloaded-Packages \"true\";" | tee /etc/apt/apt.conf.d/bir-keep-cache && \
    rm -rf /etc/apt/apt.conf.d/docker-clean && \
    rm -rf /tmp/* /var/tmp/*

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
ARG USERNAME
ARG UUID
ARG UGID

RUN useradd -m $USERNAME && \
    echo "$USERNAME:$USERNAME" | chpasswd && \
    usermod --shell /bin/bash $USERNAME && \
    usermod -aG sudo $USERNAME && \
    echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/$USERNAME && \
    chmod 0440 /etc/sudoers.d/$USERNAME

RUN usermod  --uid $UUID $USERNAME && \
    groupmod --gid $UGID $USERNAME

# Copy workspace script to docker image
COPY install-autoproj.sh /usr/local/bin/install-autoproj
RUN chmod 755 /usr/local/bin/install-autoproj

CMD ["/usr/sbin/sshd", "-D"]
