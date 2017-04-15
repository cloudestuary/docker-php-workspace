FROM cloudestuary/php-cli:7.1

RUN DEBIAN_FRONTEND=noninteractive

ENV TERM xterm

RUN apt-get update && \
    apt-get install -y --force-yes \
        openssh-server \
        pkg-config \
        libcurl4-openssl-dev \
        libedit-dev \
        libssl-dev \
        libxml2-dev \
        xz-utils \
        libsqlite3-dev \
        sqlite3 \
        git \
        curl \
        vim \
        nano \
        postgresql-client \
        locales \
&& apt-get clean

# Set LOCALE to UTF8
RUN locale-gen en_US.UTF-8 en_us \
  && dpkg-reconfigure locales \
  && dpkg-reconfigure locales \
  && locale-gen C.UTF-8 \
  && /usr/sbin/update-locale LANG=C.UTF-8
ENV LANG C.UTF-8
ENV LANGUAGE C.UTF-8
ENV LC_ALL C.UTF-8

# Setup the Composer
RUN curl -o /tmp/composer-setup.php https://getcomposer.org/installer \
  && curl -o /tmp/composer-setup.sig https://composer.github.io/installer.sig \
  && php -r "if (hash('SHA384', file_get_contents('/tmp/composer-setup.php')) !== trim(file_get_contents('/tmp/composer-setup.sig'))) { unlink('/tmp/composer-setup.php'); echo 'Invalid installer' . PHP_EOL; exit(1); }" \
  && php /tmp/composer-setup.php \
  && php -r "unlink('/tmp/composer-setup.php');" \
  && mv composer.phar /usr/local/bin/composer


ARG PUID=1000
ARG PGID=1000
RUN groupadd -g $PGID cloudestuary \
  && useradd -u $PUID -g cloudestuary -m cloudestuary -s /bin/bash -d /var/www \
  && chown -R cloudestuary:cloudestuary /var/www

# Prepare ssh user
RUN mkdir /var/run/sshd
RUN echo 'cloudestuary:secret' | chpasswd \
  && echo 'AllowUsers cloudestuary' >> /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

RUN . ~/.bashrc

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
