FROM node:8-stretch
LABEL MAINTAINER="Erik Weber <terbolous@gmail.com>"

USER root
ARG SDK_FILE=sdk-tools-linux-4333796.zip
ENV ANDROID_HOME=/opt/android

RUN apt-get update \
    && apt-get install -y openjdk-8-jdk-headless lib32stdc++6 lib32z1 ruby-bundler ruby-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /opt/android \
    && cd /opt/android \
    && curl -SL -O https://dl.google.com/android/repository/${SDK_FILE} \
    && unzip ${SDK_FILE} \
    && rm ${SDK_FILE} \
    && yes | tools/bin/sdkmanager --licenses


# These are ugly hacks to fix permission problems when doing `bundle install` as non privleged user
RUN chmod -R 777 /opt/android /usr/local/bin # This is ugly hack \
    && find /var/lib/gems -type d -exec chmod 777 {} \;

USER circleci
CMD ["/bin/bash"]
