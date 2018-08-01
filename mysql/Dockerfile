FROM perconalab/percona-xtrabackup

RUN mkdir -p /srv/mysql-bak
COPY run-xtrabackup.sh /usr/local/bin/run-xtrabackup
RUN chmod u+x /usr/local/bin/run-xtrabackup

ENTRYPOINT []
CMD ["run-xtrabackup"]
