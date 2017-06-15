PGID=${GID:-1000}
PUID=${UID:-1000}
PASSWORD=${SSH_PASSWOED:-5ebe2294ecd0e0f08eab7690d2a6ee69}

groupadd -g $PGID cloudestuary \
  && useradd -u $PUID -g cloudestuary -m cloudestuary -s /bin/bash -d /var/www \
  && chown -R cloudestuary:cloudestuary /var/www

# Prepare ssh user
mkdir /var/run/sshd
echo 'cloudestuary:'$PASSWORD | chpasswd -c MD5 -e \
  && echo 'AllowUsers cloudestuary' >> /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

echo "export VISIBLE=now" >> /etc/profile

. ~/.bashrc
