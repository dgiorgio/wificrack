FROM alpine:latest

ENV LANG=en_US.UTF-8

# add our user first to make sure the ID get assigned consistently,
# regardless of whatever dependencies get added
RUN addgroup -S wificrack && adduser -S -G wificrack wificrack \
    && apk add --no-cache \
        dnsmasq \
        hostapd \
        net-tools \
        iptables \
        dbus

USER wificrack

RUN mkdir /home/wificrack/.wifi-crack

VOLUME RUN mkdir /home/wificrack/.wifi-crack

EXPOSE 8080 8081
CMD ["mitmproxy"]
