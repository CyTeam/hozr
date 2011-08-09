#/bin/bash

set -e

# Libraries
source $(dirname $0)/lib_hozr.sh

if [ -f $RAILS_DIR/tmp/mailing_create_all.lock ] ; then
	find $RAILS_DIR/tmp/mailing_create_all.lock -mmin 15 -exec rm {} \;
fi
