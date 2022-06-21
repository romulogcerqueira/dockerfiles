# dockerfiles
Personal collection of dockerfiles.

### 1. Install docker-ce
```bash
curl https://get.docker.com | sh
sudo systemctl --now enable docker
```
### 2. Installing NVIDIA Container Toolkit (for X display support)
```console
distribution=$(. /etc/os-release;echo $ID$VERSION_ID) \
   && curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add - \
   && curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
sudo apt update
sudo apt install -y nvidia-docker2
sudo systemctl restart docker
```

### 3. Add your user to docker group
```console
sudo usermod -aG docker <your_username>
```

Log out and log back in so that your group membership is re-evaluated.

### 4. Build the docker image (based on Ubuntu 20.04 - Focal Fossa)
```console
./build.sh
```

### 5. Execute the container
```console
./run-devel.sh
```
