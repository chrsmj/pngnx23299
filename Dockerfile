FROM debian:12
RUN apt update && apt install -y ansible git python3 lsb-release
COPY entrypoint.bash /entrypoint.bash
ENTRYPOINT ["/entrypoint.bash"]
