FROM cirrusci/flutter:2.4.0-4.2.pre

USER root
ENV DEBIAN_FRONTEND noninteractive

WORKDIR /build

COPY . .

# Install some tools and dependencies
RUN apt-get update && \
	apt-get install -y dos2unix && \
	# Remove the updates list of packages to lighten the layer
	rm -rf /var/lib/apt/lists/* && \
	# Some files on Windows use CRLF newlines. It is incompatible with UNIX.
	dos2unix docker-entrypoint.sh && chmod a+x docker-entrypoint.sh && \
	# Update flutter project dependencies
	flutter doctor --no-color && \
	flutter --version && \
	flutter pub get

# Update the PATH env variable
ENV PATH="$PATH:$HOME/.pub-cache/bin"

ENTRYPOINT ["bash", "./docker-entrypoint.sh"]
