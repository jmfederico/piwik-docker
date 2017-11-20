FROM mariadb:10

RUN mkdir -p /srv/mysql-bak
COPY run-innobackupex.sh /usr/local/bin/run-innobackupex
RUN chmod u+x /usr/local/bin/run-innobackupex

ENTRYPOINT []
CMD ["run-innobackupex"]
