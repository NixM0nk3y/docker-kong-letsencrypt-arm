#
#
#

FROM arm32v6/alpine:3.8

LABEL maintainer="Nick Gregory <docker@openenterprise.co.uk>"

RUN apk add --no-cache --virtual .build-deps \
        git \
    && apk add --no-cache \
        python \
        curl \
    && cd /usr/local/bin
    && git clone https://github.com/lukas2511/dehydrated
    && cd dehydrated
    && mkdir hooks

# Add our custom hooks
COPY hooks/ /usr/local/bin/dehydrated/hooks/

# Add our scripts
COPY scripts/ /app/

# Add Dehdrated to the path
ENV PATH=/usr/local/bin/dehydrated:$PATH

# Our container start point
CMD ["/app/provision.sh"]

WORKDIR /app
