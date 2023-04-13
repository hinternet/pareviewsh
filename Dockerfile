FROM php:8.1-alpine

WORKDIR /root

USER root

ENV DEBIAN_FRONTEND=noninteractive
ENV LC_ALL=C.UTF-8
ENV SHELL=/bin/bash
ENV HOME=/root
ENV COMPOSER_ALLOW_SUPERUSER=1
ENV COMPOSER_HOME=$HOME/.composer
ENV PAREVIEW_DIR=$HOME/pareview
ENV PATH=$PATH:$HOME/.local/bin:$HOME/.composer/bin:$PAREVIEW_DIR

# Dependencies
RUN set -ex; \ 
  apk update; \
  apk add --no-cache apk-tools \
  bash \
  curl \
  php81-cli \
  php81-mbstring \
  php81-simplexml \
  py3-pip\
  git \
  npm \
  wget \
  unzip;

# Composer
RUN set -ex; \ 
 wget -qO- https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer;

# PARewiev
RUN set -ex; \ 
  composer global config repositories.drupal composer https://packages.drupal.org/8; \
  composer global config bin-dir bin; \
  git clone https://git.drupalcode.org/project/pareviewsh $PAREVIEW_DIR; \
  composer install --working-dir=$PAREVIEW_DIR -n;

WORKDIR /opt/src

ENTRYPOINT ["pareview.sh"]
# Passing it's own repository since will be overwritten during run
CMD [ "https://git.drupalcode.org/https://www.drupal.org/project/pareviewsh" ]