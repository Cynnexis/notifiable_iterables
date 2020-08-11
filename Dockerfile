FROM cirrusci/flutter:1.17.5

USER root
ENV DEBIAN_FRONTEND noninteractive

WORKDIR /build

RUN apt-get update && \
	apt-get install -y dos2unix

COPY . .

# Some files on Windows use CRLF newlines. It is incompatible with UNIX.
RUN dos2unix docker-entrypoint.sh && chmod a+x docker-entrypoint.sh

# Update flutter project dependencies
RUN which flutter && flutter --version && pub get

EXPOSE 33153
EXPOSE 50729

ENTRYPOINT ["bash", "./docker-entrypoint.sh"]
