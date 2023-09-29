FROM alpine:latest

RUN apk add --no-cache iptables ip6tables iputils net-tools

COPY ./enterpoint.sh /enterpoint.sh

ENTRYPOINT ["/enterpoint.sh"]
CMD ["sleep", "inf"]
