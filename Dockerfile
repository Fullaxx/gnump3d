# ------------------------------------------------------------------------------
# https://www.gnu.org/software/gnump3d/
# ------------------------------------------------------------------------------
# Pull base image
FROM ubuntu:bionic
MAINTAINER Brett Kuskie <fullaxx@gmail.com>

# ------------------------------------------------------------------------------
# Set environment variables
ENV DEBIAN_FRONTEND noninteractive
ENV LANG C
ENV NIR --no-install-recommends
ENV PKGURL http://savannah.gnu.org/download/gnump3d/gnump3d-3.0.tar.bz2

# ------------------------------------------------------------------------------
# Install gnump3d and clean up
RUN apt-get update && apt-get install -y $NIR perl wget make && \
    cd /tmp && wget $PKGURL && \
    tar xf gnump3d-*.tar.* && rm gnump3d-*.tar.* && \
    cd /tmp/gnump3d-* && make install && cd && \
    sed -e 's@/home/mp3@/media@' -i /etc/gnump3d/gnump3d.conf && \
    sed -e 's@/var/cache/gnump3d@/cache@g' -i /etc/gnump3d/gnump3d.conf && \
    sed -e 's@/var/log/gnump3d@/log@g' -i /etc/gnump3d/gnump3d.conf && \
    apt-get -y remove wget make && apt-get clean && \
    rm -rf /var/lib/apt/lists/* /var/tmp/* && \
    rm -rf /tmp/*

# ------------------------------------------------------------------------------
# Install launcher script
COPY app.sh /app/

# ------------------------------------------------------------------------------
# Add volumes
VOLUME /log
VOLUME /cache
VOLUME /media

# ------------------------------------------------------------------------------
# Expose ports
EXPOSE 8888

# ------------------------------------------------------------------------------
# Launch gnump3d
CMD ["/app/app.sh"]
