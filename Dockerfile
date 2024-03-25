FROM geerlingguy/docker-debian12-ansible:latest
RUN apt-get -qq install git lsb-release
COPY entrypoint.bash /entrypoint.bash
ENTRYPOINT ["/entrypoint.bash"]
