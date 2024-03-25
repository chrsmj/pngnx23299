FROM debian:12
COPY entrypoint.bash /entrypoint.bash
ENTRYPOINT ["/entrypoint.bash"]
