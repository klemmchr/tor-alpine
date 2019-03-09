
FROM alpine:latest

RUN apk --update --allow-untrusted --repository http://dl-4.alpinelinux.org/alpine/edge/community/ add \
      tor \
      torsocks \
    && rm -rf /var/cache/apk/* /tmp/* /var/tmp/*

RUN chown -R tor /etc/tor

USER tor

ENTRYPOINT [ "tor", "-f", "/etc/tor/torrc.config" ]