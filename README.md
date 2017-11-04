# Piwik deployment with Docker

Use these files to deploy Piwik with Docker on CoreOS or any system compatible
with systemd.

## How to install
  1. Launch a new CoreOS instance.
  - Download piwik and extract to `/srv/pwk/`.

    ```
    wget https://builds.piwik.org/piwik.zip
    unzip piwik.zip -d /srv
    mv /srv/piwik /srv/pwk
    ```

  - Make Piwik writable by php

    ```
    chown -R 82:82 /srv/pwk/
    ```

  - Copy the content of this repo to `/srv/Docker`.
  - Download Docker Compose (Check version, as it will change!)

    ```
    curl -L https://github.com/docker/compose/releases/download/1.17.0/docker-compose-`uname -s`-`uname -m` -o /opt/bin/docker-compose
    chmod +x /opt/bin/docker-compose
    ```

  - Create your .env files and set variables values.

    ```
    cp /srv/Docker/caddy/.env.example /srv/Docker/caddy/.env
    cp /srv/Docker/mariadb/.env.example /srv/Docker/mariadb/.env
    ```

  - Build and run containers:

    ```
    cd /srv/Docker
    docker-compose build
    docker-compose up -d
    ```

  - Go to the domain you set on your .env file and that's it.

## Questions:
- Why /srv/pwk?

  So that I don't accidentally override any file in /srv/piwik by unziping
  piwik.zip by mistake.

- Why Caddy?

  Because it is easy to use, and performs fast enough for my needs.
