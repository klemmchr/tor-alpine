FROM alpine:latest

RUN apk --update --allow-untrusted --repository http://dl-4.alpinelinux.org/alpine/edge/community/ add \
      libevent \
      tor \
      torsocks \
    && sed "1s/^/SocksPort 0.0.0.0:9050\n/" /etc/tor/torrc.sample > /etc/tor/torrc.config \  
    && rm -rf /var/cache/apk/* /tmp/* /var/tmp/*

EXPOSE 9050

VOLUME ["/var/lib/tor"]

RUN chown -R tor /etc/tor

USER tor

ENTRYPOINT [ "tor", "-f", "/etc/tor/torrc.config" ]
