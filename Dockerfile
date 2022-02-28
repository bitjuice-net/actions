FROM alpine/git
RUN apk add --no-cache bash
COPY semver.sh /semver.sh
RUN chmod +x /semver.sh
ENTRYPOINT ["/semver.sh"]