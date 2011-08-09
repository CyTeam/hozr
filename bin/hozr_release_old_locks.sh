#/bin/bash

set -e

source /etc/hozr/hozr.conf

if [ -f $RAILS_DIR/tmp/mailing_create_all.lock ] ; then
	find $RAILS_DIR/tmp/mailing_create_all.lock -mmin 15 -exec rm {} \;
fi
