FROM cirrusci/flutter:2.5.0-5.2.pre

LABEL name="cynnexis/notifiable_iterables"
LABEL description="Dockerfile that contains embed the notifiable_iterables package for testing purposes."
LABEL version="1.2.0"

# Change default shell to bash for conditions
SHELL ["/bin/bash", "-c"]

USER root
ENV DEBIAN_FRONTEND noninteractive

# Update the PATH env variable
ENV PATH="$PATH:$HOME/.pub-cache/bin"

WORKDIR /build

COPY . .

# Install some tools and dependencies
RUN \
	set -euo pipefail; \
	apt-get update && \
	apt-get upgrade -qq && \
	apt-get install -y dos2unix make && \
	# Remove the updates list of packages to lighten the layer
	rm -rf /var/lib/apt/lists/* && \
	# Some files on Windows use CRLF newlines. It is incompatible with UNIX.
	dos2unix --keepdate docker-entrypoint.sh && \
	chmod a+x docker-entrypoint.sh && \
	# Update flutter project dependencies
	flutter config --no-analytics && \
	flutter doctor --no-color --verbose && \
	flutter --version && \
	flutter clean && \
	flutter pub get && \
    # Print the version of the built flutter app
    make version

ENTRYPOINT ["bash", "./docker-entrypoint.sh"]
