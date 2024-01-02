FROM alpine:latest
RUN apk --update add ca-certificates \
                     mailcap \
                     curl \
                     ffmpeg \
                     jq

COPY healthcheck.sh /healthcheck.sh
RUN chmod +x /healthcheck.sh  # Make the script executable

HEALTHCHECK --start-period=2s --interval=5s --timeout=3s \
    CMD /healthcheck.sh || exit 1

VOLUME /srv
VOLUME /cache
EXPOSE 80

COPY docker_config.json /.filebrowser.json
COPY filebrowser /filebrowser

ENTRYPOINT [ "/filebrowser", "--cache-dir", "/cache", "--token-expiration-time", "6h"]
