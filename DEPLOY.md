# Depoly to Ubuntu server by Ansible

## Preparement

1. Install Ubuntu server 16.04;

2. Make sure user `ubuntu` has sudo privilege without password;

3. add key `ansible/crypto_rsa.pub` to user `ubuntu`;

4. Update and upgrade by:
   $ sudo apt-get update
   $ sudo apt-get upgrade

5. Add nodejs source by:
   $ curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -

6. Add openresty source by:
   $ wget -qO - https://openresty.org/package/pubkey.gpg | sudo apt-key add -
   $ sudo apt-get install software-properties-common
   $ sudo add-apt-repository -y "deb http://openresty.org/package/ubuntu $(lsb_release -sc) main"
   $ sudo apt-get update

5. Install python, redis and MySQL manually:
   $ sudo apt-get install python redis-server mysql-server-5.7

## Deploy

### Deploy RocketMQ

Deploy RocketMQ only once:

    $ ansible/deploy.py --profile native mq

Init RocketMQ by upload `script/init-mq.sh` to `/srv/rocketmq` and run once.

### Deploy gateway

Deploy gateway:

    $ ansible/deploy.py --profile native www

### Deploy config server

Deploy config server:

    $ ansible/deploy.py --profile native config

### Deploy all other apps

Deploy all other apps for exchange:

    $ ansible/deploy.py --profile native api manage notification sequence quotation clearing spot-clearing spot-match ui
