# Piwik deployment with Docker

Use these files to deploy Piwik with Docker on CoreOS or any system compatible
with systemd.

## How to install
  1. Launch a new CoreOS instance.
  - Download piwik and extract to `/srv/pwk/`.
  ```
  wget https://builds.piwik.org/piwik.zip && unzip piwik.zip -d /srv && mv /srv/piwik /srv/pwk
  ```

  - Copy the content of this repo to `/srv/Docker`.
  - Symlink or copy each \*.system file to /etc/systemd/system:

    ```
    ln -s /srv/Docker/*/*.service  /etc/systemd/system/
    ```

  - Create your .env files and set variables values.

    ```
    cp /srv/Docker/caddy/.env.example /srv/Docker/caddy/.env
    cp /srv/Docker/mariadb/.env.example /srv/Docker/mariadb/.env
    ```

  - Enable each service:

    ```
    systemctl enable caddy php mariadb
    ```

  - Start each service (starting caddy is enough):

    ```
    systemctl start caddy
    ```

  - Go to the domain you set on your .env file and thats it.

## Questions:
- Why /srv/pwk?

  So that I don't accidentally override any file in /srv/piwik by unziping
  piwik.zip by mistake.

- Why Caddy?

  Because it is easy to use, and performs fast enough for my needs.
