# vim:set ft=dockerfile:

# Do not edit individual Dockerfiles manually. Instead, please make changes to the Dockerfile.template, which will be used by the build script to generate Dockerfiles.

# By policy, the base image tag should be a quarterly tag unless there's a
# specific reason to use a different one. This means January, April, July, or
# October.

FROM cimg/base:2023.07

LABEL maintainer="Community & Partner Engineering Team <community-partner@circleci.com>"

ENV JAVA_VERSION 21
ENV JAVA_HOME /usr/local/jdk-${JAVA_VERSION}

RUN [[ $(uname -m) == "x86_64" ]] && ARCH="x64" || ARCH="aarch64" && \
	JAVA_MAJOR_VERSION=$(echo "$JAVA_VERSION" | cut -d '.' -f 1) && \
	JAVA_PATCH_VERSION=$(echo "$JAVA_VERSION" | cut -d '.' -f 3) && \
	if [ "$JAVA_MAJOR_VERSION" = "8" ]; then \
		JAVA_BUILD=$(curl -s "https://api.github.com/repos/adoptium/temurin8-binaries/releases" | jq ".[] | select(.tag_name | startswith(\"jdk8u${JAVA_PATCH_VERSION}\")) | .tag_name" | tr -d '"'); \
		JAVA_BUILD="${JAVA_BUILD/jdk8u/}"; \
		JAVA_BUILD_SANITISED="${JAVA_BUILD//-/}"; \
		URL="https://github.com/adoptium/temurin8-binaries/releases/download/jdk8u${JAVA_BUILD}/OpenJDK8U-jdk_${ARCH}_linux_hotspot_8u${JAVA_BUILD_SANITISED}.tar.gz"; \
	else \
		JAVA_BUILD=$(curl -s "https://api.github.com/repos/adoptium/temurin${JAVA_MAJOR_VERSION}-binaries/releases" | jq ".[] | select(.tag_name | startswith(\"jdk-${JAVA_VERSION}+\")) | .tag_name | split(\"+\")[1]" | tr -d '"'); \
		URL="https://github.com/adoptium/temurin${JAVA_MAJOR_VERSION}-binaries/releases/download/jdk-${JAVA_VERSION}%2B${JAVA_BUILD}/OpenJDK${JAVA_MAJOR_VERSION}U-jdk_${ARCH}_linux_hotspot_${JAVA_VERSION}_${JAVA_BUILD}.tar.gz"; \
	fi && \
	curl -sSL -o java.tar.gz "${URL}" && \
	sudo mkdir /usr/local/jdk-${JAVA_VERSION} && \
	sudo tar -xzf java.tar.gz --strip-components=1 -C /usr/local/jdk-${JAVA_VERSION} && \
	rm java.tar.gz && \
	if [[ "$JAVA_VERSION" == *"0.0"* ]]; then \
		sudo ln -s /usr/local/jdk-${JAVA_VERSION} /usr/local/jdk-21.0; \
	fi && \
	sudo ln -s /usr/local/jdk-${JAVA_VERSION}/bin/* /usr/bin/ && \
	sudo mkdir -p /etc/ssl/certs/java/cacerts && \
	sudo ln -s ${JAVA_HOME}/lib/security/cacerts /etc/ssl/certs/java/cacerts && \
	# Install packages to help with legacy image migration
	sudo apt-get update && sudo apt-get install -y \
		fontconfig \
	&& \
	sudo rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
	# The dual version command is to support OpenJDK 8
	java --version || java -version && \
	javac --version || javac -version

ENV MAVEN_VERSION=3.9.5 \
	PATH=/opt/apache-maven/bin:$PATH
RUN dl_URL="https://www.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz" && \
	curl -sSL --fail --retry 3 $dl_URL -o apache-maven.tar.gz && \
	sudo tar -xzf apache-maven.tar.gz -C /opt/ && \
	rm apache-maven.tar.gz && \
	sudo ln -s /opt/apache-maven-* /opt/apache-maven && \
	mvn --version

ENV GRADLE_VERSION=8.4 \
	PATH=/opt/gradle/bin:$PATH
RUN dl_URL="https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip" && \
	curl -sSL --fail --retry 3 $dl_URL -o gradle.zip && \
	sudo unzip -d /opt gradle.zip && \
	rm gradle.zip && \
	sudo ln -s /opt/gradle-* /opt/gradle && \
	gradle --version

ENV SBT_VERSION=1.9.6 \
	PATH=/opt/sbt/bin:$PATH
ENV MILL_VERSION=0.11.2
RUN dl_URL="https://github.com/sbt/sbt/releases/download/v${SBT_VERSION}/sbt-${SBT_VERSION}.tgz" && \
	curl -sSL --fail --retry 3 $dl_URL -o sbt.tar.gz && \
	sudo tar -xzf sbt.tar.gz -C /opt/ && \
	sudo ln -s /opt/sbt-* /opt/sbt && \
	sbt about && \
	rm -rf sbt.tar.gz ~/project/project ~/project/target && \
	# install mill docs: http://mill-build.com/mill/Installation_IDE_Support.html#_mills_bootstrap_script_linuxos_x_only
	mill_URL="https://github.com/com-lihaoyi/mill/releases/download/${MILL_VERSION}/${MILL_VERSION}" && \
	curl -sSL --fail --retry 3 $mill_URL > mill && \
	sudo mv mill /usr/local/bin/mill && chmod +x /usr/local/bin/mill
