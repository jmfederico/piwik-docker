# Matomo deployment with Docker

Use these files to deploy Matomo with Docker on CoreOS or any linux running
Docker.

## How to install
  1. Launch a new CoreOS instance.
  2. Download matomo and extract to `/srv/mtm/`.

    ```
    wget https://builds.matomo.org/piwik.zip
    unzip piwik.zip -d /srv
    mv /srv/piwik /srv/mtm
    ```

  3. Make Matomo writable by php

    ```
    chown -R 82:82 /srv/mtm/
    ```

  4. Copy the content of this repo to `/srv/Docker`.
  5. Download Docker Compose (Check version, as it will change!)

    ```
    curl -L https://github.com/docker/compose/releases/download/1.17.0/docker-compose-`uname -s`-`uname -m` -o /opt/bin/docker-compose
    chmod +x /opt/bin/docker-compose
    ```

  6. Create your .env files and set variables values.

    ```
    cp /srv/Docker/caddy/.env.example /srv/Docker/caddy/.env
    cp /srv/Docker/mariadb/.env.example /srv/Docker/mariadb/.env
    ```

  7. Build and run containers:

    ```
    cd /srv/Docker
    docker-compose build
    docker-compose up -d
    ```

  8. Go to the domain you set on your .env file and that's it.

## Backing up the Database?

  If your Matomo data is mission-critical, you should backup the database. To do
  so deploy your containers with the following commands:

  ```
  cd /srv/Docker
  docker-compose -f docker-compose.yml -f docker-compose.db-backup.yml build
  docker-compose -f docker-compose.yml -f docker-compose.db-backup.yml up -d
  ```

## Questions:
- Why /srv/mtm?

  So that I don't accidentally override any file in /srv/matomo by unzipping
  matomo.zip by mistake.

- Why Caddy?

  Because it is easy to use, and performs fast enough for my needs.

- How is my database backed-up?

  [xtrabackup][xtrabackup] from [Percona][percona] is being used.
  The backup files live in /srv/mariadb/backups. You should keep a copy of those
  files somewhere safe.

  A new full backup is run every 7 days, with incremental backups every 6 hours.
  Backups are kept for 2 weeks.

[xtrabackup]: https://www.percona.com/doc/percona-xtrabackup/LATEST/index.html
[percona]: https://www.percona.com
