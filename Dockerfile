FROM alpine/git
# RUN apk add --no-cache bash ca-certificates curl jq
COPY entrypoint.sh /semver.sh
RUN chmod +x /semver.sh
ENTRYPOINT ["/semver.sh"]