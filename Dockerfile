#
FROM python:3.9
LABEL maintainer="https://github.com/pjaos/"

ENV DEVPI_PASSWORD $DEVPI_PASSWORD
ENV PIP_NO_CACHE_DIR="off"
ENV PIP_INDEX_URL="https://pypi.python.org/simple"
ENV PIP_TRUSTED_HOST="127.0.0.1"

RUN apt-get update
RUN apt-get -y install sudo
RUN /usr/local/bin/python -m pip install --upgrade pip

#Use the latest versions of the devpi modules in the container.
RUN pip install devpi-client devpi-web devpi-server

EXPOSE 3141
VOLUME /data

COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

ENV HOME /data
WORKDIR /data

ENTRYPOINT ["/docker-entrypoint.sh"]
