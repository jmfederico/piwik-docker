#!/bin/sh

TMPFILE="/tmp/xtrabackup-runner.$$.tmp"
USEROPTIONS="--user=root --password=${MYSQL_ROOT_PASSWORD} --host=mysql"
BACKDIR=/srv/mysql-bak
BASEBACKDIR=$BACKDIR/base
INCRBACKDIR=$BACKDIR/incr
FULLBACKUPCYCLE=604800 # Create a new full backup every X seconds
KEEP=1 # Number of additional backups cycles a backup should kept for.
START=`date +%s`

echo "----------------------------"
echo
echo " run-xtrabackup.sh: MySQL backup script"
echo "started: `date`"
echo

if test ! -d $BASEBACKDIR
then
  mkdir -p $BASEBACKDIR
fi

# Check base dir exists and is writable
if test ! -d $BASEBACKDIR -o ! -w $BASEBACKDIR
then
  error
  echo $BASEBACKDIR 'does not exist or is not writable'; echo
  exit 1
fi

if test ! -d $INCRBACKDIR
then
  mkdir -p $INCRBACKDIR
fi

# check incr dir exists and is writable
if test ! -d $INCRBACKDIR -o ! -w $INCRBACKDIR
then
  error
  echo $INCRBACKDIR 'does not exist or is not writable'; echo
  exit 1
fi

echo "Check completed OK"

# Find latest backup directory
LATEST=`find $BASEBACKDIR -mindepth 1 -maxdepth 1 -type d -printf "%P\n" | sort -nr | head -1`

AGE=`stat -c %Y $BASEBACKDIR/$LATEST`

if [ "$LATEST" -a `expr $AGE + $FULLBACKUPCYCLE + 5` -ge $START ]
then
  echo 'New incremental backup'
  # Create an incremental backup

  # Check incr sub dir exists
  # try to create if not
  if test ! -d $INCRBACKDIR/$LATEST
  then
    mkdir -p $INCRBACKDIR/$LATEST
  fi

  # Check incr sub dir exists and is writable
  if test ! -d $INCRBACKDIR/$LATEST -o ! -w $INCRBACKDIR/$LATEST
  then
    echo $INCRBACKDIR/$LATEST 'does not exist or is not writable'
    exit 1
  fi

  LATESTINCR=`find $INCRBACKDIR/$LATEST -mindepth 1  -maxdepth 1 -type d | sort -nr | head -1`
  if [ ! $LATESTINCR ]
  then
    # This is the first incremental backup
    INCRBASEDIR=$BASEBACKDIR/$LATEST
  else
    # This is a 2+ incremental backup
    INCRBASEDIR=$LATESTINCR
  fi

  TARGETDIR=$INCRBACKDIR/$LATEST/`date +%F_%H-%M-%S`

  # Create incremental Backup
  xtrabackup --backup $USEROPTIONS --target-dir=$TARGETDIR --incremental-basedir=$INCRBASEDIR > $TMPFILE 2>&1
else
  echo 'New full backup'

  TARGETDIR=$BASEBACKDIR/`date +%F_%H-%M-%S`

  # Create a new full backup
  xtrabackup --backup $USEROPTIONS --target-dir=$TARGETDIR > $TMPFILE 2>&1
fi

if [ -z "`tail -1 $TMPFILE | grep 'completed OK!'`" ]
then
  echo "xtrabackup failed:"; echo
  echo "---------- ERROR OUTPUT from xtrabackup ----------"
  cat $TMPFILE
  rm -f $TMPFILE
  rm -rf $TARGETDIR
  exit 1
fi

THISBACKUP=`awk -- "/Backup created in directory/ { split( \\\$0, p, \"'\" ) ; print p[2] }" $TMPFILE`

echo "Databases backed up successfully to: $THISBACKUP"
echo

MINS=$(($FULLBACKUPCYCLE * ($KEEP + 1 ) / 60))
echo "Cleaning up old backups (older than $MINS minutes) and temporary files"

# Delete tmp file
rm -f $TMPFILE
# Delete old bakcups
for DEL in `find $BASEBACKDIR -mindepth 1 -maxdepth 1 -type d -mmin +$MINS -printf "%P\n"`
do
  echo "deleting $DEL"
  rm -rf $BASEBACKDIR/$DEL
  rm -rf $INCRBACKDIR/$DEL
done


SPENT=$(((`date +%s` - $START) / 60))
echo
echo "took $SPENT minutes"
echo "completed: `date`"
exit 0
